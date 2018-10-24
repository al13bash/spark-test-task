require 'csv'

class ProductsImportService
  attr_reader :file_path

  def initialize(file_path:)
    @file_path = file_path
  end

  def run
    outcome = ServiceOutcome.new

    if file_path.present?
      outcome.result = create_products
    else
      outcome.errors.add(:file_path, 'should be present')
    end

    outcome
  end

  private

  def create_products
    CSV.foreach(file_path, col_sep: ';', headers: true, skip_blanks: true) do |row|
      next if row.fields.all?(&:nil?)
      create_product(row)
    end
  end

  def create_product(row)
    taxon = Spree::Taxon.find_or_create_by(name: row['category'])
    Spree::Product.create(
      name: row['name'],
      description: row['description'],
      price: row['price'],
      available_on: row['availability_date'],
      slug: row['slug'],
      taxons: [taxon],
      shipping_category: Spree::ShippingCategory.first
    )
  end
end
