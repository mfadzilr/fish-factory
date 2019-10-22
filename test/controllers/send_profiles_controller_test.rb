require 'test_helper'

class SendProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get send_profiles_new_url
    assert_response :success
  end

  test "should get create" do
    get send_profiles_create_url
    assert_response :success
  end

  test "should get update" do
    get send_profiles_update_url
    assert_response :success
  end

  test "should get edit" do
    get send_profiles_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get send_profiles_destroy_url
    assert_response :success
  end

  test "should get index" do
    get send_profiles_index_url
    assert_response :success
  end

  test "should get show" do
    get send_profiles_show_url
    assert_response :success
  end

end
