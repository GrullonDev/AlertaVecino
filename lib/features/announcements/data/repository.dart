import 'package:neighbour_alert/features/announcements/data/datasource.dart';
import 'package:neighbour_alert/features/announcements/models/announcement.dart';

abstract class AnnouncementsRepository {
  Future<List<Announcement>> list({String? category});
}

class AnnouncementsRepositoryImpl implements AnnouncementsRepository {
  AnnouncementsRepositoryImpl({required this.dataSource});

  final AnnouncementsDataSource dataSource;

  @override
  Future<List<Announcement>> list({String? category}) {
    return dataSource.list(category: category);
  }
}
