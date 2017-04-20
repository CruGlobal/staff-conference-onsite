class UserVariable::ShowCell < ::ShowCell
  property :user_variable

  def show
    attributes_table do
      row :code
      row(:value_type) { |var| user_variable_type(var) }
      row(:description) { |var| html_full(var.description) }
      row(:value) { |var| user_variable_format(var) }
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end
end
