class TrainersController < ApplicationController
  before_filter :check_admin
  layout "admin"
  
  def create
    @trainer = Trainer.new(params[:trainer])
    if @trainer.save
      render :json => @trainer
    else
      render :json => {:error => @trainer.errors.full_messages.join("\n")}
    end
  end
  
  def search
    render :json => Trainer.all(:conditions => ["name LIKE ?", "%" + params[:id] + "%"]).to_json
  end
end
