class Conference < ApplicationRecord
  has_paper_trail

  include Monetizable

  monetize_attr :price_cents, numericality: {
    greater_than_or_equal_to: -1_000_000,
    less_than_or_equal_to:     1_000_000
  }

  has_many :conference_attendances, dependent: :destroy
  has_many :attendees, through: :conference_attendances

  validates :name, :staff_conference, presence: true

  after_save :only_one_staff_conference!

  class << self
    def staff_conference
      find_by!(staff_conference: true)
    end
  end

  def to_s
    name
  end

  def audit_name
    "#{super}: #{self}"
  end

  private

  def only_one_staff_conference!
    return unless staff_conference?

    self.class.
      where.not(id: id).where(staff_conference: true).
      find_each { |c| c.update!(staff_conference: false) }
  end
end
