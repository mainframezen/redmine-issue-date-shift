# Hooks to attach to the Redmine Issues.
class IssueDataShiftHook  < Redmine::Hook::ViewListener

  
  # Shifts Dates on future issues
  #
  # Context:
  # * :issue => Issue being saved
  # * :params => HTML parameters
  #
  def controller_issues_edit_before_save(context = { })
    case true

    when context[:params][:deliverable_id].blank?
      # Do nothing
    when context[:params][:deliverable_id] == 'none'
      # Unassign deliverable
      context[:issue].deliverable = nil
    else
      context[:issue].deliverable = Deliverable.find(context[:params][:deliverable_id])
    end

    return ''
  end
  
end
