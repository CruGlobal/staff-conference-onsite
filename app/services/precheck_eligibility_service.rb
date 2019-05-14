# Determines whether a family is eligible to confirm (approve) their precheck or not.
# The requirements correspond closely to a flow chart diagram that was prepared by Cru:
# https://basecamp.com/2160769/projects/12693955/uploads/45614292?enlarge=372609602#attachment_372609602
class PrecheckEligibilityService < ApplicationService
  attr_accessor :family

  def call
    all_requirements_met?
  end

  # @return Array[Symbol] a list of items the family can take action on in order to obtain precheck eligibility
  def actionable_errors
    errors = []

    return errors unless pre_actionable_requirements_met?

    errors << :no_chargeable_staff_number_and_finance_balance_not_zero unless finances_okay?
    errors << :children_forms_not_approved unless children_forms_approved?
    errors
  end

  def too_late?
    return unless last_precheck_time

    Time.zone.now > last_precheck_time
  end

  private

  def_delegator :family, :approved?
  def_delegator :family, :changes_requested?
  def_delegator :family, :pending_approval?

  def_delegator :family, :attendees
  def_delegator :family, :children
  def_delegator :family, :housing_preference

  def_delegator :family, :chargeable_staff_number?

  def all_requirements_met?
    pre_actionable_requirements_met? &&
      actionable_requirements_met?
  end

  def pre_actionable_requirements_met?
    !checked_in_already? &&
      !changes_requested? &&
      within_time_window? &&
      housing_preference_confirmed?
  end

  def actionable_requirements_met?
    finances_okay? &&
      children_forms_approved?
  end

  def checked_in_already?
    approved? || attendees.any?(&:checked_in?)
  end

  def within_time_window?
    return false if earliest_attendee_arrival_date.blank?

    (earliest_precheck_time..last_precheck_time).cover?(Time.zone.now)
  end

  def earliest_precheck_time
    return unless earliest_attendee_arrival_date

    (earliest_attendee_arrival_date - 10.days).beginning_of_day
  end

  def last_precheck_time
    return unless earliest_attendee_arrival_date

    (earliest_attendee_arrival_date - 2.days).end_of_day
  end

  def earliest_attendee_arrival_date
    attendees.collect(&:arrived_at).compact.min
  end

  def children_forms_approved?
    children_requiring_forms_approval.all?(&:forms_approved?)
  end

  def children_requiring_forms_approval
    children.select { |child| child.childcare_weeks.present? }
  end

  def housing_preference_confirmed?
    return false if housing_preference.blank?

    return true if housing_preference.self_provided?

    housing_preference.confirmed_at.present?
  end

  def finances_okay?
    chargeable_staff_number? || finance_balance_is_zero?
  end

  def finance_balance_is_zero?
    finance_report.remaining_balance.zero?
  end

  def finance_report
    @finance_report ||= FamilyFinances::Report.call(family: family)
  end
end
