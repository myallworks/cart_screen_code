import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/food_item.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<CartItem> _items = [];
  bool _isLoading = false;
  String? _error;

  List<CartItem> get items => _items;

  bool get isLoading => _isLoading;

  String? get error => _error;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  CartItem? findById(int id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addToCart(FoodItem foodItem,
      {int quantity = 1, String? specialInstructions}) async {
    _setLoading(true);

    try {

      final existingCartItemIndex =
          _items.indexWhere((item) => item.id == foodItem.id);

      if (existingCartItemIndex >= 0) {

        await incrementQuantity(_items[existingCartItemIndex].id, quantity);
      } else {

        final newCartItem = CartItem(
          id: foodItem.id,
          quantity: quantity,
          menuId: foodItem.id,
          customerId: "1115",
          partnerId: foodItem.partnerId,
          menuName: foodItem.name,
          menuPrice: foodItem.originalPrice,
          uploadedFrom: foodItem.uploadedFrom,
          size: foodItem.sizeType,
          createdAt: foodItem.createdAt,
          updatedAt: foodItem.updatedAt,
          hotelName: foodItem.hotelName,
        );

        final success = await _apiService.addToCart(newCartItem);

        if (success) {
          _items.add(newCartItem);
          notifyListeners();
        } else {
          _setError('Failed to add item to cart');
        }
      }
    } catch (e) {
      _setError('An error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> incrementQuantity(int foodItemId, [int amount = 1]) async {
    _setLoading(true);

    try {
      final cartItemIndex = _items.indexWhere((item) => item.id == foodItemId);

      if (cartItemIndex >= 0) {
        final newQuantity = (_items[cartItemIndex].quantity ?? 0) + 1;

        final success =
            await _apiService.updateCartItemQuantity(foodItemId, "Add");

        if (success) {
          _items[cartItemIndex].quantity = newQuantity;
          notifyListeners();
        } else {
          _setError('Failed to update quantity');
        }
      }
    } catch (e) {
      _setError('An error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> decrementQuantity(int foodItemId) async {
    _setLoading(true);

    try {
      final cartItemIndex = _items.indexWhere((item) => item.id == foodItemId);

      if (cartItemIndex >= 0) {
        if ((_items[cartItemIndex].quantity ?? 0) > 1) {
          final newQuantity = _items[cartItemIndex].quantity ?? 0 - 1;

          final success =
              await _apiService.updateCartItemQuantity(foodItemId, "Remove");

          if (success) {
            _items[cartItemIndex].quantity = newQuantity;
            notifyListeners();
          } else {
            _setError('Failed to update quantity');
          }
        } else {

          await removeItem(foodItemId);
        }
      }
    } catch (e) {
      _setError('An error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeItem(int foodItemId) async {
    _setLoading(true);

    try {

      final success =
          await _apiService.updateCartItemQuantity(foodItemId, "Remove");

      if (success) {
        _items.removeWhere((item) => item.id == foodItemId);
        notifyListeners();
      } else {
        _setError('Failed to remove item');
      }
    } catch (e) {
      _setError('An error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();
  }

  void updateSpecialInstructions(int foodItemId, String instructions) {
    final cartItemIndex = _items.indexWhere((item) => item.id == foodItemId);




  }

  Future<void> loadCart() async {
    _setLoading(true);
    _error = null;

    try {
      final cartItems = await _apiService.getCartItems();
      _items.clear();
      _items.addAll(cartItems);
    } catch (e) {
      _setError('Failed to load cart: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _error = null;
    }
    notifyListeners();
  }

  void _setError(String errorMsg) {
    _error = errorMsg;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
