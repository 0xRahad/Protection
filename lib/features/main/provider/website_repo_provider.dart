import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protection/features/main/model/blocked_website.dart';
import '../repository/website_repository.dart';

final websiteRepoProvider = Provider<WebsiteRepository>((ref) {
  throw UnimplementedError(); // Overridden in main
});

final blockedWebsitesProvider =
    StateNotifierProvider<BlockedWebsitesNotifier, List<BlockedWebsite>>((ref) {
      final repo = ref.watch(websiteRepoProvider);
      return BlockedWebsitesNotifier(repo);
    });

class BlockedWebsitesNotifier extends StateNotifier<List<BlockedWebsite>> {
  final WebsiteRepository _repo;

  BlockedWebsitesNotifier(this._repo) : super(_repo.getAllWebsites());

  void addWebsite(String url) {
    _repo.addWebsite(url);
    state = _repo.getAllWebsites();
  }

  void removeWebsite(int id) {
    _repo.removeWebsite(id);
    state = _repo.getAllWebsites();
  }
}
