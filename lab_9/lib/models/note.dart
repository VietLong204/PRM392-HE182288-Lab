class Note {
  final String title;
  final String date;

  Note({
    required this.title,
    required this.date,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
    };
  }
}
