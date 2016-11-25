module MinistryHelper
  module_function

  # Wraps Formtastic's `form.input :ministry, as: :select` helper, so that our
  # custom jQuery widget can replace the select with a nicer UI widget.
  #
  # @param [Formtastic Form] form The form DSL object
  # @param [Symbol] attribute_name The name of the association attribute
  # @see app/assets/javascripts/ministry/select.coffee
  def select_ministry_widget(form, attribute_name = :ministry)
    ministries = Ministry.all

    form.input(
      attribute_name,
      as: :select,
      collection: ministries.map { |m| [m.to_s, m.id] },
      input_html: {
        'data-ministry-code' => true,
        'data-labels' => Hash[ministries.map { |m| [m.id, m.to_s] }].to_json,
        'data-hierarchy' => ministry_hierarchy(ministries).to_json
      }
    )
  end

  # @param [ActiveRecord::Relation] relation The ministries to build the
  #   hieararchy from.
  # @param [Hash<Ministry, Hash>] hierarchy The hierarchy to render. If +nil+,
  #   will default to {Ministry#hierarchy}
  # @return [Hash<Fixnum, Hash] A map of IDs to sub-trees. Each key is the DB
  #   ID of a ministry, and each value is a sub-tree, representing the hierarchy
  #   of ministries "beneath" this one in the organizational structure. That
  #   sub-tree may be empty
  def ministry_hierarchy(ministries, hierarchy = nil)
    hierarchy ||= Ministry.hierarchy(ministries)

    {}.tap do |h|
      hierarchy.each do |ministry, subtree|
        h[ministry.id] = ministry_hierarchy(ministries, subtree)
      end
    end
  end
end
