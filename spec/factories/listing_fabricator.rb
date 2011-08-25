Fabricator :listing do
  user!
  property!
  latitude -23.2
  longitude 88.4
  land_area 10004
  selling_price 239000
end

Fabricator :no_residence_or_land_invalid_listing, from: :listing do
  land_area nil
end

Fabricator :land_listing, from: :listing do
end

Fabricator :residence_listing, from: :listing do
  land_area nil
  residence_construction { Listing::RESIDENCE_CONSTRUCTIONS.keys.sample }
  residence_type { Listing::RESIDENCE_TYPES.keys.sample }
  residence_area 100
end