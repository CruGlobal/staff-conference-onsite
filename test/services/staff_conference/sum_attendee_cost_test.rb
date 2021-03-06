require 'test_helper'

class StaffConference::SumAttendeeCostTest < ServiceTestCase
  setup do
    @attendee = create :attendee

    @service = StaffConference::SumAttendeeCost.new(attendee: @attendee)
  end

  test 'staff conference' do
    create_staff_conference(price_cents: 123_00)

    @service.call

    assert_equal Money.new(123_00), @service.charges[:tuition_staff]
  end

  test 'non-staff conference' do
    create_conference(price_cents: 123_00)

    @service.call

    assert_equal Money.empty, @service.charges[:tuition_staff]
  end

  test 'staff conference and non-staff conference' do
    create_staff_conference(price_cents: 123_00)
    create_conference(price_cents: 234_00)

    @service.call

    assert_equal Money.new(123_00), @service.charges[:tuition_staff]
  end

  private

  def create_staff_conference(args = {})
    create_conference(args.merge(staff_conference: true))
  end

  def create_conference(args = {})
    create(:conference, args).tap do |conference|
      @attendee.conferences << conference
    end
  end
end
