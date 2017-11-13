class Manager::ContactsController < ApplicationController
  before_action :authenticate_manager!
  before_action :_set_contact, only:[:edit, :update, :destroy, :create]

  layout 'managers/dashboard'

  def index
    @contacts = {}
    Contact.kinds.keys.each{ |kind| @contacts[kind] = Contact.public_send kind }
  end

  def new
    @contact = Contact.new
  end

  def edit
  end

  def create
    @contact = Contact.new _permitted_contact_params
    respond_to do |format|
      if @contact.save
        format.html { redirect_to manager_contacts_path, notice: (t 'manager.contacts.flash.create.success') }
      else
        format.html { render :new }
        flash.now.notice = t 'manager.contacts.flash.create.failure'
      end
    end
  end

  def update
    respond_to do |format|
      if @contact.update _permitted_contact_params
        format.html { redirect_to manager_contacts_path, notice: (t 'manager.contacts.flash.update.success') }
      else
        format.html { render :edit }
        flash.now.notice = t 'manager.contacts.flash.update.failure'
      end
    end
  end

  def destroy
    respond_to do |format|
      if @contact.destroy
        format.html { redirect_to manager_contacts_path, notice: t('manager.contacts.flash.destroy.success') }
      else
        format.html { redirect_to manager_contacts_path, notice: (t 'manager.contacts.flash.destroy.failure')}
      end
    end
  end

private

  def _set_contact
    @contact = Contact.find_by_id params[:id]
  end

  def _permitted_contact_params
    params.require(:contact).permit(:kind, :value, :social_type )
  end

end
