require 'test_helper'

class ContctTest < ActiveSupport::TestCase
  def new_contact
    Contact.new kind: :social, social_type: :slack, value: 'http://some-link.com'
  end

  test "contact should not be created without value" do
    contact = new_contact
    contact.value = ""
    assert contact.invalid?
    contact.errors[:value]
    contact.value = "http://some-link.com"
    assert contact.valid?
  end

  test "value should be uniq" do
    assert_no_difference 'Contact.count'  do
      contact = Contact.create kind: :email, value: 'second@value.com'
    end
  end

  test "social type must be present if contact type is social " do
    contact = new_contact
    contact.social_type = nil
    assert contact.invalid?
    contact.errors[:social_type]
    contact.social_type = Contact.social_types.values.first
    assert contact.valid?
  end

  test "value shold be valid" do
    contact = new_contact
    contact.kind = :email
    contact.value = ""
    assert contact.invalid?
    contact.errors[:email]
    contact.value = "231.dsd"
    assert contact.invalid?
    contact.errors[:email]
    contact.value = "ddfs@."
    assert contact.invalid?
    contact.errors[:email]
    contact.value = "daniel.defoe@gmail.com"
    assert new_contact.valid?
  end

end
