require 'test_helper'

class FuncionariosMoradoresControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:funcionarios_moradores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create funcionarios_moradore" do
    assert_difference('FuncionariosMoradore.count') do
      post :create, :funcionarios_moradore => { }
    end

    assert_redirected_to funcionarios_moradore_path(assigns(:funcionarios_moradore))
  end

  test "should show funcionarios_moradore" do
    get :show, :id => funcionarios_moradores(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => funcionarios_moradores(:one).to_param
    assert_response :success
  end

  test "should update funcionarios_moradore" do
    put :update, :id => funcionarios_moradores(:one).to_param, :funcionarios_moradore => { }
    assert_redirected_to funcionarios_moradore_path(assigns(:funcionarios_moradore))
  end

  test "should destroy funcionarios_moradore" do
    assert_difference('FuncionariosMoradore.count', -1) do
      delete :destroy, :id => funcionarios_moradores(:one).to_param
    end

    assert_redirected_to funcionarios_moradores_path
  end
end
