require 'test_helper'

class SituacaoAlunosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:situacao_alunos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create situacao_aluno" do
    assert_difference('SituacaoAluno.count') do
      post :create, :situacao_aluno => { }
    end

    assert_redirected_to situacao_aluno_path(assigns(:situacao_aluno))
  end

  test "should show situacao_aluno" do
    get :show, :id => situacao_alunos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => situacao_alunos(:one).to_param
    assert_response :success
  end

  test "should update situacao_aluno" do
    put :update, :id => situacao_alunos(:one).to_param, :situacao_aluno => { }
    assert_redirected_to situacao_aluno_path(assigns(:situacao_aluno))
  end

  test "should destroy situacao_aluno" do
    assert_difference('SituacaoAluno.count', -1) do
      delete :destroy, :id => situacao_alunos(:one).to_param
    end

    assert_redirected_to situacao_alunos_path
  end
end
