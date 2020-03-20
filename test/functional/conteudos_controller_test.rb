require 'test_helper'

class ConteudosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conteudos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conteudo" do
    assert_difference('Conteudo.count') do
      post :create, :conteudo => { }
    end

    assert_redirected_to conteudo_path(assigns(:conteudo))
  end

  test "should show conteudo" do
    get :show, :id => conteudos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => conteudos(:one).to_param
    assert_response :success
  end

  test "should update conteudo" do
    put :update, :id => conteudos(:one).to_param, :conteudo => { }
    assert_redirected_to conteudo_path(assigns(:conteudo))
  end

  test "should destroy conteudo" do
    assert_difference('Conteudo.count', -1) do
      delete :destroy, :id => conteudos(:one).to_param
    end

    assert_redirected_to conteudos_path
  end
end
