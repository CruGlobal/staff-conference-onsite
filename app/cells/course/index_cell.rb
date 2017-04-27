class Course::IndexCell < ::IndexCell
  def show
    actions
    selectable_column

    column_name
    column :instructor
    column_price
    column_description
    column :week_descriptor
    column :ibs_code
    column :location
    column_attendees
    column :created_at
    column :updated_at
  end

  private

  def column_name
    column(:name) { |c| h4 c.name }
  end

  def column_price
    column(:price) { |c| humanized_money_with_symbol(c.price) }
  end

  def column_description
    column(:description) { |c| html_summary(c.description) }
  end

  def column_attendees
    column('Attendees') { |c| link_to c.attendees.count, '' }
  end
end
