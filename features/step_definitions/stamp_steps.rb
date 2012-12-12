module StampStepHelpers
  def month(month_name)
    Date::MONTHNAMES.index(month_name) || Date::ABBR_MONTHNAMES.index(month_name)
  end
end
World(StampStepHelpers)

Given /^the date (\w+) (\d+), (\d{4})$/ do |month_name, day, year|
  @target = Date.new(year.to_i, month(month_name), day.to_i)
end

Given /^the time (\w+) (\d+), (\d+) at (\d{2}):(\d{2}):(\d{2})$/ do |month_name, day, year, hours, minutes, seconds|
  @target = Time.local(year.to_i, month(month_name), day.to_i, hours.to_i, minutes.to_i, seconds.to_i)
end

Given /^the time zone is "(.*?)"$/ do |zone|
  ENV['TZ'] = zone
end

When /^I stamp the example "([^"]*)"$/ do |example|
  @stamped = @target.stamp(example)
end

Then /^I produce "([^"]*)"$/ do |expected|
  assert_equal expected.strip, @stamped.strip
end

When /^I call "([^"]*)" with "([^"]*)"$/ do |method, arg|
  @stamped = @target.send(method, arg)
end
