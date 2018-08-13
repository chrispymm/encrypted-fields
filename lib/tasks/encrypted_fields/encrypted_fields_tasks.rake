namespace :encrypted_fields do

  desc "Ceate and set a new primary Data Encryption Key.  Re-encrypt all EncryptedFields with new key. Remove any unused DEK's"
  task :rotate_dek => :environment do
    new_dek = DataEncryptionKey.generate!
    new_dek.promote!
    puts 'New primary DEK created.'
    puts 'Re-Encrypting fields...'

    EncryptedField.find_each do |field|
      field.reencrypt!(new_dek)
      print '.'
    end
    puts 'All fields re-encrypted'

    DataEncryptionKey.unused.map(&:destroy)
    puts 'All unused keys removed.'
  end

  desc "Re-Encrypt all DEK's with a new Encryption Key"
  task :rotate_kek, [:kek] => [:environment] do |t, args|
    args.with_defaults(:kek => nil);
    abort("You must supply a new kek") unless args[:kek].present?

    new_kek = args[:kek]

    DataEncryptionKey.find_each do |dek|
      decrypted_key = dek.key
      dek.temporary_key = new_kek
      dek.update_attributes!(key: decrypted_key) # this should re-encrypt the key field with new KEK
      print '.'
    end
    puts 'All keys re-encrypted.'
  end
end
