class CreateDataEncryptionKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :data_encryption_keys do |t|
      t.string :encrypted_key
      t.string :encrypted_key_iv
      t.boolean :primary

      t.timestamps
    end
  end
end
