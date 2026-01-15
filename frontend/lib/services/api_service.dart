import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5050/api/posts';

  // GET all posts
  static Future<List<dynamic>> getPosts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // POST create new post
  static Future<Map<String, dynamic>> createPost(
    String author,
    String content,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'author': author, 'content': content}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to create post');
    }
  }

  // POST like a post
  static Future<Map<String, dynamic>> likePost(String postId) async {
    final response = await http.post(Uri.parse('$baseUrl/$postId/like'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to like post');
    }
  }

  // POST add comment
  static Future<Map<String, dynamic>> addComment(
    String postId,
    String author,
    String text,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$postId/comments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'author': author, 'text': text}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to add comment');
    }
  }
}
