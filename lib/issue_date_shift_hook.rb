# Hooks to attach to the Redmine Issues.

require 'date'

class IssueDataShiftHook  < Redmine::Hook::ViewListener

  
  # Shifts Dates on future issues
  #
  # Context:
  # * :issue => Issue being saved
  # * :params => HTML parameters
  #
  def controller_issues_edit_before_save(context = { })

    Rails.logger.debug 'inside plugin---------------------------------------'
    Rails.logger.debug context[:params].to_yaml


    old_date = context[:issue].read_attribute(:due_date) 
    new_date = Date.parse ( context[:params][:issue][:due_date] )


    Rails.logger.debug old_date.to_s
    Rails.logger.debug new_date.to_s

    if old_date === new_date then
      Rails.logger.debug 'no date changes'
    else
      # scan future issues and shit the dates
      Rails.logger.debug 'issue changed dates'
      
      date_shift_days = new_date - old_date
      Rails.logger.debug "shifting #{date_shift_days} days"


    end
	

    Rails.logger.debug 'exiting plugin---------------------------------------'

    return ''
  end
  
end
