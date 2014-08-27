class BookingFormsController < ApplicationController
  before_filter :check_sales_access, :except => [:show, :create, :update, :download]
  before_filter :check_user_parameters, :only => [:create]
  protect_from_forgery :except => [:create, :callback]
  layout "minimal", :except => :download
  
  def show
    @booking = BookingForm.where(:password => params[:p]).find(params[:id])
    if @booking.expired?
      flash.now[:error] = "Unable to proceed to payment. This booking form has expired"
    elsif @booking.amended?
      flash.now[:info] = "This booking form has been superceded by an amended booking form. Please refer to the newer booking or contact the sales team"
    elsif @booking.paid?
      flash.now[:info] = "This booking form has already been paid for"
    elsif !@booking.pending? && !@booking.issued?
      flash.now[:error] = "Unable to proceed to payment. This booking is not marked as pending payment (status: #{@booking.status_name})"
    end
    @booking.booking_form_response = BookingFormResponse.new if @booking.require_response? && !@booking.booking_form_response
    @booking.booking_approval = BookingApproval.new if @booking.allow_invoice? && !@booking.booking_approval
  end
  
  def download
    @booking = BookingForm.where(:password => params[:p]).find(params[:id])
    prawnto :prawn => {:left_margin => 0, :right_margin => 0, :top_margin => 0, :bottom_margin => 0, :page_size => "A4"}
  end
  
  def index
    @status = params[:status].to_i || 1
    @forms = BookingForm.for_listing.for_status_option(@status)
    respond_to do |r|
      r.html do
        @forms = @forms.page(params[:page])
        render :layout => "admin"
      end
      r.csv do
        send_data export_all, :type => "text/csv", :filename => "booking_forms.csv"
      end
    end
  end
  
  # called from the API
  def create
    form = BookingForm.create_or_update(params[:booking_form])
    if form.save
      render :nothing => true
    else
      error = form.errors.messages.keys.map {|key| "#{key} #{form.errors.messages[key].join(", ")}" }.join("\n")
      logger.debug("Invalid booking form: #{error}")
      render :status => 500, :text => "Invalid booking form: #{error}"
    end
  end
  
  def edit
    @booking = BookingForm.find(params[:id])
    render :layout => "admin"
  end
  
  def update
    @booking = BookingForm.where(:password => params[:booking_form][:password]).find(params[:id])
    redirect_to booking_form_path(@booking, :p => @booking.password) if @booking.expired?
    if @booking.require_response?
      @booking.booking_form_response = BookingFormResponse.new if !@booking.booking_form_response
      @booking.booking_form_response.attributes = params[:booking_form][:booking_form_response_attributes]
      @booking.booking_form_response.save
    end
    if params[:invoice].to_i > 0
      if @booking.allow_invoice
        @booking.booking_approval = BookingApproval.new unless @booking.booking_approval
        @booking.booking_approval.attributes = params[:booking_form][:booking_approval_attributes]
        @booking.booking_approval.save
      end
      if @booking.advance_to_invoice!
        flash.now[:info] = "Successfully confirmed your booking to be invoiced"
      else
        flash.now[:error] = "Unable to mark this booking form for invoice. It is not marked as pending payment"
      end
      render :show
    else
      if @booking.pending? || @booking.advance_to_pending!
        @booking.revise_first_payment_date!
        redirect_to "#{worldpay_url}?" + @booking.worldpay_form_options.to_a.map {|a| "#{CGI::escape(a[0].to_s)}=#{CGI::escape(a[1].to_s)}"}.join("&")
      else
        flash.now[:error] = "Unable to proceed to payment. This booking is not marked as pending payment"
        render :show
      end
    end
  end
  
  def complete
    @booking = BookingForm.find(params[:id])
    render :nothing => true, :status => @booking.complete! ? 200 : 500
  end

  def cancel
    @booking = BookingForm.find(params[:id])
    render :nothing => true, :status => @booking.cancel! ? 200 : 500
  end
  
  def search
    @status = params[:status].to_i || 1
    @search = params[:search]
    @forms = BookingForm.for_listing.for_status_option(@status).search @search
    respond_to do |r|
      r.js {render :partial => "list", :layout => false}
      r.html { render "index", layout: "admin" }
    end
  end

  private
  def export_all
    return CSV.generate(:force_quotes => true) do |csv|
      # header row
      csv << ["Created", "Code", "Contact", "Sales Person", "Delegates", "Subtotal", "VAT", "Total", "Status", "Payment Info"]
      # data rows
      @forms.each do |f|
        subtotal = f.total_ex_vat
        csv << [f.created_at.strftime('%d %B %Y %H:%M'), f.filemaker_code, f.contact_name, f.salesperson, f.delegates.size, subtotal, f.vat_rate * subtotal, f.total, f.status_name, f.payment_info]
      end
    end
  end
  
end