require 'test_helper'

class SitePagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @site_page = site_pages(:one)
  end

  test "should get index" do
    get site_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_site_page_url
    assert_response :success
  end

  test "should create site_page" do
    assert_difference('SitePage.count') do
      post site_pages_url, params: { site_page: {  } }
    end

    assert_redirected_to site_page_url(SitePage.last)
  end

  test "should show site_page" do
    get site_page_url(@site_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_site_page_url(@site_page)
    assert_response :success
  end

  test "should update site_page" do
    patch site_page_url(@site_page), params: { site_page: {  } }
    assert_redirected_to site_page_url(@site_page)
  end

  test "should destroy site_page" do
    assert_difference('SitePage.count', -1) do
      delete site_page_url(@site_page)
    end

    assert_redirected_to site_pages_url
  end
end
