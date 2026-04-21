import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List> fetchPosts() async {
  final response = await supabase
      .from('posts')
      .select();

  return response;
}