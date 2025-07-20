import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class QuanitityCounter extends ConsumerWidget {
//   const QuanitityCounter({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }



class QuantityCounterNotifier extends StateNotifier<List<int>> {
  
  QuantityCounterNotifier() : super([]);

  void add(int number) {
    state = [...state, number];
  }

  void delete(int number) {
    // Find the first occurrence of the number and remove only that one
    final newState = [...state];
    final index = newState.indexOf(number);
    if (index != -1) {
      newState.removeAt(index);
    }
    state = newState;
  }
}

final quantityCounterProvider = StateNotifierProvider<QuantityCounterNotifier, List<int>>((ref) {
  return QuantityCounterNotifier();
});

class CustomQuantityCounter extends ConsumerWidget {
  final int itemId;
  final VoidCallback? onChanged;
  
  const CustomQuantityCounter({
    super.key,
    required this.itemId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(quantityCounterProvider);
    final quantity = cartItems.where((id) => id == itemId).length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: quantity > 0 ? () {
            ref.read(quantityCounterProvider.notifier).delete(itemId);
            onChanged?.call();
          } : null,
          icon: const Icon(Icons.remove),
        ),
        
        // Quantity display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Increase button
        IconButton(
          onPressed: () {
            ref.read(quantityCounterProvider.notifier).add(itemId);
            onChanged?.call();
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
// class Quanitity extends StatelessWidget {
//   const Quanitity({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef, ref) {
//     return Container();
//   }
// }