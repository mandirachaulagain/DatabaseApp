
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostsScreen extends StatefulWidget {
  final int userId;

  PostsScreen({required this.userId});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=${widget.userId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        posts = data.map((post) => {
          'id': post['id'],
          'title': post['title'],
          'body': post['body'],
        }).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(post['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(post['body']),
            ),
          );
        },
      ),
    );
  }
}
