class CustomersController < ApplicationController
  before_action :logged_in_employee, only: [:index,:destroy, :show_info]
  before_action :logged_in_customer, only: [:edit, :update, :show]
  before_action :correct_customer,   only: [:edit, :update, :show]
 
  def new
    @customer = Customer.new
  end
  
  def show
    @customer = Customer.find(params[:id])
    @tickets = @customer.tickets.paginate(page: params[:page])
    @ticket = current_customer.tickets.build if customer_logged_in?
    @comment = current_customer.tickets.first.comments.build if customer_logged_in?
    @catagories = TicketCatagory.all
    @open_tickets = @customer.tickets.where(ticket_open: true)
    @closed_tickets = @customer.tickets.where(ticket_open: false)
  end
  
  def show_info
    @customer = Customer.find(params[:id])
    @tickets = @customer.tickets.paginate(page: params[:page])
    @open_tickets = @customer.tickets.where(ticket_open: true)
    @closed_tickets = @customer.tickets.where(ticket_open: false)

    customer_id = params[:customer_id]
    if !customer_id.nil?
      @customer = Customer.find(customer_id)
    end
    @employee = current_employee
    @ticket = @tickets.build if employee_logged_in?
    @catagories = TicketCatagory.all
  end
  
  def index
    if params[:search] == ''  #checks if search field contains anything. This is usefull, when user searches for something then deletes the search
      @customers = Customer.all.paginate(page: params[:page])
    elsif params[:search]
      @customers = Customer.where(:first_name => params[:search]).paginate(page: params[:page])
    else
      @customers = Customer.all.paginate(page: params[:page])
    end
  end
  
  
  def create
    @customer = Customer.new(customer_params)       # Not the final implementation!
    if @customer.save
      customer_log_in @customer
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @customer
    else
      render 'new'
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      flash[:success] = "Profile updated"
      redirect_to @customer
    else
      render 'edit'
    end
  end
  
  def destroy
    Customer.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to customers_url
  end
  
  
  private

    def customer_params
      params.require(:customer).permit(:first_name, :last_name, :email, :password,
                                   :password_confirmation)
    end
  
    # Confirms a logged-in user.
    def logged_in_customer
      unless customer_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to customer_login_url
      end
    end

    # Confirms a logged-in user.
    def logged_in_employee
      unless employee_logged_in?
        flash[:danger] = "You do not have Access"
        redirect_to employee_login_url
      end
    end

    # Returns true if the user is logged in, false otherwise.
    def employee_logged_in?
      !current_employee.nil?
    end
    
    # Confirms the correct user.
    def correct_customer
      @customer = Customer.find(params[:id])
      redirect_to(root_url) unless @customer == current_customer
    end
end
