require 'test_helper'

class ConteudoprogramaticosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conteudoprogramaticos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conteudoprogramatico" do
    assert_difference('Conteudoprogramatico.count') do
      post :create, :conteudoprogramatico => { }
    end

    assert_redirected_to conteudoprogramatico_path(assigns(:conteudoprogramatico))
  end

  test "should show conteudoprogramatico" do
    get :show, :id => conteudoprogramaticos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => conteudoprogramaticos(:one).to_param
    assert_response :success
  end

  test "should update conteudoprogramatico" do
    put :update, :id => conteudoprogramaticos(:one).to_param, :conteudoprogramatico => { }
    assert_redirected_to conteudoprogramatico_path(assigns(:conteudoprogramatico))
  end

  test "should destroy conteudoprogramatico" do
    assert_difference('Conteudoprogramatico.count', -1) do
      delete :destroy, :id => conteudoprogramaticos(:one).to_param
    end

    assert_redirected_to conteudoprogramaticos_path
  end
end
