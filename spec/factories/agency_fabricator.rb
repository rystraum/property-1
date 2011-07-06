Fabricator :agency do
  admin { Fabricate(:user, first_name: "Bob", last_name: "Smith") }
  name { Faker::Lorem.sentence }
end
  