import 'package:food_delivery_app/services/api_service.dart';

class FoodItem {
  final int id;
  final String name;
  final String description;
  final int partnerId;
  final String partnerName;
  final String hotelName;
  final int foodCategoryId;
  final String foodCategoryName;
  final String foodType;
  final String sizeType;
  final double originalPrice;
  final double discountedPrice;
  final double regularOriginalPrice;
  final double regularDiscountedPrice;
  final double mediumOriginalPrice;
  final double mediumDiscountedPrice;
  final double largeOriginalPrice;
  final double largeDiscountedPrice;
  final double extraLargeOriginalPrice;
  final double extraLargeDiscountedPrice;
  final double originalPriceAfterCommission;
  final double discountedPriceAfterCommission;
  final String? image;
  final String status;
  final int numberOfOrder;
  final double rating;
  final String uploadedFrom;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int cartQuantity;
  final int cartId;
  final String hotelStatus;
  final dynamic
      partner; // Keeping as dynamic since it's null in the provided data

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.partnerId,
    required this.partnerName,
    required this.hotelName,
    required this.foodCategoryId,
    required this.foodCategoryName,
    required this.foodType,
    required this.sizeType,
    required this.originalPrice,
    required this.discountedPrice,
    required this.regularOriginalPrice,
    required this.regularDiscountedPrice,
    required this.mediumOriginalPrice,
    required this.mediumDiscountedPrice,
    required this.largeOriginalPrice,
    required this.largeDiscountedPrice,
    required this.extraLargeOriginalPrice,
    required this.extraLargeDiscountedPrice,
    required this.originalPriceAfterCommission,
    required this.discountedPriceAfterCommission,
    this.image,
    required this.status,
    required this.numberOfOrder,
    required this.rating,
    required this.uploadedFrom,
    required this.createdAt,
    required this.updatedAt,
    required this.cartQuantity,
    required this.cartId,
    required this.hotelStatus,
    this.partner,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      partnerId: json['partner_id'] ?? 0,
      partnerName: json['partner_name'] ?? '',
      hotelName: json['hotel_name'] ?? '',
      foodCategoryId: json['food_category_id'] ?? 0,
      foodCategoryName: json['food_category_name'] ?? '',
      foodType: json['food_type'] ?? '',
      sizeType: json['size_type'] ?? '',
      originalPrice: _parseToDouble(json['original_price']),
      discountedPrice: _parseToDouble(json['discounted_price']),
      regularOriginalPrice: _parseToDouble(json['regular_original_price']),
      regularDiscountedPrice: _parseToDouble(json['regular_discounted_price']),
      mediumOriginalPrice: _parseToDouble(json['medium_original_price']),
      mediumDiscountedPrice: _parseToDouble(json['medium_discounted_price']),
      largeOriginalPrice: _parseToDouble(json['large_original_price']),
      largeDiscountedPrice: _parseToDouble(json['large_discounted_price']),
      extraLargeOriginalPrice:
          _parseToDouble(json['extra_large_original_price']),
      extraLargeDiscountedPrice:
          _parseToDouble(json['extra_large_discounted_price']),
      originalPriceAfterCommission:
          _parseToDouble(json['original_price_after_commission']),
      discountedPriceAfterCommission:
          _parseToDouble(json['discounted_price_after_commission']),
      image: ApiService.baseUrl + json['image'],
      status: json['status'] ?? '',
      numberOfOrder: json['number_of_order'] ?? 0,
      rating: _parseToDouble(json['rating']),
      uploadedFrom: json['uploaded_from'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      cartQuantity: json['cart_quantity'] ?? 0,
      cartId: json['cart_id'] ?? 0,
      hotelStatus: json['hotel_status'] ?? '',
      partner: json['partner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'partner_id': partnerId,
      'partner_name': partnerName,
      'hotel_name': hotelName,
      'food_category_id': foodCategoryId,
      'food_category_name': foodCategoryName,
      'food_type': foodType,
      'size_type': sizeType,
      'original_price': originalPrice,
      'discounted_price': discountedPrice,
      'regular_original_price': regularOriginalPrice,
      'regular_discounted_price': regularDiscountedPrice,
      'medium_original_price': mediumOriginalPrice,
      'medium_discounted_price': mediumDiscountedPrice,
      'large_original_price': largeOriginalPrice,
      'large_discounted_price': largeDiscountedPrice,
      'extra_large_original_price': extraLargeOriginalPrice,
      'extra_large_discounted_price': extraLargeDiscountedPrice,
      'original_price_after_commission': originalPriceAfterCommission,
      'discounted_price_after_commission': discountedPriceAfterCommission,
      'image': image,
      'status': status,
      'number_of_order': numberOfOrder,
      'rating': rating,
      'uploaded_from': uploadedFrom,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'cart_quantity': cartQuantity,
      'cart_id': cartId,
      'hotel_status': hotelStatus,
      'partner': partner,
    };
  }

  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      try {
        return double.parse(value);
      } catch (_) {
        return 0.0;
      }
    }
    return 0.0;
  }

  double get effectivePrice {
    return discountedPrice > 0 ? discountedPrice : originalPrice;
  }

  bool get isVeg {
    return foodType.toLowerCase() == 'veg';
  }

  bool get hasDiscount {
    return discountedPrice > 0 && discountedPrice < originalPrice;
  }

  double get discountPercentage {
    if (hasDiscount && originalPrice > 0) {
      return ((originalPrice - discountedPrice) / originalPrice) * 100;
    }
    return 0.0;
  }

  bool get isInCart {
    return cartQuantity > 0;
  }

  FoodItem copyWithCartQuantity(int quantity) {
    return FoodItem(
      id: id,
      name: name,
      description: description,
      partnerId: partnerId,
      partnerName: partnerName,
      hotelName: hotelName,
      foodCategoryId: foodCategoryId,
      foodCategoryName: foodCategoryName,
      foodType: foodType,
      sizeType: sizeType,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      regularOriginalPrice: regularOriginalPrice,
      regularDiscountedPrice: regularDiscountedPrice,
      mediumOriginalPrice: mediumOriginalPrice,
      mediumDiscountedPrice: mediumDiscountedPrice,
      largeOriginalPrice: largeOriginalPrice,
      largeDiscountedPrice: largeDiscountedPrice,
      extraLargeOriginalPrice: extraLargeOriginalPrice,
      extraLargeDiscountedPrice: extraLargeDiscountedPrice,
      originalPriceAfterCommission: originalPriceAfterCommission,
      discountedPriceAfterCommission: discountedPriceAfterCommission,
      image: image,
      status: status,
      numberOfOrder: numberOfOrder,
      rating: rating,
      uploadedFrom: uploadedFrom,
      createdAt: createdAt,
      updatedAt: updatedAt,
      cartQuantity: quantity,
      cartId: cartId,
      hotelStatus: hotelStatus,
      partner: partner,
    );
  }
}
