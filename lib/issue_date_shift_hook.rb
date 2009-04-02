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

    present_issue = Issue.find( context[:issue].id)
    old_date =  present_issue.due_date

    new_date = Date.parse ( context[:params][:issue][:due_date] )

    if old_date === new_date then
      Rails.logger.debug 'no date changes'
    else
      # scan future issues and shit the dates
      Rails.logger.debug 'issue changed dates'
      
      date_shift_days = new_date - old_date
      Rails.logger.debug "shifting #{date_shift_days} days from date  #{old_date.to_s} "

      begin
        issues = Issue.find( 
          :all, 
          :conditions => "project_id = #{context[:issue].project_id} AND start_date > '#{old_date.to_s}'",
          :order => "start_date ASC"
        );

        issues.each do | issue2 |
          Rails.logger.debug "updating #{issue2.id}"
          issue2.start_date = issue2.start_date + date_shift_days
          issue2_shift = 0
          if issue2.start_date.wday == 0 then
            issue2.start_date = issue2.start_date + 1
            issue2_shift = 1
          elsif issue2.start_date.wday == 6 then
            issue2.start_date = issue2.start_date + 2
            issue2_shift = 2
          end 
          issue2.due_date = issue2.due_date + date_shift_days + issue2_shift
          if issue2.due_date.wday == 0 then
            issue2.due_date = issue2.due_date + 1
            issue2_shift = 1
          elsif issue2.due_date.wday == 6 then
            issue2.due_date = issue2.due_date + 2
            issue2_shift = 2
          end
          issue2.save
          date_shift_days = date_shift_days 
        end

      rescue ActiveRecord::RecordNotFound
        # cool, nothing to do
      end


    end
	

    Rails.logger.debug 'exiting plugin---------------------------------------'

    return ''
  end
  
end
