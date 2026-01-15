import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/post_card.dart';
import 'package:timeago/timeago.dart' as timeago;

enum PostSort { newest, mostLiked }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List posts = [];
  bool isLoading = true;
  TextEditingController authorController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  PostSort currentSort = PostSort.newest;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  /// Fetch posts from backend
  void fetchPosts() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getPosts();
      setState(() => posts = data);
      applySorting();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Apply current sorting filter
  void applySorting() {
    setState(() {
      if (currentSort == PostSort.mostLiked) {
        posts.sort((a, b) => (b['likes'] ?? 0).compareTo(a['likes'] ?? 0));
      } else {
        posts.sort(
          (a, b) => DateTime.parse(
            b['createdAt'],
          ).compareTo(DateTime.parse(a['createdAt'])),
        );
      }
    });
  }

  /// Create a new post
  void createPost() async {
    if (authorController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and content cannot be empty")),
      );
      return;
    }
    try {
      final newPost = await ApiService.createPost(
        authorController.text,
        contentController.text,
      );
      posts.insert(0, newPost);
      applySorting();
      authorController.clear();
      contentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// Change sorting filter
  void changeSort(PostSort sort) {
    if (currentSort != sort) {
      setState(() => currentSort = sort);
      applySorting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parenting Community Wall'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Post Composer Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Write something...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: createPost,
                    icon: const Icon(Icons.send),
                    label: const Text('Post'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sort Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                const Text(
                  'Sort by:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Newest'),
                  selected: currentSort == PostSort.newest,
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: currentSort == PostSort.newest
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (selected) => changeSort(PostSort.newest),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Most Liked'),
                  selected: currentSort == PostSort.mostLiked,
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: currentSort == PostSort.mostLiked
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (selected) => changeSort(PostSort.mostLiked),
                ),
              ],
            ),
          ),

          // Posts Feed Section
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async => fetchPosts(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: posts.length,
                      itemBuilder: (context, index) => PostCard(
                        post: posts[index],
                        onLike: () async {
                          final updated = await ApiService.likePost(
                            posts[index]['_id'],
                          );
                          posts[index] = updated;
                          applySorting(); // keep sorted after like
                        },
                        onCommentAdded: (author, text) async {
                          final updated = await ApiService.addComment(
                            posts[index]['_id'],
                            author,
                            text,
                          );
                          posts[index] = updated;
                          applySorting();
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
