require 'test_helper'

class MasterPlanItemsControllerTest < ActionController::TestCase
  setup do
    @master_plan_item = master_plan_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:master_plan_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create master_plan_item" do
    assert_difference('MasterPlanItem.count') do
      post :create, master_plan_item: {  }
    end

    assert_redirected_to master_plan_item_path(assigns(:master_plan_item))
  end

  test "should show master_plan_item" do
    get :show, id: @master_plan_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @master_plan_item
    assert_response :success
  end

  test "should update master_plan_item" do
    put :update, id: @master_plan_item, master_plan_item: {  }
    assert_redirected_to master_plan_item_path(assigns(:master_plan_item))
  end

  test "should destroy master_plan_item" do
    assert_difference('MasterPlanItem.count', -1) do
      delete :destroy, id: @master_plan_item
    end

    assert_redirected_to master_plan_items_path
  end
end
