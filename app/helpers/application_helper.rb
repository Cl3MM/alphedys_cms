module ApplicationHelper
  def print_upto str, number=-1
    return str.to_s if number < 1
    if str.size < number
      "#{str.to_s}"
    else
      "#{str.to_s[0..number-3]}..."
    end
  end
end
