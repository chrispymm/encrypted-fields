# EncryptedFields
Short description and motivation.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'encrypted_fields'
```

And then execute:
```bash
$ rails g encrypted_fields:install
$ rake db:migrate
```

## Usage
Create your master Key Encryption Key and save it in Rails credentials.yml
1. Generate a 32 byte key. e.g. run `rails c` and copy the output of the following command:
```ruby
SecureRandom.hex(16)
```
2. Open your credentials.yml file
```bash
EDITOR=nano rails credentials edit
```
3. Paste in the copied value under the key 'key_encryption_key'
```yml
key_encryption_key: 125dfyq3f7diurgvi7d3i
```
Generate your Data Encryption Key
In rails console run the following
```ruby
EncryptedFields::DataEncryptionKey.generate!(primary: true)
```

Include the module in your apps ApplicationRecord file
```ruby
class ApplicationRecord < ActiveRecord::Base
  include EncryptedFields::HasEncryptedFields

  self.abstract_class = true
end
```

Add the has_encrypted_fields method to any ActiveRecord Model you with
```ruby
has_encrypted_fields :attr_1, :attr_2, :attr_3
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
