class SavingsTip {
  const SavingsTip({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;

  factory SavingsTip.fromJson(Map<String, dynamic> json) => SavingsTip(
    id: json['id'] as int,
    title: json['title'] as String,
    body: json['body'] as String,
  );
}
