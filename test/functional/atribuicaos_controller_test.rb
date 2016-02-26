require 'test_helper'

class AtribuicaosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:atribuicaos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create atribuicao" do
    assert_difference('Atribuicao.count') do
      post :create, :atribuicao => { }
    end

    assert_redirected_to atribuicao_path(assigns(:atribuicao))
  end

  test "should show atribuicao" do
    get :show, :id => atribuicaos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => atribuicaos(:one).to_param
    assert_response :success
  end

  test "should update atribuicao" do
    put :update, :id => atribuicaos(:one).to_param, :atribuicao => { }
    assert_redirected_to atribuicao_path(assigns(:atribuicao))
  end

  test "should destroy atribuicao" do
    assert_difference('Atribuicao.count', -1) do
      delete :destroy, :id => atribuicaos(:one).to_param
    end

    assert_redirected_to atribuicaos_path
  end
end
