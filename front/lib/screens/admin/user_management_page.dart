import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  List<UserModel> users = [];

  Future<void> fetchUsers() async {
    users = await UserService.getUsers();
    setState(() {});
  }

  Future<void> addOrUpdateUser({String? userId}) async {
    final username = usernameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    if (userId == null) {
      await UserService.addUser(username: username, email: email, password: password);
    } else {
      await UserService.updateUser(userId, username: username, email: email);
    }

    Navigator.pop(context);
    fetchUsers();
  }

  Future<void> deleteUser(String userId) async {
    try {
      await UserService.deleteUser(userId);
      fetchUsers();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete user')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'User Management',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                user.username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.teal),
                    onPressed: () {
                      usernameController.text = user.username;
                      emailController.text = user.email;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Edit User'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: usernameController,
                                decoration: InputDecoration(labelText: 'Username'),
                              ),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(labelText: 'Email'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => addOrUpdateUser(userId: user.id),
                              child: Text('Save'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(user.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add New User'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => addOrUpdateUser(),
                  child: Text('Save'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Manage Books'),
              onTap: () {
                Navigator.pushNamed(context, '/admin/books');
              },
            ),
            ListTile(
              title: const Text('Borrowal Management'),
              onTap: () {
                Navigator.pushNamed(context, '/admin/borrowed');
              },
            ),
            ListTile(
              title: const Text('User Management'),
              onTap: () {
                Navigator.pushNamed(context, '/admin/users');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
