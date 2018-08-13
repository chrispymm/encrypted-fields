require 'rails/generators'
require 'rails/generators/migration'

module EncryptedFields
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    desc "Add the migrations for Encrypted Fields"

    def self.next_migration_number(path)
      next_migration_number = current_migration_number(path) + 1
      ActiveRecord::Migration.next_migration_number(next_migration_number)
    end

    def copy_migrations
      migration_template "create_data_encryption_keys.rb", "db/migrate/create_data_encryption_keys.rb"
      migration_template "create_encrypted_fields.rb", "db/migrate/create_encrypted_fields.rb"
      say("Migration files copied.  Now run Rake db:migrate", :yellow)
    end
  end
end
