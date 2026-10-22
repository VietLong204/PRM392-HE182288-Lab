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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooksFromAssets();
  }

  Future<void> _loadBooksFromAssets() async {
    setState(() => _isLoading = true);

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/books.json');

      final List<dynamic> jsonList = jsonDecode(jsonString);

      setState(() {
        _books = jsonList.map((item) => Book.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.1: Read JSON Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBooksFromAssets,
            tooltip: 'Tải lại',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _books.isEmpty
              ? const Center(child: Text('Không có dữ liệu trong file asset.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text('${book.id}',
                              style: TextStyle(color: Colors.blue.shade800)),
                        ),
                        title: Text(
                          book.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Tác giả: ${book.author}'),
                        trailing: Chip(
                          label: Text(
                            book.category,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.blue.shade50,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
