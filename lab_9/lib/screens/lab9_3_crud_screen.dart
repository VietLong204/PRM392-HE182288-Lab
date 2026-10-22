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
  static const String _fileName = 'students.json';
  final TextEditingController _searchController = TextEditingController();

  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentsFromStorage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudentsFromStorage() async {
    setState(() => _isLoading = true);

    final jsonString = await StorageService.readJson(_fileName);

    if (jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        setState(() {
          _allStudents =
              jsonList.map((item) => Student.fromJson(item)).toList();
          _filterStudents(_searchController.text);
          _isLoading = false;
        });
        return;
      } catch (_) {}
    }

    setState(() {
      _allStudents = [
        Student(id: 1, name: 'Nguyen Van A', email: 'a@fpt.edu.vn', major: 'SE'),
        Student(id: 2, name: 'Tran Thi B', email: 'b@fpt.edu.vn', major: 'AI'),
        Student(id: 3, name: 'Le Van C', email: 'c@fpt.edu.vn', major: 'IA'),
      ];
      _filterStudents('');
      _isLoading = false;
    });
    _saveStudentsToStorage(showMessage: false);
  }

  Future<void> _saveStudentsToStorage({bool showMessage = true, String? message}) async {
    final List<Map<String, dynamic>> jsonList =
        _allStudents.map((s) => s.toJson()).toList();
    await StorageService.writeJson(_fileName, jsonEncode(jsonList));

    if (showMessage && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message ?? 'Đã lưu thay đổi vào cơ sở dữ liệu!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _filterStudents(String keyword) {
    final query = keyword.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_allStudents);
      } else {
        _filteredStudents = _allStudents.where((student) {
          return student.name.toLowerCase().contains(query) ||
              student.email.toLowerCase().contains(query) ||
              student.major.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _showAddStudentDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final majorCtrl = TextEditingController(text: 'SE');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm sinh viên mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: majorCtrl,
                decoration: const InputDecoration(labelText: 'Chuyên ngành (SE/AI/IA)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;

              final newId = _allStudents.isEmpty
                  ? 1
                  : _allStudents.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1;

              final newStudent = Student(
                id: newId,
                name: nameCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                major: majorCtrl.text.trim(),
              );

              setState(() {
                _allStudents.add(newStudent);
                _filterStudents(_searchController.text);
              });

              _saveStudentsToStorage(message: 'Thêm sinh viên thành công!');
              Navigator.pop(ctx);
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showEditStudentDialog(Student student) {
    final nameCtrl = TextEditingController(text: student.name);
    final emailCtrl = TextEditingController(text: student.email);
    final majorCtrl = TextEditingController(text: student.major);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sửa thông tin #${student.id}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: majorCtrl,
                decoration: const InputDecoration(labelText: 'Chuyên ngành'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                student.name = nameCtrl.text.trim();
                student.email = emailCtrl.text.trim();
                student.major = majorCtrl.text.trim();
                _filterStudents(_searchController.text);
              });

              _saveStudentsToStorage(message: 'Cập nhật sinh viên thành công!');
              Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteStudent(Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa "${student.name}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                _allStudents.removeWhere((s) => s.id == student.id);
                _filterStudents(_searchController.text);
              });

              _saveStudentsToStorage(message: 'Đã xóa sinh viên khỏi database!');
              Navigator.pop(ctx);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3: JSON CRUD DB'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudentDialog,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Thêm sinh viên',
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo tên, email, ngành...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterStudents('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onChanged: (value) => _filterStudents(value),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hiển thị: ${_filteredStudents.length}/${_allStudents.length} sinh viên',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: _filteredStudents.isEmpty
                        ? const Center(child: Text('Không tìm thấy sinh viên nào.'))
                        : ListView.builder(
                            itemCount: _filteredStudents.length,
                            itemBuilder: (context, index) {
                              final student = _filteredStudents[index];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.shade100,
                                    child: Text(
                                      '${student.id}',
                                      style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    student.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('${student.email} • Ngành: ${student.major}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showEditStudentDialog(student),
                                        tooltip: 'Sửa',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () => _confirmDeleteStudent(student),
                                        tooltip: 'Xóa',
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
