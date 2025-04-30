import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback? onAddToCart;

  const FoodItemCard({
    Key? key,
    required this.foodItem,
    this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final cartItem = cartProvider.findById(foodItem.id);
        final isInCart = cartItem != null;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: foodItem.foodType == "Veg"
                              ? AppTheme.vegColor
                              : AppTheme.nonVegColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        foodItem.foodType == "Veg"
                            ? Icons.circle
                            : Icons.change_history,
                        size: 12,
                        color: foodItem.foodType == "Veg"
                            ? AppTheme.vegColor
                            : AppTheme.nonVegColor,
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodItem.hotelName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            foodItem.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color: index < foodItem.rating.floor()
                                      ? AppTheme.accentColor
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              if (foodItem.hasDiscount) ...[
                                Text(
                                  '₹${foodItem.originalPrice.toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '₹${foodItem.effectivePrice.toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ] else ...[
                                Text(
                                  '₹${foodItem.originalPrice.toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: foodItem.image != null
                            ? Image.network(
                                foodItem.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, error, _) => Container(
                                  color: Colors.grey.shade200,
                                  child: Center(
                                    child: Text(
                                      'MM',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: Text(
                                    'MM',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: isInCart
                      ? _buildQuantityController(
                          context, cartItem!.quantity ?? 0)
                      : _buildAddButton(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        await cartProvider.addToCart(foodItem);
        if (onAddToCart != null) {
          onAddToCart!();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.accentColor,
        side: BorderSide(color: AppTheme.accentColor.withOpacity(0.2)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: Text('ADD', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildQuantityController(BuildContext context, int quantity) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.accentColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: AppTheme.accentColor),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false)
                  .decrementQuantity(foodItem.id);
            },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: AppTheme.accentColor),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false)
                  .incrementQuantity(foodItem.id);
            },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
