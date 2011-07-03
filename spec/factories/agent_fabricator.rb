Fabricator(:agent) do
  email { Faker::Internet.email }
  password "weather"
  password_confirmation "weather"
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
end
