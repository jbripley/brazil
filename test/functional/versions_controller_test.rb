require 'test_helper'

class VersionRevisionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:version_revisions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_version_revision
    assert_difference('VersionRevision.count') do
      post :create, :version_revision => { }
    end

    assert_redirected_to version_revision_path(assigns(:version_revision))
  end

  def test_should_show_version_revision
    get :show, :id => version_revisions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => version_revisions(:one).id
    assert_response :success
  end

  def test_should_update_version_revision
    put :update, :id => version_revisions(:one).id, :version_revision => { }
    assert_redirected_to version_revision_path(assigns(:version_revision))
  end

  def test_should_destroy_version_revision
    assert_difference('VersionRevision.count', -1) do
      delete :destroy, :id => version_revisions(:one).id
    end

    assert_redirected_to version_revisions_path
  end
end
