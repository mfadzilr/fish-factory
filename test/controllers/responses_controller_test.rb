require 'test_helper'

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  test "should get open_email" do
    get responses_open_email_url
    assert_response :success
  end

  test "should get click_url" do
    get responses_click_url_url
    assert_response :success
  end

  test "should get create" do
    get responses_create_url
    assert_response :success
  end

end
