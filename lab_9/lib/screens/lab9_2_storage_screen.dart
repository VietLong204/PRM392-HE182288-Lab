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
  static const String _fileName = 'notes.json';
  final TextEditingController _noteController = TextEditingController();
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotesFromStorage();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadNotesFromStorage() async {
    setState(() => _isLoading = true);

    final jsonString = await StorageService.readJson(_fileName);

    if (jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        setState(() {
          _notes = jsonList.map((item) => Note.fromJson(item)).toList();
          _isLoading = false;
        });
        return;
      } catch (_) {}
    }

    setState(() {
      _notes = [
        Note(title: 'Học bài Lab 9 PRM', date: 'Hôm nay'),
        Note(title: 'Ôn tập JSON Storage', date: 'Tuần này'),
      ];
      _isLoading = false;
    });
    _saveNotesToStorage(showMessage: false);
  }

  Future<void> _saveNotesToStorage({bool showMessage = true}) async {
    final List<Map<String, dynamic>> jsonList =
        _notes.map((note) => note.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    await StorageService.writeJson(_fileName, jsonString);

    if (showMessage && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu dữ liệu vào bộ nhớ máy thành công!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final dateStr = '${now.hour}:${now.minute.toString().padLeft(2, '0')} - ${now.day}/${now.month}';

    setState(() {
      _notes.insert(0, Note(title: text, date: dateStr));
      _noteController.clear();
    });

    _saveNotesToStorage();
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotesToStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2: Local Storage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Lưu thủ công',
            onPressed: () => _saveNotesToStorage(showMessage: true),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteController,
                          decoration: const InputDecoration(
                            hintText: 'Nhập nội dung ghi chú...',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onSubmitted: (_) => _addNote(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _addNote,
                        icon: const Icon(Icons.add),
                        label: const Text('Thêm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _notes.isEmpty
                        ? const Center(child: Text('Chưa có ghi chú nào.'))
                        : ListView.builder(
                            itemCount: _notes.length,
                            itemBuilder: (context, index) {
                              final note = _notes[index];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: const Icon(Icons.note_alt_outlined,
                                      color: Colors.blue),
                                  title: Text(note.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  subtitle: Text(note.date),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red),
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
