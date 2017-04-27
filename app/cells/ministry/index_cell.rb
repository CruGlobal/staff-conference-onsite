class Ministry::IndexCell < ::IndexCell
  def show
    actions
    selectable_column

    column :code
    column :name
    column(:parent) { |m| m.parent.to_s }
    members_column
    column :created_at
    column :updated_at
  end

  private

  def members_column
    column 'Members' do |m|
      link_to(m.people.count, attendees_path(q: { ministry_id_eq: m.id }))
    end
  end
end
