import 'dart:async';
import 'dart:convert';

// =========================================================================
// EXERCISE 1 – Product Model & Repository (Future + Stream)
// =========================================================================

class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}

class ProductRepository {
  final List<Product> _products = [
    Product(id: 1, name: 'Keyboard', price: 25.0),
    Product(id: 2, name: 'Mouse', price: 15.0),
    Product(id: 3, name: 'Monitor', price: 120.0),
  ];

  final StreamController<Product> _liveController =
      StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products;
  }

  Stream<Product> liveAdded() => _liveController.stream;

  void addProduct(Product product) {
    _products.add(product);
    _liveController.add(product);
  }

  void dispose() => _liveController.close();
}

Future<void> exercise1() async {
  print('\n===== EXERCISE 1: Product Model & Repository =====');
  final repo = ProductRepository();

  final subscription = repo.liveAdded().listen((product) {
    print('[Stream] Sản phẩm mới vừa được thêm: $product');
  });

  final all = await repo.getAll();
  print('[Future] Danh sách sản phẩm ban đầu:');
  for (final p in all) {
    print('  - $p');
  }

  repo.addProduct(Product(id: 4, name: 'Webcam', price: 40.0));
  repo.addProduct(Product(id: 5, name: 'Headset', price: 30.0));

  await Future.delayed(const Duration(milliseconds: 100));
  await subscription.cancel();
  repo.dispose();
}

// =========================================================================
// EXERCISE 2 – User Repository with JSON
// =========================================================================

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  Future<List<User>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));

    const jsonString = '''
    [
      {"name": "Alice", "email": "alice@example.com"},
      {"name": "Bob", "email": "bob@example.com"},
      {"name": "Charlie", "email": "charlie@example.com"}
    ]
    ''';

    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;

    return decoded
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

Future<void> exercise2() async {
  print('\n===== EXERCISE 2: User Repository with JSON =====');
  final repo = UserRepository();
  final users = await repo.fetchUsers();

  print('Danh sách user parse được từ JSON:');
  for (final u in users) {
    print('  - $u');
  }
}

// =========================================================================
// EXERCISE 3 – Async + Microtask Debugging
// =========================================================================

Future<void> exercise3() async {
  print('\n===== EXERCISE 3: Async + Microtask Debugging =====');

  print('1) Bắt đầu hàm main (đồng bộ)');

  Future(() {
    print('4) Bên trong Future() -> chạy từ EVENT QUEUE');
  });

  scheduleMicrotask(() {
    print('3) Bên trong scheduleMicrotask -> chạy từ MICROTASK QUEUE');
  });

  print('2) Kết thúc phần code đồng bộ trong hàm main');

  await Future.delayed(const Duration(milliseconds: 50));
  print('5) (Đợi thêm) Xác nhận toàn bộ hàng đợi đã được xử lý xong');
}

// =========================================================================
// EXERCISE 4 – Stream Transformation (map + where)
// =========================================================================

Future<void> exercise4() async {
  print('\n===== EXERCISE 4: Stream Transformation =====');

  final numberStream = Stream<int>.fromIterable([1, 2, 3, 4, 5]);

  final transformedStream =
      numberStream.map((n) => n * n).where((squared) => squared % 2 == 0);

  print('Số gốc: 1, 2, 3, 4, 5');
  print('Sau map(bình phương) + where(chỉ giữ số chẵn):');

  await for (final value in transformedStream) {
    print('  -> $value');
  }
}

// =========================================================================
// EXERCISE 5 – Factory Constructors & Cache (Singleton)
// =========================================================================

class Settings {
  static Settings? _instance;

  String theme;
  bool notificationsEnabled;

  Settings._internal({this.theme = 'light', this.notificationsEnabled = true});

  factory Settings() {
    if (_instance == null) {
      print('  [Settings] Chưa có instance -> tạo mới singleton');
      _instance = Settings._internal();
    } else {
      print('  [Settings] Đã có instance -> trả về từ cache');
    }
    return _instance!;
  }
}

Future<void> exercise5() async {
  print('\n===== EXERCISE 5: Factory Constructors & Cache =====');

  final a = Settings();
  final b = Settings();

  a.theme = 'dark';

  print('a.theme = ${a.theme}');
  print('b.theme = ${b.theme} (phải giống a vì cùng 1 instance)');
  print('identical(a, b) => ${identical(a, b)}');
}

// =========================================================================
// MAIN – chạy tuần tự cả 5 bài tập
// =========================================================================

Future<void> main() async {
  print('=== LAB 3 – ADVANCED DART PRACTICE EXERCISES ===');

  await exercise1();
  await exercise2();
  await exercise3();
  await exercise4();
  await exercise5();
}