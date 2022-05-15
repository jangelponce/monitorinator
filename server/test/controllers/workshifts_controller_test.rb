require "test_helper"

class WorkshiftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @workshift = workshifts(:one)
  end

  test "should get index" do
    get workshifts_url, as: :json
    assert_response :success
  end

  test "should create workshift" do
    assert_difference("Workshift.count") do
      post workshifts_url, params: { workshift: { service_id: @workshift.service_id, timestamp: @workshift.timestamp, user_id: @workshift.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show workshift" do
    get workshift_url(@workshift), as: :json
    assert_response :success
  end

  test "should update workshift" do
    patch workshift_url(@workshift), params: { workshift: { service_id: @workshift.service_id, timestamp: @workshift.timestamp, user_id: @workshift.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy workshift" do
    assert_difference("Workshift.count", -1) do
      delete workshift_url(@workshift), as: :json
    end

    assert_response :no_content
  end
end
