import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewCart extends StatefulWidget {
 final String? restaurantSpecialInstructions;
  const  ViewCart({super.key,  this.restaurantSpecialInstructions});

  @override
  State<ViewCart> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> cartItems = [
    {
      "id": 1,
      "name": "Pizza - Cheese Lovers",
      "image": "🍕",
      "basePrice": 12.99,
      "quantity": 1,
      "options": [
        {"name": "Extra Cheese", "price": 1.50},
        {"name": "Crust: Stuffed", "price": 2.00},
        {"name": "Side: Chicken Nuggets (6 pcs)", "price": 4.50},
      ],
    },
    {
      "id": 2,
      "name": "Burger - Classic Beef",
      "image": "🍔",
      "basePrice": 9.49,
      "quantity": 2,
      "options": [
        {"name": "Add Bacon", "price": 1.25},
        {"name": "Extra Pickles", "price": 0.0},
      ],
    },
    {
      "id": 3,
      "name": "Pasta - Alfredo",
      "image": "🍝",
      "basePrice": 11.75,
      "quantity": 1,
      "options": [
        {"name": "Add Grilled Chicken", "price": 2.00},
        {"name": "Side: Garlic Bread", "price": 3.00},
      ],
    },
    {
      "id": 4,
      "name": "Soft Drink - Cola",
      "image": "🥤",
      "basePrice": 2.00,
      "quantity": 3,
      "options": [
        {"name": "Size: Large", "price": 0.50},
        {"name": "Ice: No Ice", "price": 0.0},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double calculateItemTotal(Map<String, dynamic> item) {
    double optionsTotal = item['options'].fold(
      0.0,
      (sum, opt) => sum + (opt['price'] as double),
    );
    return (item['basePrice'] + optionsTotal) * item['quantity'];
  }

  void updateQuantity(int itemId, int newQuantity) {
    setState(() {
      final itemIndex = cartItems.indexWhere((item) => item['id'] == itemId);
      if (itemIndex != -1) {
        if (newQuantity <= 0) {
          cartItems.removeAt(itemIndex);
        } else {
          cartItems[itemIndex]['quantity'] = newQuantity;
        }
      }
    });
  }

  void removeItem(int itemId) {
    setState(() {
      cartItems.removeWhere((item) => item['id'] == itemId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(
      0.0,
      (sum, item) => sum + calculateItemTotal(item),
    );
    double tax = subtotal * 0.10;
    double total = subtotal + tax;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Your Cart",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: Duration(
                              milliseconds: 300 + (index * 100),
                            ),
                            curve: Curves.easeOutBack,
                            child: _buildCartItem(cartItems[index], index),
                          );
                        },
                      ),
                    ),
                    _buildOrderSummary(subtotal, tax, total),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(onPressed: () {

              print( widget.restaurantSpecialInstructions);
            }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Add some delicious items to get started!",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3498DB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          item['image'],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Base Price: \$${item['basePrice'].toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[400],
                        size: 24,
                      ),
                      onPressed: () => removeItem(item['id']),
                    ),
                  ],
                ),
                if (item['options'].isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Customizations:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...item['options'].map<Widget>((option) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3498DB),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${option['name']} ${option['price'] > 0 ? '(+\$${option['price'].toStringAsFixed(2)})' : '(Free)'}",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Color(0xFF3498DB),
                            ),
                            onPressed: () => updateQuantity(
                              item['id'],
                              item['quantity'] - 1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "${item['quantity']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xFF3498DB),
                            ),
                            onPressed: () => updateQuantity(
                              item['id'],
                              item['quantity'] + 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "\$${calculateItemTotal(item).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal, double tax, double total) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _buildSummaryRow("Subtotal", subtotal, false),
            _buildSummaryRow("Tax (10%)", tax, false),
            const Divider(height: 32, thickness: 1, color: Color(0xFFE0E0E0)),
            _buildSummaryRow("Total", total, true),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3498DB).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    context.pushNamed(
                      'confirmOrder',

                      extra: {
                        'cartItems': cartItems,
                        'total': total,
                        'subtotal': subtotal,
                        'tax': tax,
                        'restaurantSpecialInstructions': widget.restaurantSpecialInstructions,

                      },
                    );
   
                  },
                  child: const Center(
                    child: Text(
                      "View Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, double amount, bool isBold) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? const Color(0xFF2C3E50) : Colors.grey[700],
            ),
          ),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: isBold ? 20 : 16,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: isBold ? const Color(0xFF27AE60) : const Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  
  }
  
}
