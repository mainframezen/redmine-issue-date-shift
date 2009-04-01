require 'redmine'

# this is the redmine hook 
# call_hook(:controller_issues_edit_before_save, { :params => params, :issue => @issue, :time_entry => @time_entry, :journal => journal})

require_dependency 'issue_date_shift_hook'

RAILS_DEFAULT_LOGGER.info 'Starting Issue Date Shift plugin for RedMine'

Redmine::Plugin.register :redmine_issue_date_shift do
  name 'Redmine Issue Date Shift plugin'
  author 'JP Ribeiro'
  description 'Shift issue dates is a plugin for Redmine'
  version '0.0.1'
end

