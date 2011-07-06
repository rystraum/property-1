# TODO: This should fabricate by inheritance:
#
#          Fabricator :agent, :from => :user, :class_name => :agent do
#
#       It's not working in 1.0.1.
#
Fabricator :agent do
  agency!
  email { Faker::Internet.email }
  password "weather"
  password_confirmation "weather"
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
end
