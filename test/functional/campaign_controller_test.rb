require 'test_helper'

class CampaignControllerTest < ActionController::TestCase
  test "should get view" do
    get :view
    assert_response :success
  end

  test "should get confirm" do
    get :confirm
    assert_response :success
  end

end
