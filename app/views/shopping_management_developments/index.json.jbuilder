json.array!(@shopping_management_developments) do |shopping_management_development|
  json.extract! shopping_management_development, :categoryCd, :goods, :date, :amount, :sum, :place
  json.url shopping_management_development_url(shopping_management_development, format: :json)
end
