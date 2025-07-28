
import 'package:flutter/material.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({super.key});

  @override
  State<ViewCart> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  @override


  final mockCart = [

  ];
  @override
  Widget build(BuildContext context) {
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
        onPressed: () {

        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // 'Bekijk winkelwagen (${cart.totalItems} items)',
              'Bekijk',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              // '€${cart.totalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
              '33',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}