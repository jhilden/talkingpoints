require 'test_helper'

class LocationTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:location_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create location_type" do
    assert_difference('LocationType.count') do
      post :create, :location_type => { }
    end

    assert_redirected_to location_type_path(assigns(:location_type))
  end

  test "should show location_type" do
    get :show, :id => location_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => location_types(:one).to_param
    assert_response :success
  end

  test "should update location_type" do
    put :update, :id => location_types(:one).to_param, :location_type => { }
    assert_redirected_to location_type_path(assigns(:location_type))
  end

  test "should destroy location_type" do
    assert_difference('LocationType.count', -1) do
      delete :destroy, :id => location_types(:one).to_param
    end

    assert_redirected_to location_types_path
  end
end
