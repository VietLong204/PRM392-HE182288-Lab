import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.4 - Google Sign In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const GoogleSignInScreen(),
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
  bool _isLoading = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final account = await _googleSignIn.signIn();
      setState(() {
        _currentUser = account;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Lưu ý: Để đăng nhập Google trên máy thật/máy ảo, cần cấu hình SHA-1 trên Firebase Console.\nChi tiết lỗi: $e';
      });
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    setState(() {
      _currentUser = null;
      _statusMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.4: Google Sign-In')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _currentUser != null ? _buildProfileView() : _buildSignInView(),
        ),
      ),
    );
  }

  Widget _buildSignInView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.account_circle, size: 80, color: Colors.blue),
        const SizedBox(height: 20),
        const Text(
          'Đăng nhập với Google',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Tích hợp Firebase Authentication & Google Sign-In',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        if (_isLoading)
          const CircularProgressIndicator()
        else
          ElevatedButton.icon(
            onPressed: _handleSignIn,
            icon: const Icon(Icons.login),
            label: const Text('Đăng nhập bằng tài khoản Google'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
        if (_statusMessage != null) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Text(
              _statusMessage!,
              style: TextStyle(fontSize: 13, color: Colors.amber.shade900),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProfileView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_currentUser!.photoUrl != null)
          CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(_currentUser!.photoUrl!),
          )
        else
          const CircleAvatar(
            radius: 45,
            child: Icon(Icons.person, size: 45),
          ),
        const SizedBox(height: 16),
        Text(
          _currentUser!.displayName ?? 'Người dùng Google',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          _currentUser!.email,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: _handleSignOut,
          icon: const Icon(Icons.logout),
          label: const Text('Đăng xuất Google'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
