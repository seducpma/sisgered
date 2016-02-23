require 'test_helper'

class ClassesProfessorsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:classes_professors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create classes_professor" do
    assert_difference('ClassesProfessor.count') do
      post :create, :classes_professor => { }
    end

    assert_redirected_to classes_professor_path(assigns(:classes_professor))
  end

  test "should show classes_professor" do
    get :show, :id => classes_professors(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => classes_professors(:one).to_param
    assert_response :success
  end

  test "should update classes_professor" do
    put :update, :id => classes_professors(:one).to_param, :classes_professor => { }
    assert_redirected_to classes_professor_path(assigns(:classes_professor))
  end

  test "should destroy classes_professor" do
    assert_difference('ClassesProfessor.count', -1) do
      delete :destroy, :id => classes_professors(:one).to_param
    end

    assert_redirected_to classes_professors_path
  end
end
