enum AnnouncementCategory { urgent, maintenance, info }

AnnouncementCategory _parseCategory(String? value) {
  return switch (value) {
    'urgent' => AnnouncementCategory.urgent,
    'maintenance' => AnnouncementCategory.maintenance,
    _ => AnnouncementCategory.info,
  };
}

class Announcement {
  final String id;
  final String title;
  final String body;
  final AnnouncementCategory category;
  final String author;
  final DateTime publishedAt;
  final bool isRead;
  final String? imageUrl;
  final String? pdfUrl;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.author,
    required this.publishedAt,
    this.isRead = false,
    this.imageUrl,
    this.pdfUrl,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      category: _parseCategory(json['category'] as String?),
      author: json['author'] as String? ?? 'Administración',
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.now(),
      imageUrl: json['imageUrl'] as String?,
      pdfUrl: json['pdfUrl'] as String?,
    );
  }

  Announcement copyWith({bool? isRead}) {
    return Announcement(
      id: id,
      title: title,
      body: body,
      category: category,
      author: author,
      publishedAt: publishedAt,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl,
      pdfUrl: pdfUrl,
    );
  }
}
