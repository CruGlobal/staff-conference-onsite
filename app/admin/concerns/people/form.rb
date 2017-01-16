module People
  # Defines the form for creating and editong {Person} records.
  module Form
    include FormMealExemptions

    FORM_OPTIONS ||= {
      # If creating a new family-member, show the family name in the title
      title: proc do |attendee|
        label = "#{action_name.titlecase} #{attendee.class.name}"

        if (family = attendee.family || param_family)
          "#{label} (#{family_label(family)})"
        else
          label
        end
      end
    }.freeze

    # If creating a new family-member, do not let the family association be
    # editable.
    FAMILY_SELECTOR ||= proc do |form|
      if (id = form.object.family_id || param_family.try(:id))
        form.input :family_id, as: :hidden, input_html: { value: id }
      else
        form.input :family
      end
    end

    STAY_SUBFORM ||= proc do |form|
      collection = [:stays, form.object.stays.order(:arrived_at)]

      panel 'Housing Assignments', 'data-housing_unit-container' => true do
        form.has_many :stays, heading: nil, for: collection do |f|
          select_housing_unit_widget(f)

          datepicker_input(f, :arrived_at)
          datepicker_input(f, :departed_at)

          dynamic_stay_input(f, :percentage)
          dynamic_stay_input(f, :single_occupancy)
          dynamic_stay_input(f, :no_charge)
          dynamic_stay_input(f, :waive_minimum)

          f.input :comment, as: :ckeditor
          f.input :_destroy, as: :boolean, wrapper_html: { class: 'destroy' }
        end
      end
    end
    COST_ADJUSTMENT_SUBFORM ||= proc do |form|
      panel 'Cost Adjustments', 'data-housing_unit-container' => true do
        form.has_many :cost_adjustments, heading: nil do |f|
          f.input :cost_type, as: :select, collection: cost_type_select
          money_input_widget(f, :price)
          f.input :description, as: :ckeditor
        end
      end
    end
  end
end
