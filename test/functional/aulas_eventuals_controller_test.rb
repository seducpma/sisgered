require 'test_helper'

class AulasEventualsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aulas_eventuals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aulas_eventual" do
    assert_difference('AulasEventual.count') do
      post :create, :aulas_eventual => { }
    end

    assert_redirected_to aulas_eventual_path(assigns(:aulas_eventual))
  end

  test "should show aulas_eventual" do
    get :show, :id => aulas_eventuals(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => aulas_eventuals(:one).to_param
    assert_response :success
  end

  test "should update aulas_eventual" do
    put :update, :id => aulas_eventuals(:one).to_param, :aulas_eventual => { }
    assert_redirected_to aulas_eventual_path(assigns(:aulas_eventual))
  end

  test "should destroy aulas_eventual" do
    assert_difference('AulasEventual.count', -1) do
      delete :destroy, :id => aulas_eventuals(:one).to_param
    end

    assert_redirected_to aulas_eventuals_path
  end
end
