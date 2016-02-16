require 'test_helper'

class NotasAlunosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notas_alunos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notas_aluno" do
    assert_difference('NotasAluno.count') do
      post :create, :notas_aluno => { }
    end

    assert_redirected_to notas_aluno_path(assigns(:notas_aluno))
  end

  test "should show notas_aluno" do
    get :show, :id => notas_alunos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => notas_alunos(:one).to_param
    assert_response :success
  end

  test "should update notas_aluno" do
    put :update, :id => notas_alunos(:one).to_param, :notas_aluno => { }
    assert_redirected_to notas_aluno_path(assigns(:notas_aluno))
  end

  test "should destroy notas_aluno" do
    assert_difference('NotasAluno.count', -1) do
      delete :destroy, :id => notas_alunos(:one).to_param
    end

    assert_redirected_to notas_alunos_path
  end
end
