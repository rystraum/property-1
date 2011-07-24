Given /^the following listings:$/ do |listings|
  Listing.create!(listings.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) listing$/ do |pos|
  visit listings_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following listings:$/ do |expected_listings_table|
  expected_listings_table.diff!(tableish('table tr', 'td,th'))
end
