Given /^a page exists at (#{PATH}) with a mobile ready template$/ do |path|
  @page = Factory(:public_page, :path=>path, :template_file_name=>"mobile-ready.html.erb")
  content = Factory(:html_block, :content=>"Mobile Content")
  @page.add_content(content)
  @page.publish!
end

Given /^a page exists at (.+) with a desktop only template$/ do |path|
  @page = Factory(:public_page, :path=>path, :template_file_name=>"desktop-only.html.erb")
  content = Factory(:html_block, :content=>"Mobile Content")
  @page.add_content(content)
  @page.publish!
end

When /^a desktop user requests (.+)$/ do |path|
  visit path
end

Given /^a user is browsing the mobile site$/ do
  @site_domain = "http://m.example.com"
end

Given /^a user is browsing the desktop site$/ do
  @site_domain = "http://www.example.com"
end

When /^they request (.+)$/ do |path|
  domain = @site_domain ? @site_domain : ""
  visit "#{domain}#{path}"
end

Then /^they should see the desktop content$/ do
  assert page.has_content? "I am the desktop TEMPLATE"
  assert page.has_content? "Mobile Content"
end

Then /^they should see the mobile template$/ do
  assert page.has_content? "I am a stripped down MOBILE template."
  assert page.has_content? "Mobile Content"
end

When /^they are using an iPhone$/ do
  request_as_iphone
end

Given /^a cms editor is logged in$/ do
  login_as('cmsadmin', 'cmsadmin')
end

Given /^the page \/mobile-page is public$/ do
  p = Cms::Page.find_live_by_path("/mobile-page")
  assert_equal 3, p.parent.sections.size
end

Then /^they should (see|not see) the mobile toggle$/ do |should_see|
  p = Cms::Page.find_by_path(current_path)
  visit ("/cms/toolbar?page_id=#{p.id}&page_version=#{p.version}")
  assert_equal should_see == 'see', page.has_content?('View As Mobile?')
end