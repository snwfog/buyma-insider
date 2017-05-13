module AsciiFolding
  def self.fold(str)
    str.tr('–', '-')
  end
end