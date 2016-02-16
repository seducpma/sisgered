require 'test_helper'

class ClassesAlunosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:classes_alunos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create classes_aluno" do
    assert_difference('ClassesAluno.count') do
      post :create, :classes_aluno => { }
    end

    assert_redirected_to classes_aluno_path(assigns(:classes_aluno))
  end

  test "should show classes_aluno" do
    get :show, :id => classes_alunos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => classes_alunos(:one).to_param
    assert_response :success
  end

  test "should update classes_aluno" do
    put :update, :id => classes_alunos(:one).to_param, :classes_aluno => { }
    assert_redirected_to classes_aluno_path(assigns(:classes_aluno))
  end

  test "should destroy classes_aluno" do
    assert_difference('ClassesAluno.count', -1) do
      delete :destroy, :id => classes_alunos(:one).to_param
    end

    assert_redirected_to classes_alunos_path
  end
end
