require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  setup do
    create_users
    @course = create :course
  end

  test 'permit create' do
    refute_permit @general_user, @course, :create

    assert_permit @finance_user, @course, :create
    assert_permit @admin_user, @course, :create
  end

  test 'permit read' do
    assert_permit @general_user, @course, :show
    assert_permit @finance_user, @course, :show
    assert_permit @admin_user, @course, :show
  end

  test 'permit update' do
    refute_permit @general_user, @course, :update

    assert_permit @finance_user, @course, :update
    assert_permit @admin_user, @course, :update
  end

  test 'permit destroy' do
    refute_permit @general_user, @course, :destroy

    assert_permit @finance_user, @course, :destroy
    assert_permit @admin_user, @course, :destroy
  end
end
