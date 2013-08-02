require 'test_helper'

class MasterPlansControllerTest < ActionController::TestCase
  setup do
    @master_plan = master_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:master_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create master_plan" do
    assert_difference('MasterPlan.count') do
      post :create, master_plan: {  }
    end

    assert_redirected_to master_plan_path(assigns(:master_plan))
  end

  test "should show master_plan" do
    get :show, id: @master_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @master_plan
    assert_response :success
  end

  test "should update master_plan" do
    put :update, id: @master_plan, master_plan: {  }
    assert_redirected_to master_plan_path(assigns(:master_plan))
  end

  test "should destroy master_plan" do
    assert_difference('MasterPlan.count', -1) do
      delete :destroy, id: @master_plan
    end

    assert_redirected_to master_plans_path
  end
end
