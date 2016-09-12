require 'test_helper'

class HousingFacilityTest < ActiveSupport::TestCase
  setup do
    create_users
    @housing_facility = create :housing_facility
  end

  test 'permit create' do
    assert_permit @general_user, @housing_facility, :create
    assert_permit @finance_user, @housing_facility, :create
    assert_permit @admin_user, @housing_facility, :create
  end

  test 'permit read' do
    assert_permit @general_user, @housing_facility, :show
    assert_permit @finance_user, @housing_facility, :show
    assert_permit @admin_user, @housing_facility, :show
  end

  test 'permit update' do
    assert_permit @general_user, @housing_facility, :update
    assert_permit @finance_user, @housing_facility, :update
    assert_permit @admin_user, @housing_facility, :update
  end

  test 'permit destroy' do
    assert_permit @general_user, @housing_facility, :destroy
    assert_permit @finance_user, @housing_facility, :destroy
    assert_permit @admin_user, @housing_facility, :destroy
  end
end
