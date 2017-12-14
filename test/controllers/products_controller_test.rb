require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:pivotal_tracker)
    @company = @product.company
  end

  test "should get index" do
    get company_products_url(@company.id), as: :json

    assert_response :success
    assert_equal @company.products.to_json, response.body
  end

  test "should create product" do
    product = {
      name: "Product Foo",
      description: "Lorem ipsum",
      company_id: @company.id
    }
    assert_difference('Product.count') do
      post company_products_url(@company.id), params: { product: product }, as: :json
    end

    assert_response 201
  end

  test "should show product" do
    get product_url(@product), as: :json
    assert_response :success
    assert_equal @product.to_json, response.body
  end

  test "should update product" do
    updated = {
      name: "New Product",
      description: "New description"
    }
    patch product_url(@product), params: { product: updated }, as: :json
    assert_response 200
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product), as: :json
    end

    assert_response 204
  end
end
