import 'package:protection/features/main/model/blocked_website.dart';
import 'package:protection/objectbox.g.dart';

class WebsiteRepository {
  late final Store store;
  late final Box<BlockedWebsite> websiteBox;

  WebsiteRepository._create(this.store) {
    websiteBox = Box<BlockedWebsite>(store);
  }

  static Future<WebsiteRepository> create() async {
    final store = await openStore();
    return WebsiteRepository._create(store);
  }

  List<BlockedWebsite> getAllWebsites() => websiteBox.getAll();

  void addWebsite(String url) {
    websiteBox.put(BlockedWebsite(url: url));
  }

  void removeWebsite(int id) {
    websiteBox.remove(id);
  }
}
