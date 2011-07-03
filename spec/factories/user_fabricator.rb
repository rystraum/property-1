Fabricator(:user) do
  email { Faker::Internet.email }
  password "weather"
  password_confirmation "weather"
  after_create { |u| u.confirm! }
end
