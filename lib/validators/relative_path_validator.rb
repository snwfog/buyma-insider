class RelativePathValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, relative_path)
    uri = URI(relative_path) rescue nil
    sanitized_relative_path = "#{uri.path}"
    sanitized_relative_path << "?#{uri.query}" unless uri.query.blank?
    if !uri || relative_path != sanitized_relative_path
      record.errors[attribute] << (options[:message] || 'must be a relative path')
    end
  end
end