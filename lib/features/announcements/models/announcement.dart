enum AnnouncementCategory { urgent, maintenance, info }

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
