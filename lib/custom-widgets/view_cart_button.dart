// !! WIP Still in progress not complete skipped to work on something else

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hf_customer_app/listener/cart_listener.dart';

class ViewCartButton extends ConsumerWidget {
  final VoidCallback onPressed;

  const ViewCartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    // Only show if cart has items - this is the "magic" auto-show/hide behavior
    if (cart.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bekijk winkelwagen (${cart.totalItems} items)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '€${cart.totalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}