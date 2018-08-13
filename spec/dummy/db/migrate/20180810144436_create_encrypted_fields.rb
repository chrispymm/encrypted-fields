class CreateEncryptedFields < ActiveRecord::Migration[5.2]
  def change
    create_table :encrypted_fields do |t|
      t.references :data_encryption_key, foreign_key: true
      t.text :encrypted_blob
      t.string :encrypted_blob_iv
      t.references :encryptable, polymorphic: true
      t.string :encryptable_field

      t.timestamps
    end

    add_index :encrypted_fields, [:encryptable_type, :encryptable_id, :encryptable_field], unique: true, name: :index_encrypted_fields_on_encryptable
  end
end
