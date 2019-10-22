require 'test_helper'

class RecipientDetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recipient_details_index_url
    assert_response :success
  end

  test "should get show" do
    get recipient_details_show_url
    assert_response :success
  end

end
