import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GoogleSignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? _currentUser;
  String _error = '';

  Future<void> _loginGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      setState(() => _currentUser = account);
    } catch (e) {
      setState(() => _error = 'Lưu ý: Google Sign-In cần cấu hình SHA-1 trên Firebase.\nLỗi: $e');
    }
  }

  Future<void> _logoutGoogle() async {
    await _googleSignIn.signOut();
    setState(() => _currentUser = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.4: Google Sign-In')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _currentUser == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _loginGoogle,
                      child: const Text('Đăng nhập bằng Google'),
                    ),
                    if (_error.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(_error, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                    ],
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentUser!.photoUrl != null)
                      CircleAvatar(radius: 40, backgroundImage: NetworkImage(_currentUser!.photoUrl!)),
                    const SizedBox(height: 12),
                    Text(_currentUser!.displayName ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(_currentUser!.email),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _logoutGoogle,
                      child: const Text('Đăng xuất'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
