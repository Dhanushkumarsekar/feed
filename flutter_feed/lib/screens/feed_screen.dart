import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feed_provider.dart';
import '../widgets/post_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final scrollController = ScrollController();
  bool isFetching = false;

  @override
  void initState() {
    super.initState();

    // 🔥 LOAD DATA ONLY ONCE
    Future.microtask(() {
      ref.read(feedProvider.notifier).fetchPosts();
    });

    // 🔥 INFINITE SCROLL FIX
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isFetching) {
        isFetching = true;
        ref.read(feedProvider.notifier).fetchPosts().then((_) {
          isFetching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(feedProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("🔥 Social Feed"),
        centerTitle: true,
      ),
      body: posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                ref.read(feedProvider.notifier).state = [];
                ref.read(feedProvider.notifier).page = 0;
                await ref.read(feedProvider.notifier).fetchPosts();
              },
              child: ListView.builder(
                controller: scrollController,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: posts[index]);
                },
              ),
            ),
    );
  }
}