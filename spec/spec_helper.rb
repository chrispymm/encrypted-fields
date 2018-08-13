ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'encrypted_fields'
require 'database_cleaner'
# require 'rspec/autorun'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|

 # config.use_transactional_fixtures = true

 config.expect_with :rspec do |expectations|
   expectations.include_chain_clauses_in_custom_matcher_descriptions = true
 end

 config.mock_with :rspec do |mocks|
   mocks.verify_partial_doubles = true
 end

 config.shared_context_metadata_behavior = :apply_to_host_groups
 config.filter_run_when_matching :focus
 config.example_status_persistence_file_path = "spec/examples.txt"
 config.disable_monkey_patching!
 config.warnings = false

 if config.files_to_run.one?
   config.default_formatter = "doc"
 end

 config.profile_examples = 10
 config.order = :random
 Kernel.srand config.seed

 config.before(:suite) do
  # EncryptedFields::DataEncryptionKey.generate!(primary: true)
 end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation, {:except => %w[data_encryption_keys]})
  end
end
