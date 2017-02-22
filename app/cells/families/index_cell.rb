module Families
  class IndexCell < ::IndexCell
    def show
      selectable_column

      column :id
      column(:last_name) { |f| family_label(f) }
      column(:staff_number) { |f| code f.staff_number }
      address_columns
      column(:registration_comment) { |f| html_summary(f.registration_comment) }
      column :created_at
      column :updated_at

      actions
    end

    private

    def address_columns
      column :street
      column :city
      column :state
      column(:country_code) { |f| country_name(f.country_code) }
      column :zip
    end
  end
end