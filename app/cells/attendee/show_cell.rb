class Attendee::ShowCell < ::ShowCell
  property :attendee

  def show
    columns do
      column { left_column }
      column { right_column }
    end

    active_admin_comments
  end

  private

  def person_cell
    @person_cell ||= cell('person/show', model, person: attendee)
  end

  def left_column
    attendee_attributes_table
    conferences_panel
    person_cell.call(:cost_adjustments)
  end

  def right_column
    attendances_panel
    person_cell.call(:stays)
    person_cell.call(:meal_exemptions)
  end

  def attendee_attributes_table
    attributes_table do
      row :id
      row(:student_number) { |a| code a.student_number }
      personal_rows
      contact_rows
      ministry_row
      row :department
      row :arrived_at
      row :departed_at
      row :created_at
      row :updated_at
    end
  end

  def personal_rows
    row :first_name
    row :last_name
    row(:family) { |a| link_to family_label(a.family), family_path(a.family) }
    row :birthdate
    row(:age, sortable: :birthdate) { |a| age_label(a) }
    row(:gender) { |a| gender_name(a.gender) }
  end

  def contact_rows
    row(:email) { |a| mail_to(a.email) }
    row(:phone) { |a| format_phone(a.phone) }
    row :emergency_contact
  end

  def ministry_row
    row(:ministry) do |a|
      if a.ministry_id.present?
        link_to a.ministry.to_s, ministry_path(a.ministry_id)
      end
    end
  end

  def conferences_panel
    panel "Conferences (#{attendee.conferences.size})", class: 'conferences' do
      attendee.conferences.any? ? conference_list : strong('None')
    end
  end

  def conference_list
    ul do
      attendee.conferences.each { |c| li { link_to(c.name, c) } }
    end
  end

  def attendances_panel
    panel 'Courses', class: 'attendances' do
      attendances = attendee.course_attendances.includes(:course)
      attendances.any? ? attendances_list(attendances) : strong('None')
    end
  end

  def attendances_list(attendances)
    table_for attendances.sort_by { |a| a.course.name } do
      column :course
      column :grade
      column :seminary_credit
    end
  end
end