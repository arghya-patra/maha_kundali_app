class ApiResponse {
  final int status;
  final bool isSuccess;
  final ProductDetails productDetails;
  final List<ShopCategory> shopCategory;
  final List<SimilarProduct> similarProductList;

  ApiResponse({
    required this.status,
    required this.isSuccess,
    required this.productDetails,
    required this.shopCategory,
    required this.similarProductList,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      isSuccess: json['isSuccess'],
      productDetails: ProductDetails.fromJson(json['productDetails']),
      shopCategory: (json['shop_category'] as List)
          .map((item) => ShopCategory.fromJson(item))
          .toList(),
      similarProductList: (json['similar_product_list'] as List)
          .map((item) => SimilarProduct.fromJson(item))
          .toList(),
    );
  }
}

class ProductDetails {
  final String productId;
  final String productTitle;
  final String authorizationToken;
  final String catId;
  final String catName;
  final String productPrice;
  final String salePrice;
  final String description;
  final String productPhoto;

  ProductDetails({
    required this.productId,
    required this.productTitle,
    required this.authorizationToken,
    required this.catId,
    required this.catName,
    required this.productPrice,
    required this.salePrice,
    required this.description,
    required this.productPhoto,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      productId: json['product_id'],
      productTitle: json['product_title'],
      authorizationToken: json['authorizationToken'],
      catId: json['cat_id'],
      catName: json['cat_name'],
      productPrice: json['product_price'],
      salePrice: json['sale_price'],
      description: json['description'],
      productPhoto: json['product_photo'],
    );
  }
}

class ShopCategory {
  final String catId;
  final String catName;

  ShopCategory({
    required this.catId,
    required this.catName,
  });

  factory ShopCategory.fromJson(Map<String, dynamic> json) {
    return ShopCategory(
      catId: json['cat_id'],
      catName: json['cat_name'],
    );
  }
}

class SimilarProduct {
  final String productId;
  final String productTitle;
  final String catId;
  final String catName;
  final String productPrice;
  final String salePrice;
  final String description;
  final String productPhoto;

  SimilarProduct({
    required this.productId,
    required this.productTitle,
    required this.catId,
    required this.catName,
    required this.productPrice,
    required this.salePrice,
    required this.description,
    required this.productPhoto,
  });

  factory SimilarProduct.fromJson(Map<String, dynamic> json) {
    return SimilarProduct(
      productId: json['product_id'],
      productTitle: json['product_title'],
      catId: json['cat_id'],
      catName: json['cat_name'],
      productPrice: json['product_price'],
      salePrice: json['sale_price'],
      description: json['description'],
      productPhoto: json['product_photo'],
    );
  }
}
