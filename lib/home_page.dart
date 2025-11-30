import 'package:flutter/material.dart';
import 'login_page.dart';
import 'session_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    String? username = await SessionManager.getUsername();
    setState(() {
      _username = username;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    await SessionManager.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _showProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profil'),
        content: Text('Username: ${_username ?? "(tidak tersedia)"}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Center(
                  child: Text(
                    'Welcome to the Home Page!',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profil'),
                  subtitle: Text(_username ?? '(tidak tersedia)'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showProfile,
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Keluar'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _logout,
                ),
              ],
            ),
    );
  }
}