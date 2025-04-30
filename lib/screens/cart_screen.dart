import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _specialInstructionsController =
      TextEditingController();
  bool _showSpecialInstructions = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() => _loadCartData(context));
  }

  Future<void> _loadCartData(BuildContext context) async {
    if (!_isInitialized) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.loadCart();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: FutureBuilder(

        future: _isInitialized ? null : _loadCartData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<CartProvider>(
            builder: (ctx, cartProvider, child) {
              final items = cartProvider.items;

              if (cartProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (cartProvider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading cart',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cartProvider.error ?? 'Unknown error',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => cartProvider.loadCart(),
                        child: const Text('RETRY'),
                      ),
                    ],
                  ),
                );
              }

              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        size: 100,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add items to get started',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('BACK TO MENU'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Address',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'wefft, Mumbai, Maharashtra, 451234',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    ListView.builder(
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return CartItemCard(cartItem: items[index]);
                      },
                    ),

                    if (_showSpecialInstructions)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _specialInstructionsController,
                          decoration: const InputDecoration(
                            labelText: 'Special cooking instructions',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _showSpecialInstructions = true;
                            });
                          },
                          icon:
                              Icon(Icons.note_add, color: AppTheme.accentColor),
                          label: Text(
                            'Special cooking instructions',
                            style: TextStyle(color: AppTheme.accentColor),
                          ),
                          style: TextButton.styleFrom(
                            side: BorderSide(
                                color: AppTheme.accentColor.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: TextField(
                        controller: _couponController,
                        decoration: InputDecoration(
                          hintText: 'Coupon Code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        children: [

                          ...items
                              .map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${item.quantity ?? 0} x ${item.menuName ?? "Unknown Item"}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        const Spacer(),
                                        Text(
                                          '₹${item.totalPrice.toStringAsFixed(0)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),

                          const Divider(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sub Total',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '₹${cartProvider.totalAmount.toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Charges',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '₹0',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Bill',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                '₹${cartProvider.totalAmount.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [

                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _processPayment(context, 'cash');
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppTheme.accentColor),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Cash on delivery'),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _processPayment(context, 'online');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF47F1F),

                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Pay Now'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _processPayment(BuildContext context, String method) {



    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          method == 'cash'
              ? 'Order placed successfully! You will pay on delivery.'
              : 'Payment successful! Your order is confirmed.',
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.clearCart();

    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
