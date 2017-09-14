require 'test_helper'

class AulasFaltasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aulas_faltas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aulas_falta" do
    assert_difference('AulasFalta.count') do
      post :create, :aulas_falta => { }
    end

    assert_redirected_to aulas_falta_path(assigns(:aulas_falta))
  end

  test "should show aulas_falta" do
    get :show, :id => aulas_faltas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => aulas_faltas(:one).to_param
    assert_response :success
  end

  test "should update aulas_falta" do
    put :update, :id => aulas_faltas(:one).to_param, :aulas_falta => { }
    assert_redirected_to aulas_falta_path(assigns(:aulas_falta))
  end

  test "should destroy aulas_falta" do
    assert_difference('AulasFalta.count', -1) do
      delete :destroy, :id => aulas_faltas(:one).to_param
    end

    assert_redirected_to aulas_faltas_path
  end
end
