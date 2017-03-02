class CostCode::FormCell < ::FormCell
  def show
    show_errors_if_any

    columns do
      column { basic_inputs }
      column { charges_panel }
    end

    actions
  end

  private

  def basic_inputs
    inputs do
      input :name
      input :description, as: :ckeditor
      input :min_days
    end
  end

  def charges_panel
    panel 'Charges' do
      has_many :charges, heading: nil do |f|
        f.input :max_days

        money_input_widget(f, :adult)
        money_input_widget(f, :teen)
        money_input_widget(f, :child)
        money_input_widget(f, :infant)
        money_input_widget(f, :child_meal)
        money_input_widget(f, :single_delta)

        f.input :_destroy, as: :boolean, wrapper_html: { class: 'destroy' }
      end
    end
  end
end
