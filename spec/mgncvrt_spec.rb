require 'spec_helper'

describe CarrierWave::Mgncvrt do

  before do
    @original_file_path = file_path('white.png')
    @processed_file_path = file_path('black.png')

    @file_path = @original_file_path
    @file = File.open(@file_path)

    @klass = Class.new(CarrierWave::Uploader::Base) do
      include CarrierWave::Mgncvrt
    end

    @instance = @klass.new
    allow(@instance).to receive_messages cached?: :true
    @instance.cache! @file
  end

  describe '#mgncvrt' do

    let(:successful_location) { 'https://api.mgncvrt.com/output/successful.png' }
    before do
      stub_request(:post, /api\.mgncvrt\.com/)
          .to_return(status: api_status,
                     body: api_response,
                     headers: {
                         'Location' => successful_location
                     })
      stub_request(:get, /api\.mgncvrt\.com/)
          .to_return(status: 200,
                     body: File.binread(@processed_file_path))
    end

    context 'when successful' do
      let(:api_status) { 201 }
      let(:api_response) do
        <<'JSON'
{
  "input": {
    "size": 207565,
    "type": "image/png"
  },
  "output": {
    "size": 63669,
    "type": "image/png",
    "ratio": 0.307
  }
}
JSON
      end

      it 'uploads file to Mgncvrt' do
        stub_request(:post,'https://api:testkey@api.mgncvrt.com/shrink')
            .with(body: File.binread(@file_path))
            .to_return(status: 201,
                       body: api_response,
                       headers: {
                           'Location' => successful_location
                       })
        @instance.mgncvrt
      end

      it 'gets file from Location' do
        stub_request(:get, successful_location)
            .to_return(status: 200,
                       body: File.binread(@processed_file_path))
        @instance.mgncvrt
      end

      it 'replaces the processed file.' do
        expect(File).to receive(:binwrite)
                            .with(@instance.current_path,
                                  File.binread(@processed_file_path))
        @instance.mgncvrt
      end
    end

    context 'when unsuccessful' do
      let(:api_status) { 415 }
      let(:api_response) do
        <<'JSON'
{
  "error": "ERROR_TYPE",
  "message": "ERROR_MESSAGE"
}
JSON
      end

      it 'raises a CarrierWave::ProcessingError' do
        expect { @instance.mgncvrt }.to raise_error(CarrierWave::ProcessingError)
      end

      it 'includes an error of the response' do
        begin
          @instance.mgncvrt
        rescue CarrierWave::ProcessingError => e
          expect(e.message).to match('ERROR_TYPE')
          expect(e.message).to match('ERROR_MESSAGE')
        end
      end
    end
  end

end
