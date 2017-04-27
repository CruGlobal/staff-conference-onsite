class PaperTrailVersion::IndexCell < ::IndexCell
  def show
    actions
    selectable_column

    column('Record', sortable: [:item_type, :id]) { |v| version_label(v) }
    column :event
    column('When', sortable: :created_at) { |v| v.created_at.to_s :long }
    column('Editor', sortable: :whodunnit) { |v| editor_link(v) }
  end
end
