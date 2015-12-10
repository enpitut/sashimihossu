require 'test_helper'

class FreshnessesControllerTest < ActionController::TestCase
  setup do
    @freshness = freshnesses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:freshnesses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create freshness" do
    assert_difference('Freshness.count') do
      post :create, freshness: { freshness: @freshness.freshness, name: @freshness.name }
    end

    assert_redirected_to freshness_path(assigns(:freshness))
  end

  test "should show freshness" do
    get :show, id: @freshness
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @freshness
    assert_response :success
  end

  test "should update freshness" do
    patch :update, id: @freshness, freshness: { freshness: @freshness.freshness, name: @freshness.name }
    assert_redirected_to freshness_path(assigns(:freshness))
  end

  test "should destroy freshness" do
    assert_difference('Freshness.count', -1) do
      delete :destroy, id: @freshness
    end

    assert_redirected_to freshnesses_path
  end
end
