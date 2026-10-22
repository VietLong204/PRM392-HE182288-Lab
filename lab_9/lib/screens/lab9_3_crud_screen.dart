import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/storage_service.dart';

class Lab93CrudScreen extends StatefulWidget {
  const Lab93CrudScreen({super.key});

  @override
  State<Lab93CrudScreen> createState() => _Lab93CrudScreenState();
}

class _Lab93CrudScreenState extends State<Lab93CrudScreen> {
  List<Student> _students = [];
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final jsonString = await StorageService.read('students.json');
    if (jsonString.isNotEmpty) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      setState(() {
        _students = jsonList.map((item) => Student.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveStudents() async {
    final jsonString = jsonEncode(_students.map((e) => e.toJson()).toList());
    await StorageService.write('students.json', jsonString);
  }

  void _showStudentDialog({Student? student}) {
    final nameCtrl = TextEditingController(text: student?.name ?? '');
    final majorCtrl = TextEditingController(text: student?.major ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(student == null ? 'Thêm sinh viên' : 'Sửa sinh viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Họ tên'),
            ),
            TextField(
              controller: majorCtrl,
              decoration: const InputDecoration(labelText: 'Ngành học'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;

              setState(() {
                if (student == null) {
                  final newId = _students.isEmpty ? 1 : _students.last.id + 1;
                  _students.add(Student(
                    id: newId,
                    name: nameCtrl.text.trim(),
                    major: majorCtrl.text.trim(),
                  ));
                } else {
                  student.name = nameCtrl.text.trim();
                  student.major = majorCtrl.text.trim();
                }
              });

              _saveStudents();
              Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _deleteStudent(Student student) {
    setState(() {
      _students.remove(student);
    });
    _saveStudents();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _students.where((s) {
      return s.name.toLowerCase().contains(_keyword.toLowerCase()) ||
          s.major.toLowerCase().contains(_keyword.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.3: JSON CRUD DB')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStudentDialog(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm theo tên hoặc ngành...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _keyword = val),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('Không tìm thấy sinh viên nào'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final student = filtered[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${student.id}')),
                            title: Text(student.name),
                            subtitle: Text('Ngành: ${student.major}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showStudentDialog(student: student),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteStudent(student),
                                ),
                              ],
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
