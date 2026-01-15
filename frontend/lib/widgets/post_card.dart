import 'package:flutter/material.dart';
import 'comment_modal.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Map post;
  final VoidCallback onLike;
  final Function(String author, String text) onCommentAdded;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onCommentAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Author + Timestamp =====
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.teal.shade100,
                  child: Text(
                    post['author'][0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    post['author'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  timeago.format(DateTime.parse(post['createdAt'])),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ===== Post Content =====
            Text(post['content'], style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 12),

            // ===== Like + Comment Row =====
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.redAccent),
                  onPressed: onLike,
                ),
                Text('${post['likes']}'),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) =>
                          CommentModal(onCommentAdded: onCommentAdded),
                    );
                  },
                  icon: const Icon(Icons.comment, color: Colors.blueAccent),
                  label: const Text('Comment'),
                ),
              ],
            ),

            // ===== Recent Comments =====
            if (post['comments'] != null && post['comments'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: post['comments']
                    .map<Widget>(
                      (c) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 4,
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${c['author']}: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: c['text'],
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
