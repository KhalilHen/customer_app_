import 'package:decimal/decimal.dart';
import 'package:hf_customer_app/enum/order_status_enum.dart';

class Order {
  final String id; //TODO Mabye UUID find out
  final String customerId;
  final String restaurantId;
    final OrderStatus orderStatus;

// Enum status here
// Enum type here
final DateTime? pickUpTime;
final String customerNotes;
final Decimal subTotal;
final Decimal taxAmount; //TODO Figure out if there's a seperate table needed for tax percentage like 9% as that is used for food. And if this is pure to display the amount that is paid in taxes
final Decimal serviceFee;
final  Decimal? discountAmount ;
final Decimal totalAmount;
final String stripePaymentId;
final String paymentStatus;

  Order({
    required this.id,
    required this.customerId, 
    required this.restaurantId,
    required this.orderStatus,
    this.pickUpTime,
    required this.customerNotes,
    required this.subTotal,
    required this.taxAmount,
    required this.serviceFee,
    this.discountAmount,
    required this.totalAmount,
    required this.stripePaymentId,
    required this.paymentStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
        customerId: json['customerId'] as String? ?? json['customer_id'],
      restaurantId: json['restaurant_id'] as String,
      orderStatus: OrderStatus.fromJson(json['order_status']),
    //   pickUpTime: ,
    customerNotes: json['customerNotes'] as String? ?? json['customer_notes'] as String,
    subTotal:  Decimal.parse(json['sub_total']),
    taxAmount: Decimal.parse(json['tax_amount']),
    serviceFee: Decimal.parse(json['service_fee']),
    discountAmount: Decimal.parse(json['discount_amount']),
    totalAmount: Decimal.parse(json['total_amount']),
    stripePaymentId: json['stripePaymentId'] as String? ?? json['stripe_payment_id'],
    paymentStatus: json['paymentStatus'] as String? ?? json['payment_status'],
    
  
    );
  }
}