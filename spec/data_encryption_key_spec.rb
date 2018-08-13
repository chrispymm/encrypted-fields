require 'spec_helper'

RSpec.describe EncryptedFields::DataEncryptionKey do
  before(:each) do
    #start with a blank slate of keys
    EncryptedFields::DataEncryptionKey.all.each(&:destroy)
  end

  describe "#primary" do
    it "returns the primary key" do
      primary = EncryptedFields::DataEncryptionKey.create!( key: SecureRandom.hex(16), primary: true )
      non_primary = EncryptedFields::DataEncryptionKey.create!( key: SecureRandom.hex(16), primary: false )
      expect(EncryptedFields::DataEncryptionKey.primary).to eq primary
      expect(EncryptedFields::DataEncryptionKey.primary).to_not eq non_primary
    end

  end

  describe "#generate" do
    it "creates a new key" do
      EncryptedFields::DataEncryptionKey.generate!
      expect(EncryptedFields::DataEncryptionKey.all.length).to eq 1
    end

    it "creates sets the key and iv" do
      EncryptedFields::DataEncryptionKey.generate!
      expect(EncryptedFields::DataEncryptionKey.last.encrypted_key).to_not be nil
      expect(EncryptedFields::DataEncryptionKey.last.encrypted_key_iv).to_not be nil
    end

    it "merges attributes passed in" do
      EncryptedFields::DataEncryptionKey.generate!(primary: true)
      expect(EncryptedFields::DataEncryptionKey.last.primary).to be true
    end
  end

  describe "#unused" do
    it "returns non-primary keys" do
      primary = EncryptedFields::DataEncryptionKey.create!( key: SecureRandom.hex(16), primary: true )
      non_primary = EncryptedFields::DataEncryptionKey.create!( key: SecureRandom.hex(16), primary: false )

      expect(EncryptedFields::DataEncryptionKey.unused.length).to be 1
      expect(EncryptedFields::DataEncryptionKey.unused.first).to eq non_primary
    end

    it "does not return a non-primary key that has encrypted fields" do
      primary = EncryptedFields::DataEncryptionKey.create!( key: SecureRandom.hex(16), primary: true )
      #non_primary = EncryptedFields::DataEncryptionKey.create!( key: SecureRandom.hex(16), primary: false )
      u = User.create(first_name: 'First', last_name: 'Name', email: 'email@test.com')

      primary.update_attributes(primary: false)

      expect(EncryptedFields::DataEncryptionKey.unused.length).to be 0
    end
  end

  describe ".promote!" do
    it "sets the key to be primary" do
      old_primary = EncryptedFields::DataEncryptionKey.create!( key: SecureRandom.hex(16), primary: true )
      new_primary = EncryptedFields::DataEncryptionKey.create!( key: SecureRandom.hex(16), primary: false )

      new_primary.promote!

      expect(new_primary.primary).to be true
    end

    it "sets the old primary key to not be primary" do
      old_primary = EncryptedFields::DataEncryptionKey.create!( key: SecureRandom.hex(16), primary: true )
      new_primary = EncryptedFields::DataEncryptionKey.create!( key: SecureRandom.hex(16), primary: false )

      new_primary.promote!
      old_primary.reload

      expect(old_primary.primary).to be false
    end


  end


end
