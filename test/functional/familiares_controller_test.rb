require 'test_helper'

class FamiliaresControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:familiares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create familiare" do
    assert_difference('Familiare.count') do
      post :create, :familiare => { }
    end

    assert_redirected_to familiare_path(assigns(:familiare))
  end

  test "should show familiare" do
    get :show, :id => familiares(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => familiares(:one).to_param
    assert_response :success
  end

  test "should update familiare" do
    put :update, :id => familiares(:one).to_param, :familiare => { }
    assert_redirected_to familiare_path(assigns(:familiare))
  end

  test "should destroy familiare" do
    assert_difference('Familiare.count', -1) do
      delete :destroy, :id => familiares(:one).to_param
    end

    assert_redirected_to familiares_path
  end
end
