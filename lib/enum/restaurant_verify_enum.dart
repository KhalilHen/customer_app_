
// TODO think of better naming
// This is for the intial restaurant review to first look into a
enum RestaurantVerification {

  verified, 
  // rejected,
  // inprogress, 
  declined,
  approved,
  reReview;





    factory RestaurantVerification.fromJson(dynamic json) {
    if (json == null) return RestaurantVerification.declined; 
    
    final String value = json.toString().toLowerCase();
    
    switch (value) {
      case 'verified':
        return RestaurantVerification.verified;
      case 'declined':
        return RestaurantVerification.declined;
      case 'approved':
        return RestaurantVerification.approved;
      case 're-review':
      case 'reReview':
      case 're_review':
        return RestaurantVerification.reReview;
      default:
        return RestaurantVerification.declined; // fallback
    }
  }
String toJson() {
    switch (this) {
      case RestaurantVerification.verified:
        return 'verified';
      case RestaurantVerification.declined:
        return 'declined';
      case RestaurantVerification.approved:
        return 'approved';
      case RestaurantVerification.reReview:
        return 're-review';
    }



}
}