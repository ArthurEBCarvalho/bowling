require 'spec_helper'
require 'exceptions/invalid_file'

RSpec.describe InvalidFile do
  describe '#message' do
    subject { described_class.new(error_message).message }

    let(:error_message) { 'some error message' }

    it { is_expected.to eq("Error: #{error_message}") }
  end
end
