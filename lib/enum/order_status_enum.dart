
// TODO think of better naming
// This is for the intial restaurant review to first look into a
enum OrderStatus {
  pending, 
    kitchen, 
    ready, 
    completed,
  declined,
  accepted;





    factory OrderStatus.fromJson(dynamic json) {
    if (json == null) return OrderStatus.pending; // default value
    
    final String value = json.toString().toLowerCase();
    
    switch (value) {
      case 'pending':

      return OrderStatus.pending;
      case 'accepted':
        return OrderStatus.accepted;
      case 'declined':
        return OrderStatus.declined;
      case 'kitchen':
        return OrderStatus.kitchen;
      case 'ready':

  return OrderStatus.ready;
      case 'completed':
      return OrderStatus.completed;

      default:
        return OrderStatus.pending; // fallback
    }
  }
String toJson() {
    switch (this) {
      case OrderStatus.pending:
      return 'Pending';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.declined:
        return 'declined';
      case OrderStatus.accepted:
        return 'accepted';
      case OrderStatus.kitchen:
        return 'kitchen';
        case OrderStatus.ready:
        return 'ready';
    }



}
}