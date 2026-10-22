import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

Future<void> showNotification(String title, String body) async {
  const details = NotificationDetails(
    android: AndroidNotificationDetails('channel_id', 'Notification Channel', importance: Importance.high, priority: Priority.high),
  );
  await notifications.show(id: 0, title: title, body: body, notificationDetails: details);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    const init = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    await notifications.initialize(settings: init);
    await notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  } catch (_) {}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final username = prefs.getString('user') ?? 'User';

    if (!mounted) return;
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lab 10: Final Integrated Project', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');
  bool _loading = false;
  String _error = '';

  Future<void> _loginApi() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'] ?? data['accessToken'];
        final username = data['username'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', username);

        showNotification('Đăng nhập thành công', 'Xin chào $username!');

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
          );
        }
      } else {
        setState(() => _error = data['message'] ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      setState(() => _error = 'Lỗi kết nối: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginGoogle() async {
    try {
      final account = await GoogleSignIn(scopes: ['email']).signIn();
      if (account != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', account.id);
        await prefs.setString('user', account.displayName ?? account.email);

        showNotification('Đăng nhập thành công', 'Chào mừng qua Google!');

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen(username: account.displayName ?? 'Google User')),
          );
        }
      }
    } catch (e) {
      setState(() => _error = 'Google Sign-in cần SHA-1 trên Firebase.\nLỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10: Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(_error, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _loginApi,
                    child: const Text('Đăng nhập API (DummyJSON)'),
                  ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _loginGoogle,
              child: const Text('Đăng nhập bằng Google'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang chủ (Lab 10 Full)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Xin chào, $username!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => showNotification('Thông báo', 'Bạn vừa bấm nút gửi thông báo.'),
              child: const Text('Bấm để thử gửi thông báo'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
