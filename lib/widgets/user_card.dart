import 'package:flutter/material.dart';
import '../screens/posts_screen.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final bool isSaved;
  final VoidCallback onToggleSave;

  UserCard({
    required this.user,
    required this.isSaved,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user['name']),
        trailing: IconButton(
          icon: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: isSaved ? Colors.green : Colors.grey,
          ),
          onPressed: onToggleSave,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostsScreen(userId: user['id']),
            ),
          );
        },
      ),
    );
  }
}
