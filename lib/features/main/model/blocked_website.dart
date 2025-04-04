import 'package:objectbox/objectbox.dart';

@Entity()
class BlockedWebsite {
  int id = 0;

  late String url;

  BlockedWebsite({required this.url});
}
