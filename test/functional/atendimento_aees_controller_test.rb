require 'test_helper'

class AtendimentoAeesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:atendimento_aees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create atendimento_aee" do
    assert_difference('AtendimentoAee.count') do
      post :create, :atendimento_aee => { }
    end

    assert_redirected_to atendimento_aee_path(assigns(:atendimento_aee))
  end

  test "should show atendimento_aee" do
    get :show, :id => atendimento_aees(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => atendimento_aees(:one).to_param
    assert_response :success
  end

  test "should update atendimento_aee" do
    put :update, :id => atendimento_aees(:one).to_param, :atendimento_aee => { }
    assert_redirected_to atendimento_aee_path(assigns(:atendimento_aee))
  end

  test "should destroy atendimento_aee" do
    assert_difference('AtendimentoAee.count', -1) do
      delete :destroy, :id => atendimento_aees(:one).to_param
    end

    assert_redirected_to atendimento_aees_path
  end
end
