import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserTile extends StatelessWidget {
  final String username;
  final String name;

  UserTile({required this.username, required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(username),
      subtitle: Text(name),
      // Handle onTap event for each user
      onTap: () {
        // Perform an action when a user is selected
        // For example, navigate to chat screen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ChatScreen(user)),
        // );
      },
    );
  }
}

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final firestoreInstance = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _allUsers = []; // Specify the type explicitly here

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  void fetchAllUsers() {
    firestoreInstance.collection('Users').get().then((QuerySnapshot querySnapshot) {
      setState(() {
        _allUsers = querySnapshot.docs.map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>).toList();
        _searchResults = _allUsers;
      });
    }).catchError((error) {
      // Handle the error
      print('Error: $error');
    });
  }

  void searchUsers(String query) {
    setState(() {
      _searchResults = _allUsers
          .where((user) => user['Username'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                searchUsers(value.trim());
              },
              decoration: InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                var user = _searchResults[index];
                return UserTile(
                  username: user['Username'],
                  name: user['Email'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(ChatApp());
}
