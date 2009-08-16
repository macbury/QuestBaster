# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def wow_currency(amount)
    html = ""
    
    gold = amount.div(10_000)

    amount -= gold * 10_000
    html += image_tag('money_gold.gif') + " #{gold} "
    
    silver = amount.div(100)
    amount -= silver * 100
    html += image_tag('money_silver.gif') + " #{silver} "
    
    copper = amount
    html += image_tag('money_copper.gif') + " #{copper} "
    
    return html
  end
  
end
