import 'package:neighbour_alert/features/announcements/data/datasource.dart';
import 'package:neighbour_alert/features/announcements/models/announcement.dart';

abstract class AnnouncementsRepository {
  Future<List<Announcement>> list({String? category, required String token});
}

class AnnouncementsRepositoryImpl implements AnnouncementsRepository {
  AnnouncementsRepositoryImpl({required this.dataSource});

  final AnnouncementsDataSource dataSource;

  @override
  Future<List<Announcement>> list({
    String? category,
    required String token,
  }) {
    return dataSource.list(category: category, token: token);
  }
}
