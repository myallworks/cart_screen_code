import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import '../widgets/food_item_card.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ApiService _apiService = ApiService();
  List<FoodItem> _menuItems = [];
  bool _isLoading = true;
  String? _error;
  String _sortOrder = 'Low To High'; // Default sort order

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final items = await _apiService.getMenuItems();
      setState(() {
        _menuItems = items;
        _isLoading = false;
      });
      _sortMenuItems();
    } catch (e) {
      setState(() {
        _error = 'Failed to load menu items: $e';
        _isLoading = false;
      });
    }
  }

  void _sortMenuItems() {
    setState(() {
      if (_sortOrder == 'Low To High') {
        _menuItems.sort((a, b) => a.originalPrice.compareTo(b.originalPrice));
      } else {
        _menuItems.sort((a, b) => b.originalPrice.compareTo(a.originalPrice));
      }
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _sortOrder = _sortOrder == 'Low To High' ? 'High To Low' : 'Low To High';
      _sortMenuItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _fetchMenuItems,
                  child: Column(
                    children: [

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [

                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppTheme.vegColor),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.circle,
                                    size: 12,
                                    color: AppTheme.vegColor,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text('Veg'),
                              ],
                            ),
                            SizedBox(width: 16),

                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppTheme.nonVegColor),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.change_history,
                                    size: 12,
                                    color: AppTheme.nonVegColor,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text('Non-veg'),
                              ],
                            ),

                            Spacer(),

                            GestureDetector(
                              onTap: _toggleSortOrder,
                              child: Row(
                                children: [
                                  Text(
                                    _sortOrder,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    _sortOrder == 'Low To High'
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _menuItems.length,
                          itemBuilder: (context, index) {
                            return FoodItemCard(
                              foodItem: _menuItems[index],
                              onAddToCart: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${_menuItems[index].name} added to cart'),
                                    duration: Duration(seconds: 2),
                                    action: SnackBarAction(
                                      label: 'VIEW CART',
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => CartScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
