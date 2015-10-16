require 'test_helper'

class TitulacaosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:titulacaos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create titulacao" do
    assert_difference('Titulacao.count') do
      post :create, :titulacao => { }
    end

    assert_redirected_to titulacao_path(assigns(:titulacao))
  end

  test "should show titulacao" do
    get :show, :id => titulacaos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => titulacaos(:one).to_param
    assert_response :success
  end

  test "should update titulacao" do
    put :update, :id => titulacaos(:one).to_param, :titulacao => { }
    assert_redirected_to titulacao_path(assigns(:titulacao))
  end

  test "should destroy titulacao" do
    assert_difference('Titulacao.count', -1) do
      delete :destroy, :id => titulacaos(:one).to_param
    end

    assert_redirected_to titulacaos_path
  end
end
