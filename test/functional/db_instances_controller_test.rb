require 'test_helper'

class DbInstancesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:db_instances)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_db_instance
    assert_difference('DbInstance.count') do
      post :create, :db_instance => { }
    end

    assert_redirected_to db_instance_path(assigns(:db_instance))
  end

  def test_should_show_db_instance
    get :show, :id => db_instances(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => db_instances(:one).id
    assert_response :success
  end

  def test_should_update_db_instance
    put :update, :id => db_instances(:one).id, :db_instance => { }
    assert_redirected_to db_instance_path(assigns(:db_instance))
  end

  def test_should_destroy_db_instance
    assert_difference('DbInstance.count', -1) do
      delete :destroy, :id => db_instances(:one).id
    end

    assert_redirected_to db_instances_path
  end
end
