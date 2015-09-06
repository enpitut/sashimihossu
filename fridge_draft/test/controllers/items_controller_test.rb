require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  setup do
    @item = items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item" do
    assert_difference('Item.count') do
      post :create, item: { amount_at_once: @item.amount_at_once, description: @item.description, gram_at_once: @item.gram_at_once, icon: @item.icon, name: @item.name, price_at_once: @item.price_at_once, price_at_one_amount: @item.price_at_one_amount, price_at_one_gram: @item.price_at_one_gram }
    end

    assert_redirected_to item_path(assigns(:item))
  end

  test "should show item" do
    get :show, id: @item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item
    assert_response :success
  end

  test "should update item" do
    patch :update, id: @item, item: { amount_at_once: @item.amount_at_once, description: @item.description, gram_at_once: @item.gram_at_once, icon: @item.icon, name: @item.name, price_at_once: @item.price_at_once, price_at_one_amount: @item.price_at_one_amount, price_at_one_gram: @item.price_at_one_gram }
    assert_redirected_to item_path(assigns(:item))
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete :destroy, id: @item
    end

    assert_redirected_to items_path
  end
end
