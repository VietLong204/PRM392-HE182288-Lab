// LAB 2 - DART ESSENTIALS PRACTICE LAB

import 'dart:async';
import 'Car.dart';

// ============================================
// MAIN
// ============================================

void main() async {
  print('----- Exercise 1: Basic Syntax -----');
  exercise1();

  print('');
  print('----- Exercise 2: Collections -----');
  exercise2();

  print('');
  print('----- Exercise 3: Control Flow -----');
  exercise3();

  print('');
  print('----- Exercise 4: OOP -----');
  exercise4();

  print('');
  print('----- Exercise 5: Async -----');
  await exercise5();
}

// ============================================
// Exercise 1: Basic Syntax & Data Types
// ============================================
void exercise1() {
  int age = 20;
  double height = 1.7;
  String name = 'Minh';
  bool isStudent = true;

  print('Name: $name');
  print('Age: $age');
  print('Height: $height');
  print('Is student: $isStudent');
}

// ============================================
// Exercise 2: Collections & Operators
// ============================================
void exercise2() {
  // List
  List<int> numbers = [1, 2, 3, 4, 5];
  print('List: $numbers');

  int sum = numbers[0] + numbers[1];
  print('Sum of first two: $sum');

  numbers.add(6);
  numbers.remove(1);
  print('After add and remove: $numbers');

  // Set (tự động loại bỏ phần tử trùng lặp)
  Set<String> fruits = Set.from(['apple', 'banana', 'apple']);
  print('Set: $fruits');

  // Map
  Map<String, int> scores = {'Minh': 8, 'Lan': 9};
  print('Map: $scores');
  print('Lan score: ${scores['Lan']}');

  // Operator ba ngôi
  String result = (sum > 2) ? 'Big' : 'Small';
  print('Ternary result: $result');
}

// ============================================
// Exercise 3: Control Flow & Functions
// ============================================

// Hàm bình thường
String checkScore(int score) {
  if (score >= 8) {
    return 'Good';
  } else if (score >= 5) {
    return 'Average';
  } else {
    return 'Fail';
  }
}

// Hàm arrow
int square(int x) => x * x;

void exercise3() {
  int score = 7;
  print('Score result: ${checkScore(score)}');

  int day = 2;
  switch (day) {
    case 1:
      print('Monday');
      break;
    case 2:
      print('Tuesday');
      break;
    default:
      print('Other day');
  }

  List<int> list = [1, 2, 3];

  for (int i = 0; i < list.length; i++) {
    print('for loop: ${list[i]}');
  }

  for (int item in list) {
    print('for-in loop: $item');
  }

  list.forEach((item) {
    print('forEach: $item, square = ${square(item)}');
  });
}

// ============================================
// Exercise 4: OOP
// ============================================
void exercise4() {
  Car car1 = Car('Toyota');
  car1.drive();

  Car car2 = Car.unknownBrand();
  car2.drive();

  ElectricCar car3 = ElectricCar('Tesla', 75);
  car3.drive();
}

// ============================================
// Exercise 5: Async, Null Safety, Stream
// ============================================

Future<String> loadData() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Data loaded';
}

Stream<int> countStream() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(Duration(milliseconds: 300));
    yield i;
  }
}

Future<void> exercise5() async {
  String data = await loadData();
  print(data);

  String? name;
  String displayName = name ?? 'Guest';
  print('Display name: $displayName');

  name = 'Mimi';
  print('Name length: ${name.length}');

  await for (int number in countStream()) {
    print('Stream value: $number');
  }
}