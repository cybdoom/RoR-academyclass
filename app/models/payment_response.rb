class PaymentResponse < ActiveRecord::Base
  belongs_to :payable, :polymorphic => true
  before_validation :update_payable, :on => :create

  scope :ordered, order("created_at DESC")
  
  def self.create_from_worldpay(params)
    response = PaymentResponse.new
    response.process!(params)#.merge!(Hash[*raw_post.scan(/(\w+)\=(.+?)&/).flatten]))
    response
  end
  
  def booking_form?
    payable_type == "BookingForm"
  end

  def successful_payment?
    success && !auth_amount.nil?
  end
  
  def process!(params)
    self.payable_id = params[:cartId]
    self.payable_type = "BookingForm"
    self.transaction_id = params[:transId]
    self.transaction_status = params[:transStatus]
    self.auth_amount = params[:authAmount]
    self.auth_currency = params[:authCurrency]
    self.raw_auth_message = params[:rawAuthMessage]
    self.avs = params[:AVS]
    self.waf_merch_message = params[:wafMerchMessage]
    self.authentication = params[:authentication]
    self.ip_address = params[:ipAddress]
    @callback_password = params[:callbackPW]
    @futurePayId = params[:futurePayId]
    save
  end
  
  def update_payable
    self.success = false
    if @callback_password != WORLDPAY_CALLBACK_PASSWORD
      self.processed_message = "Invalid callback password (#{@callback_password}) Ignoring this response"
    elsif transaction_status != "Y"
      self.processed_message = "Transaction cancelled (response status should be 'Y')"
    elsif auth_currency != "GBP"
      self.processed_message = "Invalid currency (should be GBP)"
    else
      update_booking if booking_form?
    end
    true
  end

  def update_booking
    form = BookingForm.find(payable_id) rescue nil
    if !form
      self.processed_message = "Booking not found with ID #{payable_id}"
    elsif !form.can_be_paid?
      self.processed_message = "Booking does not have pending status (status currently #{form.status_name})"
    elsif form.split_payment? && @futurePayId && auth_amount.nil?
      self.processed_message = "Split payments approved successfully"
      self.success = true
      form.payment_received!
    elsif !form.valid_payment_amount?(auth_amount)
      self.processed_message = "Booking amount mismatch (should be #{form.payment_amount})"
    else
      self.processed_message = "Payment completed successfully"
      self.success = true
      form.payment_received!
    end
  end
end