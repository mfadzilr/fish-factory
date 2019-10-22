require 'test_helper'

class UploadScreenshotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @upload_screenshot = upload_screenshots(:one)
  end

  test "should get index" do
    get upload_screenshots_url
    assert_response :success
  end

  test "should get new" do
    get new_upload_screenshot_url
    assert_response :success
  end

  test "should create upload_screenshot" do
    assert_difference('UploadScreenshot.count') do
      post upload_screenshots_url, params: { upload_screenshot: { origin: @upload_screenshot.origin } }
    end

    assert_redirected_to upload_screenshot_url(UploadScreenshot.last)
  end

  test "should show upload_screenshot" do
    get upload_screenshot_url(@upload_screenshot)
    assert_response :success
  end

  test "should get edit" do
    get edit_upload_screenshot_url(@upload_screenshot)
    assert_response :success
  end

  test "should update upload_screenshot" do
    patch upload_screenshot_url(@upload_screenshot), params: { upload_screenshot: { origin: @upload_screenshot.origin } }
    assert_redirected_to upload_screenshot_url(@upload_screenshot)
  end

  test "should destroy upload_screenshot" do
    assert_difference('UploadScreenshot.count', -1) do
      delete upload_screenshot_url(@upload_screenshot)
    end

    assert_redirected_to upload_screenshots_url
  end
end
