require 'test_helper'

class AtasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:atas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ata" do
    assert_difference('Ata.count') do
      post :create, :ata => { }
    end

    assert_redirected_to ata_path(assigns(:ata))
  end

  test "should show ata" do
    get :show, :id => atas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => atas(:one).to_param
    assert_response :success
  end

  test "should update ata" do
    put :update, :id => atas(:one).to_param, :ata => { }
    assert_redirected_to ata_path(assigns(:ata))
  end

  test "should destroy ata" do
    assert_difference('Ata.count', -1) do
      delete :destroy, :id => atas(:one).to_param
    end

    assert_redirected_to atas_path
  end
end
