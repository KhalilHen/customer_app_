

import 'package:hf_customer_app/main.dart';

class AnalyticsService {


  static Future<void> logEvent(
    String eventType, {
    String? page,
    String? userId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await supabase.from('app_logs').insert({
        'event_type': eventType,
        'page': page,
        'user_id': userId,
        'metadata': metadata,
      });
    } catch (e) {
      // Silent fail
    }
  }



  
}


