require 'test_helper'

class ShoppingManagementDevelopmentsControllerTest < ActionController::TestCase
  setup do
    @shopping_management_development = shopping_management_developments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shopping_management_developments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shopping_management_development" do
    assert_difference('ShoppingManagementDevelopment.count') do
      post :create, shopping_management_development: { amount: @shopping_management_development.amount, categoryCd: @shopping_management_development.categoryCd, date: @shopping_management_development.date, goods: @shopping_management_development.goods, place: @shopping_management_development.place, sum: @shopping_management_development.sum }
    end

    assert_redirected_to shopping_management_development_path(assigns(:shopping_management_development))
  end

  test "should show shopping_management_development" do
    get :show, id: @shopping_management_development
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shopping_management_development
    assert_response :success
  end

  test "should update shopping_management_development" do
    patch :update, id: @shopping_management_development, shopping_management_development: { amount: @shopping_management_development.amount, categoryCd: @shopping_management_development.categoryCd, date: @shopping_management_development.date, goods: @shopping_management_development.goods, place: @shopping_management_development.place, sum: @shopping_management_development.sum }
    assert_redirected_to shopping_management_development_path(assigns(:shopping_management_development))
  end

  test "should destroy shopping_management_development" do
    assert_difference('ShoppingManagementDevelopment.count', -1) do
      delete :destroy, id: @shopping_management_development
    end

    assert_redirected_to shopping_management_developments_path
  end
end
