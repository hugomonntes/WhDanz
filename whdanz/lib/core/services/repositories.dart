import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whdanz/core/services/user_repository.dart';
import 'package:whdanz/core/services/post_repository.dart';
import 'package:whdanz/core/services/place_repository.dart';
import 'package:whdanz/core/services/practice_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  return PlaceRepository();
});

final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  return PracticeRepository();
});
