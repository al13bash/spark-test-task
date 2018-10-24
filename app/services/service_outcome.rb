class ServiceOutcome
  extend ActiveModel::Naming

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end

  attr_reader :errors
  attr_accessor :result

  def valid?
    errors.empty?
  end

  def self.human_attribute_name(attr, _options = {})
    attr.to_s.humanize
  end
end
