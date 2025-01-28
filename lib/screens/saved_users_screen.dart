import 'package:flutter/material.dart';
import 'package:network_database_app/screens/posts_screen.dart';
import '../database/database_helper.dart';

class SavedUsersScreen extends StatefulWidget {
  @override
  _SavedUsersScreenState createState() => _SavedUsersScreenState();
}

class _SavedUsersScreenState extends State<SavedUsersScreen> {
  List<Map<String, dynamic>> savedUsers = [];

  @override
  void initState() {
    super.initState();
    fetchSavedUsers();
  }

  Future<void> fetchSavedUsers() async {
    final dbUsers = await DatabaseHelper.instance.getUsers();
    setState(() {
      savedUsers = dbUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Users')),
      body: savedUsers.isEmpty
          ? Center(child: Text('No saved users'))
          : ListView.builder(
        itemCount: savedUsers.length,
        itemBuilder: (context, index) {
          final user = savedUsers[index];
          return ListTile(
            title: Text(user['name']),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostsScreen(userId: user['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
