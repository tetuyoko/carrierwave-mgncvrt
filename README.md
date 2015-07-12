# CarrierWave::Mgncvrt

Mgncvrt support for CarrierWave

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carrierwave-mgncvrt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-mgncvrt

## Usage

```ruby
CarrierWave::Mgncvrt.configure do |config|
  config.key = ENV['TINYPNG_KEY']
end
```

```ruby
class YourUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Mgncvrt
  process convert: 'png'
  process :mgncvrt
end
```
