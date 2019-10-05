class ContactsController < ApplicationController
  
  # GET request to /contact-us
  # Show new contact for
  def new
    @contact = Contact.new
  end
  
  # POST request /contacts
  def create
    # Mass assignement of form fields into Contact object
    @contact = Contact.new(contact_params)
    # Save Contact object into database
    if @contact.save
      # Store form fields via parameters into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into Contact Mailer
      # and redirect into new action
      ContactMailer.contact_email(name, email, body).deliver
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      # IF Contact object doesn't save
      # store errors in flash hash,
      # and redirect to the new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  
  private
  # To collect data from form, we need to use
  # strong parameters and whitelist the form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end