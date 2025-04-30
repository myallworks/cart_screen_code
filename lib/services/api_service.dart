import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cart_item.dart';
import '../models/food_item.dart';

class ApiService {

  static const String baseUrl = 'https://thealaddin.in/mmApi/api';

  final String? authToken;

  ApiService({this.authToken});

  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  Future<List<FoodItem>> getMenuItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/show/menu-list?customer_id=1115&hotel_id=11'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> menuItemsJson = jsonData['data'] ?? [];

        return menuItemsJson.map((item) => FoodItem.fromJson(item)).toList();
      } else {

        print('Failed to load menu items. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<bool> addToCart(CartItem cartItem) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add/cart'),
        headers: _getHeaders(),
        body: jsonEncode({
          "menu_id": cartItem.id,
          "customer_id": "1115",
          "partner_id": cartItem.partnerId,
          "quantity": cartItem.quantity,
          "size": cartItem.size,
          "amount": cartItem.totalPrice
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

        return true;
      } else {
        print(
            'Failed to add item to cart. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  Future<bool> updateCartItemQuantity(int cartId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-remove/quantity/cart'),
        headers: _getHeaders(),
        body: jsonEncode({
          'cart_id': cartId,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {

        return true;
      } else {
        print('Failed to update cart. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating cart: $e');
      return false;
    }
  }

  Future<List<CartItem>> getCartItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/show/cart?customer_id=1115'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200 || response.body != null) {
        final jsonData = json.decode(response.body);
        final List<dynamic> cartItemsJson = jsonData['data'] ?? [];

        return cartItemsJson.map((item) => CartItem.fromJson(item)).toList();
      } else {
        print('Failed to load cart items. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      throw Exception('Network error: $e');
    }
  }























}
