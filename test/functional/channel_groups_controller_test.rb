require 'test_helper'

class ChannelGroupsControllerTest < ActionController::TestCase
  setup do
    @channel_group = channel_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:channel_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create channel_group" do
    assert_difference('ChannelGroup.count') do
      post :create, channel_group: {  }
    end

    assert_redirected_to channel_group_path(assigns(:channel_group))
  end

  test "should show channel_group" do
    get :show, id: @channel_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @channel_group
    assert_response :success
  end

  test "should update channel_group" do
    put :update, id: @channel_group, channel_group: {  }
    assert_redirected_to channel_group_path(assigns(:channel_group))
  end

  test "should destroy channel_group" do
    assert_difference('ChannelGroup.count', -1) do
      delete :destroy, id: @channel_group
    end

    assert_redirected_to channel_groups_path
  end
end
