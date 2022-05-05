require 'test_helper'

class FuncionariosFamiliaresControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:funcionarios_familiares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create funcionarios_familiare" do
    assert_difference('FuncionariosFamiliare.count') do
      post :create, :funcionarios_familiare => { }
    end

    assert_redirected_to funcionarios_familiare_path(assigns(:funcionarios_familiare))
  end

  test "should show funcionarios_familiare" do
    get :show, :id => funcionarios_familiares(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => funcionarios_familiares(:one).to_param
    assert_response :success
  end

  test "should update funcionarios_familiare" do
    put :update, :id => funcionarios_familiares(:one).to_param, :funcionarios_familiare => { }
    assert_redirected_to funcionarios_familiare_path(assigns(:funcionarios_familiare))
  end

  test "should destroy funcionarios_familiare" do
    assert_difference('FuncionariosFamiliare.count', -1) do
      delete :destroy, :id => funcionarios_familiares(:one).to_param
    end

    assert_redirected_to funcionarios_familiares_path
  end
end
