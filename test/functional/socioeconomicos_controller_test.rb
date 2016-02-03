require 'test_helper'

class SocioeconomicosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:socioeconomicos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create socioeconomico" do
    assert_difference('Socioeconomico.count') do
      post :create, :socioeconomico => { }
    end

    assert_redirected_to socioeconomico_path(assigns(:socioeconomico))
  end

  test "should show socioeconomico" do
    get :show, :id => socioeconomicos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => socioeconomicos(:one).to_param
    assert_response :success
  end

  test "should update socioeconomico" do
    put :update, :id => socioeconomicos(:one).to_param, :socioeconomico => { }
    assert_redirected_to socioeconomico_path(assigns(:socioeconomico))
  end

  test "should destroy socioeconomico" do
    assert_difference('Socioeconomico.count', -1) do
      delete :destroy, :id => socioeconomicos(:one).to_param
    end

    assert_redirected_to socioeconomicos_path
  end
end
