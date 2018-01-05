require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:pivotal_tracker)
    @company = @product.company
    @auth_headers = users(:one).create_new_auth_token
  end

  test "should not get index if not signed in" do
    get company_products_url(@company.id), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should get index" do
    get company_products_url(@company.id), headers: @auth_headers, as: :json

    assert_response :success

    products = @company.products
    expected = products.as_json
    # Call associated methods for each product
    expected.each_with_index do |product, idx|
      product["reviews_count"] = products[idx].reviews_count
      product["aggregate_score"] = products[idx].aggregate_score
    end
    assert_equal expected.to_json, response.body
  end

  test "should not create product if not signed in" do
    product = {
      name: "Product Foo",
      description: "Lorem ipsum"
    }
    assert_no_difference('Product.count') do
      post company_products_url(@company.id), params: { product: product }, as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should create product" do
    product = {
      name: "Product Foo",
      description: "Lorem ipsum"
    }
    assert_difference('Product.count') do
      post company_products_url(@company.id), params: { product: product }, headers: @auth_headers, as: :json
    end

    assert_response 201
  end

  test "should not show product if not signed in" do
    get product_url(@product), as: :json

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should show product" do
    get product_url(@product), headers: @auth_headers, as: :json

    assert_response :success

    # Call associated methods on product
    expected = @product.as_json
    expected["reviews_count"] = @product.reviews_count
    expected["aggregate_score"] = @product.aggregate_score
    expected["company_name"] = @product.company_name

    assert_equal expected.to_json, response.body
  end

  test "should not update product if not signed in" do
    current = {
      name: @product.name,
      description: @product.description
    }
    updated = {
      name: "New Product",
      description: "New description"
    }
    patch product_url(@product), params: { product: updated }, as: :json

    # Assert unchanged
    @product.reload
    assert_equal current[:name], @product.name
    assert_equal current[:description], @product.description

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should update product" do
    updated = {
      name: "New Product",
      description: "New description"
    }
    patch product_url(@product), params: { product: updated }, headers: @auth_headers, as: :json

    @product.reload
    assert_equal updated[:name], @product.name
    assert_equal updated[:description], @product.description

    assert_response 200
  end

  test "should not destroy product if not signed in" do
    assert_no_difference('Product.count') do
      delete product_url(@product), as: :json
    end

    assert_response 401
    assert_not_signed_in_error response.body
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product), headers: @auth_headers, as: :json
    end

    assert_response 204
  end
end
