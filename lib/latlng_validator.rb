class LatlngValidator < ActiveModel::EachValidator  
  def validate_each(object, attribute, value)
    unless Array === value && value.length == 2 && value.all?{ |e| Numeric === e } && 
    value.first >= -90 && value.first <= 90 && value.last >= -180 && value.last <= 180
      object.errors[attribute] << (options[:message] || "is not formatted properly")  
    end  
  end  
end