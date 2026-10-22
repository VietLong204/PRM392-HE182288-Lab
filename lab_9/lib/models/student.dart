class Student {
  int id;
  String name;
  String major;

  Student({
    required this.id,
    required this.name,
    required this.major,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      major: json['major'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'major': major,
    };
  }
}
