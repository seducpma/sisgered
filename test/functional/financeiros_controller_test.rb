require 'test_helper'

class FinanceirosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:financeiros)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create financeiro" do
    assert_difference('Financeiro.count') do
      post :create, :financeiro => { }
    end

    assert_redirected_to financeiro_path(assigns(:financeiro))
  end

  test "should show financeiro" do
    get :show, :id => financeiros(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => financeiros(:one).to_param
    assert_response :success
  end

  test "should update financeiro" do
    put :update, :id => financeiros(:one).to_param, :financeiro => { }
    assert_redirected_to financeiro_path(assigns(:financeiro))
  end

  test "should destroy financeiro" do
    assert_difference('Financeiro.count', -1) do
      delete :destroy, :id => financeiros(:one).to_param
    end

    assert_redirected_to financeiros_path
  end
end
