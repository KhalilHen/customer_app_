//TODO mabye use it in the future currently it is not usefull for auth to unit test it
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
// import 'package:supabase/supabase.dart';

// void main() {
//   late final SupabaseClient mockSupabase;
//   late final MockSupabaseHttpClient mockHttpClient;

//   // late final SupabaseClient

//   // final mockSupabase = SupabaseClient(
//   //   'https://mock.supabase.co',
//   //   'fakeAnonKey',

//   //   httpClient: MockSupabaseHttpClient(),
//   // );

//   setUpAll(() {
//     mockHttpClient = MockSupabaseHttpClient();

//     // Pass the mock client to the Supabase client
//     mockSupabase = SupabaseClient(
//       'https://mock.supabase.co', // Does not matter what URL you pass here as long as it's a valid URL
//       'fakeAnonKey', // Does not matter what string you pass here
//       httpClient: MockSupabaseHttpClient(),
//     );
//   });

//   tearDown(() async {
//     // Reset the mock data after each test
//     mockHttpClient.reset();
//   });

//   tearDownAll(() {
//     // Close the mock client after all tests
//     mockHttpClient.close();
//   });

//   test('Attempted login', () async {
//     await mockSupabase.from('account').insert([
//       {
//         'id': 1,
//         'email': 'test@hotmail.com',

//         // 'user_id': 'cb096f24-00be-4686-b46f-1af88d2746ae'
//       },
//     ]);

//     final posts = await mockSupabase.from('account').select();
//     final selectField = await mockSupabase.from('account').select('email');
//     final selectId = await mockSupabase.from('account').select('id');

//     expect(posts.length, 1);
//     expect(selectId.first, {'id': 1});

//     expect(selectField.first, {'email': "test@hotmail.com"});
//     // expect(selectField[1], {'email': "2@hotmail.com"});

//     //This selects the first record only the email
//   });
// }
