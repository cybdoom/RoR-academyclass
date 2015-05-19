class EmailLogsController < ApplicationController
  before_filter :check_admin, :only => [:index, :update, :destroy, :show]
  caches_page :new
  layout "admin", :only => [:index, :show]
  
  def index
    @page = params[:page] || 1
    @type = params[:type] || "Enquiry"
    types = @type == "Enquiry" ? EmailLog.assigned_types : [@type]
    @email_logs = EmailLog.where("type IN (?)", types).includes(:sales_contact).order("id DESC").paginate(:page => @page, :per_page => 50)
  end

  def export
    type = params[:type] || "Enquiry"
    types = type == "Enquiry" ? EmailLog.assigned_types : [type]
    @email_logs = EmailLog.where("type IN (?)", types).includes(:sales_contact).order("id DESC")
    send_data render_emails_csv, :type => "text/csv", :filename => "#{type}_email_logs.csv"
  end
  
  def new
    @email = Contact.new
    @page = "contact-us"
    render :layout => "application"
  end
  
  def create
    email = Contact.new(params[:contact])
    if params[:fcomment].blank? && email.save
      render :text => "Your message has been sent successfully\n#{Contact::GOOGLE_TRACKING_CODE}"
    else
      render :nothing => true, :status => 500
    end
  end  
  
  def update
    @email = EmailLog.find(params[:id])
    @email.sales_contact_id = params[:email_log][:sales_contact_id]
    if @email.save
      session[:url] = ''
      render :nothing => true
    else
      render :nothing => true, :status => 500
    end
  end
  
  def destroy
    @email = EmailLog.find(params[:id])
    @next = @email.previous
    @next = @email.next if @next.nil?
    @email.destroy
    redirect_to @next ? email_log_path(@next) : email_logs_path
  end
  
  def show
    @email = EmailLog.find(params[:id])
    @previous = @email.previous
    @next = @email.next
  end
  
  def newsletter_subscription
    sub = NewsletterSubscription.new(params[:newsletter_subscription])
    response = {}
    if sub.save
      flash.now[:message] = "You have been added to the subscriber list"
    else
      flash.now[:error] = "Your email address is invalid. Please check it."
    end
    response[:saved] = sub.errors.empty?
    response[:partial] = render_to_string(partial: "newsletter_subscription")
    render json: response
  end
  
  def course_enquiry
    @course_enquiry = CourseEnquiry.new(params[:course_enquiry])
    response = {}

    if @course_enquiry.save
      code = '<iframe src ="/adwordstracking.htm" width="0px" height="0px" border="0" style="display:none"></iframe>'
      response[:saved] = true
      response[:msg] = "Your enquiry has been made successfully.#{code}"
    else
      response[:saved] = false
      response[:msg] = "Please enter your name, a valid email address and an enquiry."
    end

    render json: response
  end
  
  #only accepts js requests
  def course_detail_enquiry
    @course_detail_enquiry = CourseDetailEnquiry.new(params[:course_detail_enquiry])
    if @course_detail_enquiry.save
      flash.now[:message] = "Thank you, you should receive an email shortly."
      @course_detail_enquiry = CourseDetailEnquiry.new
      render :partial => "email_logs/course_detail_enquiry"
    else
      flash.now[:error] = "Your email address is invalid. Please check it."
      render :partial => "email_logs/course_detail_enquiry"
    end
  end
  
  private
  def render_emails_csv
    return CSV.generate(:force_quotes => true) do |csv|
      # header row
      csv << ["Received", "Type", "Name", "Email", "Phone", "Subject", "Location", "Date", "Enquiry", "Enquire All", "Recipient Salesperson"]
      # data rows
      @email_logs.each do |e|
        csv << [e.created_at ? e.created_at.strftime("%Y-%m-%d %H:%M") : "unknown", e.type_name, e.name, e.email, e.phone, e.subject, e.location, e.date, e.enquiry, e.opt_in ? "Y" : "N", e.recipient_email]
      end
    end
  end 
end
