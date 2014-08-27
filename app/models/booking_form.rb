class BookingForm < ActiveRecord::Base
  attr_accessor :reset
  validates_presence_of :valid_to, :password, :status, :vat_rate
  has_many :delegates, :class_name => "BookingDelegate", :autosave => true
  has_one :booking_amendment
  has_many :payment_responses, :as => :payable
  has_one :booking_form_response, :autosave => true
  has_one :booking_approval, :autosave => true
  before_validation :check_unique_filemaker_code
  before_validation :generate_password, :on => :create
  before_validation :set_initial_status
  before_validation :set_valid_to
  before_validation :set_default_payment_count
  before_validation :set_default_vat
  after_save :send_email
  accepts_nested_attributes_for :delegates, :booking_form_response, :booking_approval
  
  ISSUED = 1 # the booking form has been created in filemaker and the customer has been emailed asking to complete payment
  AMENDED = 2 # the customer has flagged this booking needs amendments, so a new booking form will be issue to supercede this one
  PENDING = 3 # the customer has confirmed the details are correct and they've elected to pay online
  PART_PAID = 8 # the customer has authorized their card for 2 payments, or the first (of 2) payments has been received
  PAID = 4 # the customer has successfully completed the online payment
  INVOICE = 5 # the customer has requested to be invoiced
  CANCELLED = 6 # the salesperson has cancelled the booking, probably because the customer no longer wants to attend
  COMPLETED = 7 # the sale has been completed and recorded in filemaker
  
  scope :current, where('status IN (?)', [ISSUED, AMENDED, PENDING, INVOICE])
  scope :not_cancelled, where(:status => [ISSUED, AMENDED, PENDING, PAID, INVOICE, COMPLETED, PART_PAID])
  scope :search, lambda {|search| where("filemaker_code LIKE ? OR contact_name LIKE ? OR company LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")}
  scope :for_listing, includes(:payment_responses, :booking_approval, :delegates)

  def self.create_or_update(params)
    form = BookingForm.not_cancelled.find_by_filemaker_code(params["filemaker_code"]) || BookingForm.new
    form.delete_delegates_if_mismatched(params) if !form.new_record? && params["delegates_attributes"]
    form.attributes = params
    form.reset = (form.changed? || form.reset) && !form.in_final_state?
    form
  end

  def delete_delegates_if_mismatched(params)
    if all_delegates_match?(params["delegates_attributes"])
      params.delete("delegates_attributes")
    else
      self.delegates.clear
      self.reset = !in_final_state?
    end
  end    

  def all_delegates_match?(attributes)
    !attributes.any? {|hash| !a_delegate_matches?(hash)}
  end

  def a_delegate_matches?(hash)
    delegates.any? {|d| d.matches?(hash)}
  end

  def split_payment?
    !first_payment_date.nil?
  end

  def payment_schedule
    split_payment? ? (0..payment_count-1).map {|i| first_payment_date >> i} : nil
  end

  def valid_payment_amount?(amount)
    payment_amount == amount
  end

  def payment_amount
    split_payment? ? (total / payment_count).round(2)  : total
  end

  # if the course is 'custom' they must answer some questions about the course
  def require_response?
    booking_type == 'Custom' && delegates.select {|d| d.onsite? }.length > 0
  end
  
  def issued?
    status == ISSUED
  end
  
  def pending?
    status == PENDING
  end
  
  def amended?
    status == AMENDED
  end
  
  def invoice?
    status == INVOICE
  end

  def part_paid?
    status == PART_PAID
  end
  
  def paid?
    status == PAID
  end

  def expired?
    valid_to < Time.now
  end
  
  def in_final_state?
    status == PAID || status == CANCELLED || status == COMPLETED
  end
  
  def can_be_paid?
    part_paid? || (!expired? && (issued? || pending?))
  end
  
  def can_be_completed?
    status == PAID || status == INVOICE
  end
  
  def can_be_cancelled?
    return issued? || pending? || amended? || part_paid? || status == INVOICE
  end
  
  def self.for_status_option(option)
    statuses = option == 4 ? PART_PAID : option == 3 ? COMPLETED : option == 2 ? CANCELLED : [ISSUED, AMENDED, PENDING, PAID, INVOICE]
    where(:status => statuses).order(option == 2 || option == 3 ? "created_at DESC" : "created_at")
  end
  
  def cancel!
    if can_be_cancelled?
      self.status = CANCELLED
      save
      return true
    end
  end

  def complete!
    set_status(COMPLETED) if can_be_completed?
  end

  def advance_to_invoice!
    set_status(INVOICE) if (issued? || pending?) && allow_invoice
  end
  
  def advance_to_pending!
    set_status(PENDING) if issued?
  end
  
  def payment_received!
    if split_payment?
      if successful_payments_received + 1 == payment_count
        set_status PAID
      else
        mark_part_paid!
      end
    else
      set_status PAID
    end
  end

  def successful_payments_received
    payment_responses.select {|p| p.successful_payment? }.count
  end

  def mark_part_paid!
    set_status PART_PAID
  end

  def mark_paid!
    set_status PAID if can_be_paid?
  end
  
  def set_valid_to
    self.valid_to = Date.today + 14.days if reset
  end
  
  def generate_password
    self.password = ""
    letters = ("A".."Z").to_a
    30.times {|i| self.password += letters[rand(26).to_i]}
  end
  
  def set_initial_status
    self.status = ISSUED if reset
  end
  
  def check_unique_filemaker_code
    form = BookingForm.where("status IN (?) AND filemaker_code=?", [ISSUED, AMENDED, PENDING, PAID, INVOICE, COMPLETED], filemaker_code)
    form = form.where("id <> ?", id) unless new_record?
    if form.count > 0
      errors.add(:base, "Filemaker code already taken")
      return false
    end
    true
  end
  
  def vat
    vat_rate * 100
  end
  
  def total_ex_vat
    (delegates.map {|d| d.price}.reduce :+) || 0
  end
  
  def total
    (total_ex_vat * (1+vat_rate)).round(2)
  end
  
  def payment_info
    return "Invoice" if booking_approval
    status = "Unpaid"
    payment_responses.each do |p|
      if p.success
        status = "Online payment"
        break
      else
        status = "Payment failed"
      end
    end
    return status
  end

  def status_name
    case status
      when ISSUED then return "Issued"
      when AMENDED then return "Amendment"
      when PENDING then return "Awaiting payment"
      when PAID then return "Paid"
      when INVOICE then return "Client Invoice"
      when CANCELLED then return "Cancelled"
      when COMPLETED then return "Completed"
      when PART_PAID then return "Part Paid"
      else "Unknown (#{status})"
    end
  end
  
  def send_email
    SiteMailer.booking_form_email(self).deliver if reset
  end

  def revise_first_payment_date!
    # if the first payment date is before today, update it to be today and take first payment immediately
    if split_payment? && first_payment_date < Date.today
      self.first_payment_date = Date.today
      save
    end
  end
  
  def worldpay_form_options
    options = { :desc => "Academy Class Booking",
      :currency => "GBP",
      :name => contact_name,
      :address => address,
      :postcode => postcode,
      :country => "GB",
      :tel => telephone,
      :email => email,
      :instId => WORLDPAY_INSTALLATION_ID,
      :cartId => id,
      :testMode => Rails.env.production? ? 0 : 100
    }
    if split_payment?
      options[:futurePayType] = "regular"
      options[:option] = 0
      options[:normalAmount] = payment_amount
      options[:intervalUnit] = 3 # month
      options[:intervalMult] = 1
      if first_payment_date <= Date.today # the first date must be tomorrow or later
        options[:amount] = payment_amount
        options[:startDate] = (Date.today + 1.month).strftime('%Y-%m-%d')
        options[:noOfPayments] = payment_count - 1
      else
        options[:startDate] = first_payment_date.strftime('%Y-%m-%d')
        options[:noOfPayments] = payment_count
      end
    else
      options[:amount] = total
    end
    options
  end

  private
  def set_status(status)
    self.status = status
    save
  end

  def set_default_vat
    self.vat_rate ||= 0
  end    

  def set_default_payment_count
    self.payment_count = 2 if payment_count.blank? && split_payment?
  end
end
