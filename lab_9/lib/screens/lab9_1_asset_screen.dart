import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/book.dart';

class Lab91AssetScreen extends StatefulWidget {
  const Lab91AssetScreen({super.key});

  @override
  State<Lab91AssetScreen> createState() => _Lab91AssetScreenState();
}

class _Lab91AssetScreenState extends State<Lab91AssetScreen> {
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final jsonString = await rootBundle.loadString('assets/data/books.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    setState(() {
      _books = jsonList.map((item) => Book.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.1: Read JSON Assets')),
      body: _books.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${book.id}')),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  trailing: Text(book.category),
                );
              },
            ),
    );
  }
}
