Crummy.configure do |config|
  config.format = :html_list
  config.html_list_separator= '<span class="divider">/</span>'.html_safe
  config.ul_class = 'breadcrumb'
  config.last_class = 'active'
end
