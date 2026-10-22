import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/storage_service.dart';

class Lab92StorageScreen extends StatefulWidget {
  const Lab92StorageScreen({super.key});

  @override
  State<Lab92StorageScreen> createState() => _Lab92StorageScreenState();
}

class _Lab92StorageScreenState extends State<Lab92StorageScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final jsonString = await StorageService.read('notes.json');
    if (jsonString.isNotEmpty) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      setState(() {
        _notes = jsonList.map((item) => Note.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final jsonString = jsonEncode(_notes.map((e) => e.toJson()).toList());
    await StorageService.write('notes.json', jsonString);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu dữ liệu vào bộ nhớ máy!')),
      );
    }
  }

  void _addNote() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _notes.add(Note(title: text));
      _controller.clear();
    });
    _saveNotes();
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2: Local Storage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNotes,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập ghi chú...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addNote,
                  child: const Text('Thêm'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _notes.isEmpty
                  ? const Center(child: Text('Chưa có ghi chú nào'))
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_notes[index].title),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteNote(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
