class CartItem {
  final int id;
  final int? menuId;
  final String? customerId;
  final int? partnerId;
  int? quantity;
  final String? menuName;

  final double? menuPrice;
  final String? uploadedFrom;
  final String? size;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? hotelName;

  CartItem({
    required this.id,
    this.menuId,
    this.customerId,
    this.partnerId,
    this.quantity,
    this.menuName,

    this.menuPrice,
    this.uploadedFrom,
    this.size,
    this.createdAt,
    this.updatedAt,
    this.hotelName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      menuId: json['menu_id'],
      customerId: json['customer_id'],
      partnerId: json['partner_id'],
      quantity: json['quantity'],
      menuName: json['menu_name'],

      menuPrice: json['menu_price'] is int
          ? (json['menu_price'] as int).toDouble()
          : json['menu_price'],
      uploadedFrom: json['uploaded_from'],
      size: json['size'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      hotelName: json['hotel_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_id': menuId,
      'customer_id': customerId,
      'partner_id': partnerId,
      'quantity': quantity,
      'menu_name': menuName,
      'menu_image': null,
      'menu_price': menuPrice,
      'uploaded_from': uploadedFrom,
      'size': size,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'hotel_name': hotelName,
    };
  }

  factory CartItem.forAddToCart({
    required int menuId,
    required String customerId,
    required int partnerId,
    required int quantity,
    required String menuName,

    required double menuPrice,
    required String size,
    required String hotelName,
  }) {
    final now = DateTime.now();
    return CartItem(
      id: 0,

      menuId: menuId,
      customerId: customerId,
      partnerId: partnerId,
      quantity: quantity,
      menuName: menuName,

      menuPrice: menuPrice,
      uploadedFrom: 'Mobile',

      size: size,
      createdAt: now,
      updatedAt: now,
      hotelName: hotelName,
    );
  }

  CartItem copyWithQuantity(int newQuantity) {
    return CartItem(
      id: id,
      menuId: menuId,
      customerId: customerId,
      partnerId: partnerId,
      quantity: newQuantity,
      menuName: menuName,

      menuPrice: menuPrice,
      uploadedFrom: uploadedFrom,
      size: size,
      createdAt: createdAt,
      updatedAt: DateTime.now(),

      hotelName: hotelName,
    );
  }

  double get totalPrice => menuPrice! * quantity!;
}
