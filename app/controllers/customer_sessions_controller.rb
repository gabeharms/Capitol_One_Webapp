class CustomerSessionsController < ApplicationController
  
  def new
  end
  
  def create
    customer = Customer.find_by(email: params[:session][:email].downcase)
    if customer && customer.authenticate(params[:session][:password])
      customer_log_in customer
      redirect_to  customer
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    customer_log_out
    redirect_to root_url
  end
  
  private
    
     # Logs in the given user.
    def customer_log_in(customer)
      session[:customer_id] = customer.id
    end
    
    # Logs out the current user.
    def customer_log_out
      session.delete(:customer_id)
      @current_customer = nil
    end
    
     # Returns the current logged-in user (if any).
    def current_customer
      @current_customer ||= Customer.find_by(id: session[:customer_id])
    end
end

