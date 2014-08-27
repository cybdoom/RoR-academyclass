class PaymentResponsesController < ApplicationController
  before_filter :check_backend_access, except: [:create]
  protect_from_forgery except: :create
  layout "admin"

  # callback from Worldpay
  def create
    @response = PaymentResponse.create_from_worldpay(worldpay_params)
    @referrer = Referrer.new
    render "referrers/new", :layout => "worldpay"
  end
  
  def index
    @responses = PaymentResponse.ordered.page(params[:page])
  end
  
  def show
    @response = PaymentResponse.find(params[:id])
  end

  private
  def worldpay_params
    params.reject {|k,v| k == 'controller' || k == 'action' }
  end
end