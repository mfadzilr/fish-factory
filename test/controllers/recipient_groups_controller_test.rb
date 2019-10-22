require 'test_helper'

class RecipientGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipient_group = recipient_groups(:one)
  end

  test "should get index" do
    get recipient_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_recipient_group_url
    assert_response :success
  end

  test "should create recipient_group" do
    assert_difference('RecipientGroup.count') do
      post recipient_groups_url, params: { recipient_group: {  } }
    end

    assert_redirected_to recipient_group_url(RecipientGroup.last)
  end

  test "should show recipient_group" do
    get recipient_group_url(@recipient_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_recipient_group_url(@recipient_group)
    assert_response :success
  end

  test "should update recipient_group" do
    patch recipient_group_url(@recipient_group), params: { recipient_group: {  } }
    assert_redirected_to recipient_group_url(@recipient_group)
  end

  test "should destroy recipient_group" do
    assert_difference('RecipientGroup.count', -1) do
      delete recipient_group_url(@recipient_group)
    end

    assert_redirected_to recipient_groups_url
  end
end
