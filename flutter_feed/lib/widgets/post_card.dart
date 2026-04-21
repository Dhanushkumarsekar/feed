import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers/feed_provider.dart';
import '../screens/detail_screen.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(post: post),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                Hero(
                  tag: post.id,
                  child: Image.network(
                    post.thumb,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheWidth: 300,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref.read(feedProvider.notifier).toggleLike(post);
                            },
                            child: Icon(
                              Icons.favorite,
                              color: post.isLiked ? Colors.red : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            post.likeCount.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Icon(Icons.more_vert)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}