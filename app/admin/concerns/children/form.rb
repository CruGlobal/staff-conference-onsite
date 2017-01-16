module Children
  # Defines the form for creating and editong {Show} records.
  module Form
    include People::Form

    def self.included(base)
      base.send :form, FORM_OPTIONS do |f|
        f.semantic_errors

        columns do
          column do
            instance_exec(f, &CHILD_INPUTS)
          end

          column do
            instance_exec(f, child, &STAY_SUBFORM)
            instance_exec(f, child, &MEAL_EXEMPTIONS_SUBFORM)
          end
        end

        instance_exec(f, child, &COST_ADJUSTMENT_SUBFORM)

        f.actions
      end
    end

    CHILD_INPUTS ||= proc do |f|
      f.inputs do
        instance_exec(f, &FAMILY_SELECTOR)

        f.input :first_name

        if param_family
          f.input :last_name, input_html: { value: param_family.last_name }
        else
          f.input :last_name
        end

        f.input :gender, as: :select, collection: gender_select
        datepicker_input(f, :birthdate)
        f.input :grade_level, as: :select, collection: grade_level_select,
                              include_blank: true
        f.input :parent_pickup
        f.input :needs_bed

        f.input :childcare_weeks,
                label: 'Weeks of ChildCare',
                collection: childcare_weeks_select,
                multiple: true,
                hint: 'Please add all weeks needed'
      end

      f.inputs 'Assign ChildCare Spaces' do
        f.input :childcare_id,
                as: :select,
                collection: childcare_spaces_select,
                label: 'Childcare Spaces',
                prompt: 'please select'
      end
    end
  end
end
