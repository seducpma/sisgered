require 'test_helper'

class UfaltasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ufaltas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ufalta" do
    assert_difference('Ufalta.count') do
      post :create, :ufalta => { }
    end

    assert_redirected_to ufalta_path(assigns(:ufalta))
  end

  test "should show ufalta" do
    get :show, :id => ufaltas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ufaltas(:one).to_param
    assert_response :success
  end

  test "should update ufalta" do
    put :update, :id => ufaltas(:one).to_param, :ufalta => { }
    assert_redirected_to ufalta_path(assigns(:ufalta))
  end

  test "should destroy ufalta" do
    assert_difference('Ufalta.count', -1) do
      delete :destroy, :id => ufaltas(:one).to_param
    end

    assert_redirected_to ufaltas_path
  end
end
