require 'test_helper'

class ObservacaoHistoricosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:observacao_historicos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create observacao_historico" do
    assert_difference('ObservacaoHistorico.count') do
      post :create, :observacao_historico => { }
    end

    assert_redirected_to observacao_historico_path(assigns(:observacao_historico))
  end

  test "should show observacao_historico" do
    get :show, :id => observacao_historicos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => observacao_historicos(:one).to_param
    assert_response :success
  end

  test "should update observacao_historico" do
    put :update, :id => observacao_historicos(:one).to_param, :observacao_historico => { }
    assert_redirected_to observacao_historico_path(assigns(:observacao_historico))
  end

  test "should destroy observacao_historico" do
    assert_difference('ObservacaoHistorico.count', -1) do
      delete :destroy, :id => observacao_historicos(:one).to_param
    end

    assert_redirected_to observacao_historicos_path
  end
end
