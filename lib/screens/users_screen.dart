import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/database_helper.dart';
import '../widgets/user_card.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<dynamic> users = [];
  Set<int> savedUsers = {}; // To track saved users

  @override
  void initState() {
    super.initState();
    fetchUsers();        // Fetch users from the network
    fetchSavedUsers();   // Fetch saved users from the database
  }

  // Fetch users from the network
  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Fetch saved users from the local database
  Future<void> fetchSavedUsers() async {
    final dbUsers = await DatabaseHelper.instance.getUsers();
    setState(() {
      savedUsers = dbUsers.map((user) => user['id'] as int).toSet(); // Get ids of saved users
    });
  }

  // Toggle save/un-save user
  void toggleSave(int userId, String userName) async {
    setState(() {
      if (savedUsers.contains(userId)) {
        savedUsers.remove(userId);
        DatabaseHelper.instance.removeUser(userId);
      } else {
        savedUsers.add(userId);
        DatabaseHelper.instance.saveUser(userId, userName);
      }
    });
    // Fetch the updated list of saved users from the database
    await fetchSavedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users List')),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return UserCard(
            user: user,
            isSaved: savedUsers.contains(user['id']),
            onToggleSave: () => toggleSave(user['id'], user['name']),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: fetchUsers,
                child: Text('Network'),
              ),
              ElevatedButton(
                onPressed: fetchSavedUsers,
                child: Text('Local'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
