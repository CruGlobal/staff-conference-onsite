require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  setup do
    create_users
    @family = create :family
  end

  test 'permit create' do
    assert_permit @general_user, @family, :create
    assert_permit @finance_user, @family, :create
    assert_permit @admin_user, @family, :create
  end

  test 'permit read' do
    assert_permit @general_user, @family, :show
    assert_permit @finance_user, @family, :show
    assert_permit @admin_user, @family, :show
  end

  test 'permit update' do
    assert_permit @general_user, @family, :update
    assert_permit @finance_user, @family, :update
    assert_permit @admin_user, @family, :update
  end

  test 'permit destroy' do
    assert_permit @general_user, @family, :destroy
    assert_permit @finance_user, @family, :destroy
    assert_permit @admin_user, @family, :destroy
  end
end
