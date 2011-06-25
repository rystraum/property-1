module ListingsHelper
  
  def listed_by(listing)
    lister = listing.user
    if agency = lister.agency
      link_to agency.name, agency_path(agency)
    else
      link_to lister.full_name, lister
    end
  end
end
