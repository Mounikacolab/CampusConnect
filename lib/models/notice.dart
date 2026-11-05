class Notice {
  final String id;
  final String title;
  final String department;
  final String description;
  final DateTime date;
  final String postedBy;

  const Notice({
    required this.id,
    required this.title,
    required this.department,
    required this.description,
    required this.date,
    required this.postedBy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'department': department,
        'description': description,
        'date': date.toIso8601String(),
        'postedBy': postedBy,
      };

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json['id'] as String,
        title: json['title'] as String,
        department: json['department'] as String,
        description: json['description'] as String,
        date: DateTime.parse(json['date'] as String),
        postedBy: (json['postedBy'] as String?) ?? 'College Admin',
      );
}
