class HousingUnit::ShowCell < ::ShowCell
  property :housing_unit

  def show
    columns do
      column { housing_unit_attributes }
      column { stays_panel }
    end
  end

  private

  def housing_unit_attributes
    attributes_table do
      row :id
      row :name
      row :housing_facility
      row(:housing_type) { |u| housing_type_label(u.housing_facility) }
      row :created_at
      row :updated_at
    end
  end

  def stays_panel
    stays = housing_unit.stays.order(:arrived_at)
    panel "Assignments (#{stays.size})", class: 'stays' do
      stays.any? ? stays_list(stays) : strong('None')
    end
  end

  def stays_list(stays)
    ol do
      stays.each do |stay|
        li do
          dates =
            [:arrived_at, :departed_at].map do |attr|
              simple_format_attr(stay, attr)
            end

          text_node(link_to(stay.person.full_name, stay.person))
          text_node(": #{dates.join(' until ')}")
        end
      end
    end
  end
end