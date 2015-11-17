require 'test_helper'

class ObreirosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:obreiros)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create obreiro" do
    assert_difference('Obreiro.count') do
      post :create, :obreiro => { }
    end

    assert_redirected_to obreiro_path(assigns(:obreiro))
  end

  test "should show obreiro" do
    get :show, :id => obreiros(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => obreiros(:one).to_param
    assert_response :success
  end

  test "should update obreiro" do
    put :update, :id => obreiros(:one).to_param, :obreiro => { }
    assert_redirected_to obreiro_path(assigns(:obreiro))
  end

  test "should destroy obreiro" do
    assert_difference('Obreiro.count', -1) do
      delete :destroy, :id => obreiros(:one).to_param
    end

    assert_redirected_to obreiros_path
  end
end
