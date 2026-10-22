class Note {
  final String title;

  Note({required this.title});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(title: json['title'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'title': title};
  }
}
