require 'test_helper'

class ProfessorsClassesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:professors_classes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create professors_class" do
    assert_difference('ProfessorsClass.count') do
      post :create, :professors_class => { }
    end

    assert_redirected_to professors_class_path(assigns(:professors_class))
  end

  test "should show professors_class" do
    get :show, :id => professors_classes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => professors_classes(:one).to_param
    assert_response :success
  end

  test "should update professors_class" do
    put :update, :id => professors_classes(:one).to_param, :professors_class => { }
    assert_redirected_to professors_class_path(assigns(:professors_class))
  end

  test "should destroy professors_class" do
    assert_difference('ProfessorsClass.count', -1) do
      delete :destroy, :id => professors_classes(:one).to_param
    end

    assert_redirected_to professors_classes_path
  end
end
