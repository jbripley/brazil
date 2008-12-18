require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:revisions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create revision" do
    assert_difference('Revision.count') do
      post :create, :revision => { }
    end

    assert_redirected_to revision_path(assigns(:revision))
  end

  test "should show revision" do
    get :show, :id => revisions(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => revisions(:one).id
    assert_response :success
  end

  test "should update revision" do
    put :update, :id => revisions(:one).id, :revision => { }
    assert_redirected_to revision_path(assigns(:revision))
  end

  test "should destroy revision" do
    assert_difference('Revision.count', -1) do
      delete :destroy, :id => revisions(:one).id
    end

    assert_redirected_to revisions_path
  end
end
