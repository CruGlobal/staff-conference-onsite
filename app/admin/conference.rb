ActiveAdmin.register Conference do
  permit_params :name, :description, :start_at, :end_at, :price

  index do
    selectable_column
    column :id
    column(:name) { |c| h4 c.name }
    column(:price) { |c| humanized_money_with_symbol(c.price) }
    column(:description) { |m| html_summary(m.description) }
    column :stat_at
    column :end_at
    column 'Attendees' do |c|
      link_to c.attendees.count, ''
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :description
  filter :start_at
  filter :end_at
  filter :created_at
  filter :updated_at

  show do
    columns do
      column do
        attributes_table do
          row :id
          row :name
          row(:price) { |c| humanized_money_with_symbol(c.price) }
          # rubocop:disable Rails/OutputSafety
          row(:description) { |m| m.description.try(:html_safe) }
          row :stat_at
          row :end_at
          row :created_at
          row :updated_at
        end
      end

      column do
        size = conference.attendees.size
        panel "Attendees (#{size})" do
          if size > 0
            ul do
              conference.attendees.each do |a|
                li { link_to(a.full_name, a) }
              end
            end
          else
            strong 'None'
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :price, as: :string
      f.input :description, as: :ckeditor
      f.input :start_at, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
      f.input :end_at, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
    end
    f.actions
  end
end