require 'test_helper'

class SaudesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:saudes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create saude" do
    assert_difference('Saude.count') do
      post :create, :saude => { }
    end

    assert_redirected_to saude_path(assigns(:saude))
  end

  test "should show saude" do
    get :show, :id => saudes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => saudes(:one).to_param
    assert_response :success
  end

  test "should update saude" do
    put :update, :id => saudes(:one).to_param, :saude => { }
    assert_redirected_to saude_path(assigns(:saude))
  end

  test "should destroy saude" do
    assert_difference('Saude.count', -1) do
      delete :destroy, :id => saudes(:one).to_param
    end

    assert_redirected_to saudes_path
  end
end
