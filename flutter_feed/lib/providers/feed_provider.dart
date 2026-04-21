
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

final feedProvider = StateNotifierProvider<FeedNotifier, List<Post>>((ref) {
  return FeedNotifier();
});

class FeedNotifier extends StateNotifier<List<Post>> {
  FeedNotifier() : super([]);

  int page = 0;
  final supabase = Supabase.instance.client;
  Timer? debounceTimer;

  Future<void> fetchPosts() async {
    final data = await supabase
        .from('posts')
        .select()
        .range(page * 10, (page + 1) * 10 - 1);

    final posts = (data as List)
        .map((e) => Post.fromJson(e))
        .toList();

    state = [...state, ...posts];
    page++;
  }

  void toggleLike(Post post) {
    final index = state.indexWhere((p) => p.id == post.id);

    post.isLiked = !post.isLiked;
    post.likeCount += post.isLiked ? 1 : -1;
    state = [...state];

    debounceTimer?.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      try {
        await supabase.rpc('toggle_like', params: {
          'p_post_id': post.id,
          'p_user_id': 'user_123'
        });
      } catch (e) {
        post.isLiked = !post.isLiked;
        post.likeCount += post.isLiked ? 1 : -1;
        state = [...state];
      }
    });
  }
}
