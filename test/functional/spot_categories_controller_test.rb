require 'test_helper'

class SpotCategoriesControllerTest < ActionController::TestCase
  setup do
    @spot_category = spot_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spot_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spot_category" do
    assert_difference('SpotCategory.count') do
      post :create, spot_category: {  }
    end

    assert_redirected_to spot_category_path(assigns(:spot_category))
  end

  test "should show spot_category" do
    get :show, id: @spot_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spot_category
    assert_response :success
  end

  test "should update spot_category" do
    put :update, id: @spot_category, spot_category: {  }
    assert_redirected_to spot_category_path(assigns(:spot_category))
  end

  test "should destroy spot_category" do
    assert_difference('SpotCategory.count', -1) do
      delete :destroy, id: @spot_category
    end

    assert_redirected_to spot_categories_path
  end
end
