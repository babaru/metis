require 'test_helper'

class SpotPlanItemsControllerTest < ActionController::TestCase
  setup do
    @spot_plan_item = spot_plan_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spot_plan_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spot_plan_item" do
    assert_difference('SpotPlanItem.count') do
      post :create, spot_plan_item: {  }
    end

    assert_redirected_to spot_plan_item_path(assigns(:spot_plan_item))
  end

  test "should show spot_plan_item" do
    get :show, id: @spot_plan_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spot_plan_item
    assert_response :success
  end

  test "should update spot_plan_item" do
    put :update, id: @spot_plan_item, spot_plan_item: {  }
    assert_redirected_to spot_plan_item_path(assigns(:spot_plan_item))
  end

  test "should destroy spot_plan_item" do
    assert_difference('SpotPlanItem.count', -1) do
      delete :destroy, id: @spot_plan_item
    end

    assert_redirected_to spot_plan_items_path
  end
end
