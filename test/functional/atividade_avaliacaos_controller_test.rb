require 'test_helper'

class AtividadeAvaliacaosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:atividade_avaliacaos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create atividade_avaliacao" do
    assert_difference('AtividadeAvaliacao.count') do
      post :create, :atividade_avaliacao => { }
    end

    assert_redirected_to atividade_avaliacao_path(assigns(:atividade_avaliacao))
  end

  test "should show atividade_avaliacao" do
    get :show, :id => atividade_avaliacaos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => atividade_avaliacaos(:one).to_param
    assert_response :success
  end

  test "should update atividade_avaliacao" do
    put :update, :id => atividade_avaliacaos(:one).to_param, :atividade_avaliacao => { }
    assert_redirected_to atividade_avaliacao_path(assigns(:atividade_avaliacao))
  end

  test "should destroy atividade_avaliacao" do
    assert_difference('AtividadeAvaliacao.count', -1) do
      delete :destroy, :id => atividade_avaliacaos(:one).to_param
    end

    assert_redirected_to atividade_avaliacaos_path
  end
end
