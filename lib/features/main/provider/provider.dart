import 'package:flutter_riverpod/flutter_riverpod.dart';

final processingProvider = StateProvider<bool>((ref) {
  return false;
});