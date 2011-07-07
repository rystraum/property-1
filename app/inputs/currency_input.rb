class CurrencyInput < SimpleForm::Inputs::StringInput
  
  def input
    "PhP #{super}".html_safe
  end
  
end