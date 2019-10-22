require 'test_helper'

class AttachmentFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attachment_file = attachment_files(:one)
  end

  test "should get index" do
    get attachment_files_url
    assert_response :success
  end

  test "should get new" do
    get new_attachment_file_url
    assert_response :success
  end

  test "should create attachment_file" do
    assert_difference('AttachmentFile.count') do
      post attachment_files_url, params: { attachment_file: { description: @attachment_file.description, name: @attachment_file.name } }
    end

    assert_redirected_to attachment_file_url(AttachmentFile.last)
  end

  test "should show attachment_file" do
    get attachment_file_url(@attachment_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_attachment_file_url(@attachment_file)
    assert_response :success
  end

  test "should update attachment_file" do
    patch attachment_file_url(@attachment_file), params: { attachment_file: { description: @attachment_file.description, name: @attachment_file.name } }
    assert_redirected_to attachment_file_url(@attachment_file)
  end

  test "should destroy attachment_file" do
    assert_difference('AttachmentFile.count', -1) do
      delete attachment_file_url(@attachment_file)
    end

    assert_redirected_to attachment_files_url
  end
end
