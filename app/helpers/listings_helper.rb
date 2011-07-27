module ListingsHelper
  
  def listed_by(listing)
    lister = listing.user
    if lister.is_a? Agent
      link_to lister.agency_name, agency_path(agency)
    else
      link_to lister.full_name, lister
    end
  end
end
