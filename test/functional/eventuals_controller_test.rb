require 'test_helper'

class EventualsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:eventuals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create eventual" do
    assert_difference('Eventual.count') do
      post :create, :eventual => { }
    end

    assert_redirected_to eventual_path(assigns(:eventual))
  end

  test "should show eventual" do
    get :show, :id => eventuals(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => eventuals(:one).to_param
    assert_response :success
  end

  test "should update eventual" do
    put :update, :id => eventuals(:one).to_param, :eventual => { }
    assert_redirected_to eventual_path(assigns(:eventual))
  end

  test "should destroy eventual" do
    assert_difference('Eventual.count', -1) do
      delete :destroy, :id => eventuals(:one).to_param
    end

    assert_redirected_to eventuals_path
  end
end
