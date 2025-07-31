import 'package:flutter/material.dart';
import 'package:hf_customer_app/controller/auth_controller.dart';
import 'package:hf_customer_app/models/restaurant.dart';

class OrderConfirmationPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;
  final double subtotal;
  final double tax;
  final String? restaurantSpecialInstructions;
  const OrderConfirmationPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.subtotal,
    required this.tax,
    this.restaurantSpecialInstructions,
  });

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late bool isLoggedIn = false;


  // final bool isLoggedIn;
 
  final formKey = GlobalKey<FormState>();
  final nameControler = TextEditingController();

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final notesController = TextEditingController();

  bool _isLoading = false;

  final authController = AuthController();

  final List<String> _pickupTimes = [
    'ASAP (15-20 min)',
    '30 minutes',
    '45 minutes',
    '1 hour',
    '1.5 hours',
    '2 hours',
  ];

  @override
  void initState() {
    super.initState();
    retrieveUser();
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
    nameControler.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  double calculateItemTotal(Map<String, dynamic> item) {
    double optionsTotal = item['options'].fold(
      0.0,
      (sum, opt) => sum + (opt['price'] as double),
    );
    return (item['basePrice'] + optionsTotal) * item['quantity'];
  }

  void _proceedToPayment() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate processing
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Here you would integrate with Stripe
      if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Redirecting to payment...'),
            backgroundColor: const Color(0xFF27AE60),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // TODO: Implement Stripe checkout
        // Navigator.push(context, MaterialPageRoute(builder: (context) => StripeCheckoutPage()));
      });
    } 
  }
 

 Future<void> retrieveUser() async {

 final response =  await  authController.getUser();
 if(response == null ) {
  // return false;
 setState(() {
   
    isLoggedIn = false;
 });

 }
 final userEmail = response!.email;
 setState(() {
   
    isLoggedIn = true;
  
 });

 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            persistentFooterButtons: const [
        Text.rich(
          textAlign: TextAlign.start,
          
          TextSpan(
            children: [
              // TODO Make sure there are TOS links inside and correct text
              TextSpan(text: "Door te klikken op Maak bestelling gaat u akkord met onze privacy voorwaarden, en onze gegevens beleid " , style: TextStyle()),
            ],
          ),
        ),
      ],
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Confirm Order",
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
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  

                        // retrieveUser() == true ?

                       if( isLoggedIn == false) ...[

                              _buildSectionTitle(
                          "Customer Information",
                          Icons.person,
                        ), 
                        _buildCustomerInfoSection(),
                        const SizedBox(height: 24),


                       ]  ,


                       

                        

                        _buildSectionTitle("Pickup Details", Icons.access_time),
                        _buildPickupSection(),
                        const SizedBox(height: 24),
                        _buildSectionTitle(
                          "Restaurant information",
                          Icons.access_time,
                        ),


                        _buildRestaurantDetails(),
                        const SizedBox(height: 24),

                        _buildSectionTitle("Order Summary", Icons.receipt_long),
                        _buildOrderSummary(),
                        const SizedBox(height: 100), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ),
              _buildPaymentButton(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {

       final response = await  authController.getUser();
        print(response);

        print(widget.restaurantSpecialInstructions);
      }),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3498DB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF3498DB), size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [




          _buildTextField(
            controller: nameControler,
            label: "voornaam",
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),


          const SizedBox(height: 16),

          _buildTextField(
            controller: phoneController,
            label: "Phone Number",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: emailController,
            label: "Email ",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!value.contains('@')) {
                return 'Vul een geldige email in';
              }
              return null;
            },
          )
,        ],
      ),
    );
  }

  Widget _buildPickupSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: notesController,
            label: "Special Instructions (Optional)",
            icon: Icons.note_outlined,
            maxLines: 3,
          ),
     
        ],
      ),
    );
  }

  Widget _buildRestaurantDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
   

 widget.restaurantSpecialInstructions    != null  ?



  TextFormField(
      maxLines: 4,
      enabled: false,
      decoration: InputDecoration(
        labelText: widget.restaurantSpecialInstructions,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    )
          :
          //TODO Fix the sizedbox comes after the textfield here above
          const SizedBox(height: 16) ,
    
  
      
  
  


          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF3498DB),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pickup Location:",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Text(
                        "123 Main Street, Downtown\nOpen until 10:00 PM",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF3498DB)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ...widget.cartItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3498DB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        item['image'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item['name']} x${item['quantity']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        if (item['options'].isNotEmpty)
                          Text(
                            item['options']
                                .map((opt) => opt['name'])
                                .join(', '),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    "\$${calculateItemTotal(item).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF27AE60),
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 24, thickness: 1),
          _buildSummaryRow("Subtotal", widget.subtotal, false),
          _buildSummaryRow("Tax (10%)", widget.tax, false),
          const Divider(height: 16, thickness: 1),
          _buildSummaryRow("Total", widget.totalAmount, true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, double amount, bool isBold) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: isBold ? const Color(0xFF27AE60) : const Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF27AE60).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _isLoading ? null : _proceedToPayment,
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Pay \$${widget.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
