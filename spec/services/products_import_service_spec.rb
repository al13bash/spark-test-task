require 'rails_helper'

RSpec.describe ProductsImportService, type: :service do
  subject { described_class.new(file_path: file_path) }
  before { Spree::ShippingCategory.create!(name: 'Default') }
  let(:file_path) { 'sample.csv' }

  context 'file with valid data' do
    it 'creates new products' do
      expect { subject.run }.to change { Spree::Product.count }.by 3
    end

    it 'returns service outcome' do
      expect(subject.run).to be_a(ServiceOutcome)
    end
  end

  context 'no file' do
    let(:file_path) { nil }

    it 'does not create new products' do
      expect { subject.run }.to_not(change { Spree::Product.count })
    end

    it 'returns errors' do
      expect(subject.run.errors.messages).to eq(file_path: ['should be present'])
    end
  end

  context 'empty file path string' do
    let(:file_path) { '' }

    it 'does not create new products' do
      expect { subject.run }.to_not(change { Spree::Product.count })
    end

    it 'returns errors' do
      expect(subject.run.errors.messages).to eq(file_path: ['should be present'])
    end
  end

  context 'empty file' do
    let(:file_path) { 'spec/support/file.txt' }

    it 'does not create new products' do
      expect { subject.run }.to_not(change { Spree::Product.count })
    end

    it 'does not return errors' do
      expect(subject.run.errors.messages).to eq({})
    end
  end
end
