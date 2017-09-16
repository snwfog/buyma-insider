class ArticleUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      uri = Addressable::URI.parse(value) rescue nil

      unless uri && value.start_with?(record.merchant.domain)
        record.errors[attribute] << (options[:message] || 'must be a valid merchant article URI/IRI')
      end
    end
  end
end
