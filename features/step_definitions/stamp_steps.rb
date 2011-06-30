Given /^the date (\w+) (\d+), (\d{4})$/ do |month_name, day, year|
  month = Date::MONTHNAMES.index(month_name) || Date::ABBR_MONTHNAMES.index(month_name)
  assert (1..12).include?(month), "Invalid month: #{month_name}"
  @date = Date.new(year.to_i, month, day.to_i)
end

When /^I stamp the example "([^"]*)"$/ do |example|
  @formatted_date = @date.stamp(example)
end

Then /^I produce "([^"]*)"$/ do |expected|
  assert_equal expected, @formatted_date
end
