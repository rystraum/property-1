# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :listing do |f|
  f.latitude 1.5
  f.longitude 1.5
  f.title "MyString"
  f.user_id nil
  f.land_area 1
  f.residence_area 1
  f.residene_construction "MyString"
  f.beach_front false
  f.near_beach false
  f.residence_type "MyString"
  f.contact_directly false
  f.contact_name "MyString"
  f.contact_phone "MyString"
  f.contact_email "MyString"
  f.contact_note "MyText"
  f.lister_interest "MyString"
end