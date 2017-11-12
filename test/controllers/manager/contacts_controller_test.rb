require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @contact = contacts(:telephone)
    sign_in managers :first #Login as manager
  end

  I18n.available_locales.each do |locale|
    I18n.locale = locale
    test "should show all contacts #{locale}" do
      get manager_contacts_path locale: locale
      assert_response :success
      assert_equal "index", @controller.action_name
    end

    test "should show new contact form #{locale}" do
      get new_manager_contact_path locale: locale
      assert_response :success
      assert_equal "new", @controller.action_name
    end

    test "should show edit contact form #{locale}" do
      get edit_manager_contact_path @contact, locale: locale
      assert_response :success
      assert_equal "edit", @controller.action_name
    end

    test "should create contact #{locale}" do
      assert_difference 'Contact.count' do
        post manager_contacts_path(locale: locale ), params: { contact: { kind: :telephone, value: "380632323342" }}
      end
      assert_redirected_to manager_contacts_path locale: locale
      assert_equal (I18n.translate 'manager.contacts.flash.create.success'), flash[:notice]
    end

    test "should not create contact if params are missing #{locale}" do
      assert_no_difference 'Contact.count' do
        post manager_contacts_path(locale: locale), params: { contact: { kind: :telephone } }
      end
      assert_equal (I18n.translate 'manager.contacts.flash.create.failure'), flash[:notice]
    end

    test "should update contact #{locale}" do
      put manager_contact_path(@contact, locale: locale), params: { contact: { value: "380632323342"}}
      assert_equal (I18n.translate 'manager.contacts.flash.update.success'), flash[:notice]
    end

    test "should not update contact if validation is failed #{locale}" do
      put manager_contact_path(@contact, locale: locale), params: { contact: { value: "" } }
      assert_equal (I18n.translate 'manager.contacts.flash.update.failure'), flash[:notice]
    end

    test "should destroy contact #{locale}" do
      assert_difference 'Contact.count', -1 do
        delete manager_contact_path @contact, locale: locale
      end
      assert_redirected_to manager_contacts_path locale: locale
      assert_equal (I18n.translate 'manager.contacts.flash.destroy.success.'), flash[:notice]
    end
  end
end
