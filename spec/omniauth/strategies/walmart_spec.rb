# frozen_string_literal: true

require 'spec_helper'

describe OmniAuth::Strategies::Walmart do

  subject { described_class.new({}) }

  let(:base_url) { 'https://marketplace.walmartapis.com' }

  describe '#client' do
    it 'has default site' do
      expect(subject.client.site).to eq(base_url)
    end

    context '.client_options' do
      it 'has default authorize url' do
        expect(subject.options.client_options.site).to eq(base_url)
      end

      it 'has default authorize url' do
        expect(subject.options.client_options.authorize_url).to eq('https://login.account.wal-mart.com/authorize')
      end

      it 'has default token url' do
        expect(subject.options.client_options.token_url).to eq("#{base_url}/v3/token")
      end
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      expect(subject.callback_path).to \
      eq('/auth/walmart_marketplace/callback')
    end
  end
  
end