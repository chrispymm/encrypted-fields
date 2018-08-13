require 'spec_helper'

RSpec.describe EncryptedFields do
  before(:all) do
    #Ensure we have a DEK for all of the examplkes in this file
    EncryptedFields::DataEncryptionKey.generate!(primary: true)
  end

  it "creates_a_getter_method_for_encrypted_fields" do
    u = User.new()
    expect(u.respond_to?(:email)).to be true
  end

  it "creates_a_setter_method_for_encrypted_fields" do
    u = User.new()
    expect(u.respond_to?(:email=)).to be true
  end

  it "saves_a_model_with_encrypted_attribute" do
    u = User.new(first_name: 'First', last_name: 'Name', email: 'email@test.com')
    expect(u.save).to be true
  end

  it "saves_a_model_with_encrypted_attribute" do
    u = User.new(first_name: 'First', last_name: 'Name', email: 'email@test.com')
    expect(u.save).to be true
  end

  it "creates_an_encrypted_field_record" do
    u = User.create(first_name: 'First', last_name: 'Name', email: 'email@test.com')
    expect(EncryptedFields::EncryptedField.all.length).to be 1
  end

  it "set_the_encrypted_blob_field" do
    u = User.create(first_name: 'First', last_name: 'Name', email: 'email@test.com')
    expect(EncryptedFields::EncryptedField.first.encrypted_blob).to_not be nil
  end

  it "creates_an_iv" do
    u = User.create(first_name: 'First', last_name: 'Name', email: 'email@test.com')
    expect(EncryptedFields::EncryptedField.first.encrypted_blob_iv).to_not be nil
  end

  it "encrypts_the_data" do
    u = User.create(first_name: 'First', last_name: 'Name', email: 'email@test.com')
    expect(EncryptedFields::EncryptedField.first.encrypted_blob).to_not be 'email@test.com'
  end

  it "creates_polymorphic_ref_to_model_class_name" do
    u = User.create(first_name: 'First', last_name: 'Name', email: 'email@test.com')
    expect(EncryptedFields::EncryptedField.first.encryptable_type).to eq "User"
  end

  it "creates_polymorphic_ref_to_model_instance_id" do
    u = User.create(first_name: 'First', last_name: 'Name', email: 'email@test.com')
    expect(EncryptedFields::EncryptedField.first.encryptable_id).to be u.id
  end

  it "creates_a_ref_to_model_field_name" do
    u = User.create(first_name: 'First', last_name: 'Name', email: 'email@test.com')
    expect(EncryptedFields::EncryptedField.first.encryptable_field).to eq 'email'
  end

  it "returns correct plaintext data" do
    u = User.create(first_name: 'First', last_name: 'Name', email: 'email@test.com')
    expect(u.email).to eq 'email@test.com'
  end
end
