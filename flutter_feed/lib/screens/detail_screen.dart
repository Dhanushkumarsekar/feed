import 'package:flutter/material.dart';
import '../models/post.dart';

class DetailScreen extends StatefulWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    // 🔥 LOAD IMAGE ONCE
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => loaded = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Column(
        children: [
          Hero(
            tag: widget.post.id,
            child: Stack(
              children: [
                Image.network(widget.post.thumb),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: loaded ? 1 : 0,
                  child: Image.network(widget.post.mobile),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text("Download High Quality"),
          )
        ],
      ),
    );
  }
}