# rubyang

[![Build Status](https://travis-ci.org/hirura/rubyang.svg?branch=master)](https://travis-ci.org/hirura/rubyang)
[![Maintainability](https://api.codeclimate.com/v1/badges/05f5fd598d75872b22d0/maintainability)](https://codeclimate.com/github/hirura/rubyang/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/05f5fd598d75872b22d0/test_coverage)](https://codeclimate.com/github/hirura/rubyang/test_coverage)
[![Gem Version](https://badge.fury.io/rb/rubyang.svg)](https://badge.fury.io/rb/rubyang)

YANG parser and tree structure data store

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubyang'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubyang

## Usage

### Core

You can use Rubyang as yang database or as server

To use rubyang as database, add this line to head of your code:

```ruby
require 'rubyang'
```

You can specify YANG model as String:

```ruby
yang = <<EOB
module rubyang-example {
  namespace 'http://rubyang/example';
  prefix 'rubyang-example';
  container container1 {
    leaf leaf1 {
      type string;
    }
  }
}
EOB
```

And prepare DB for configurations:

```ruby
db = Rubyang::Database.new
```

You can load YANG model to DB:

```ruby
db.load_model Rubyang::Model::Parser.parse( yang )
```

Then configurations can be set with YANG model:

```ruby
db.configure.edit( "container1" ).edit( "leaf1" ).set( "hoge" )
```

And you can see configured data in XML format:

```ruby
puts db.configure.to_xml( pretty: true )
# => <config xmlns='http://rubyang/config/0.1'>
#      <container1 xmlns='http://rubyang/example'>
#        <leaf1>hoge</leaf1>
#      </container1>
#    </config>
```

And also JSON format:

```ruby
puts db.configure.to_json( pretty: true )
# => {
#      "config": {
#        "container1": {
#          "leaf1": "hoge"
#        }
#      }
#    }
```

And to use rubyang as server

```ruby
require 'rubyang/server/base'
```

and create some class inheriting Rubyang::Server::Base class

```ruby
class Example < Rubyang::Server::Base
end
```

now you can run server

```ruby
example = Example.new
example.run
```

you can connect to this server with cli.rb

```ruby
require 'rubyang/cli'

cli = Rubyang::Cli.new
cli.run
```

### Additional Component

Rubyang provides component mechanism to develop some component for users.
Users can develop some components and load those components.
The components which is defined as "hook commit" in configuraion are called when commit is executed.

Example component is stored in "/path/to/rubyang/component/example.rb"

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hirura/rubyang. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).

