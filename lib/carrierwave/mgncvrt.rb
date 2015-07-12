require "carrierwave/mgncvrt/version"
require 'net/https'
require 'uri'

module CarrierWave
  module Mgncvrt

    def self.configure
      yield configuration
    end

    def self.configuration
      @configuration ||= CarrierWave::Mgncvrt::Configuration.new
    end

    class Configuration
      attr_accessor :key
    end

    def mgncvrt
      cache_stored_file! if !cached?

      key = CarrierWave::Mgncvrt.configuration.key
      input = current_path
      output = current_path

      uri = URI.parse('http://cvtr.savept.com/convert')

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = false

      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth('api', key)

      response = http.request(request, File.binread(input))
      json = JSON.parse(response.body, :symbolize_names => true) || {}

      if response.code == '201'
        File.binwrite(output, http.get(response['location']).body)
      else
        raise CarrierWave::ProcessingError,
              I18n.translate(:'errors.messages.mgncvrt_processing_error',
                             :error => json[:error],
                             :message => json[:message],
                             :default => I18n.translate(:'errors.messages.mgncvrt_processing_error',
                                                        :locale => :en))
      end
    end
  end
end

if defined?(Rails)
  module CarrierWave
    module Mgncvrt
      class Railtie < Rails::Railtie
        initializer 'carrierwave_mgncvrt.setup_paths' do |app|
          available_locales = app.config.i18n.available_locales.present? ?
              [app.config.i18n.available_locales].flatten : []
          available_locales_pattern = available_locales.empty? ?
              '*' : "{#{ available_locales.join(',') }}"
          files = Dir[File.join(File.dirname(__FILE__),
                                'locale',
                                "#{available_locales_pattern}.yml")]
          I18n.load_path = files.concat(I18n.load_path)
        end
      end
    end
  end
end
