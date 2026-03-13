import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whdanz/core/services/firebase_service.dart';
import 'package:whdanz/core/services/post_repository.dart';
import 'package:whdanz/core/services/user_repository.dart';
import 'package:whdanz/core/services/practice_repository.dart';
import 'package:whdanz/core/services/place_repository.dart';
import 'package:whdanz/features/social_feed/domain/post_model.dart';
import 'package:whdanz/features/auth/domain/user_model.dart';
import 'package:whdanz/features/pose_detection/domain/practice_session_model.dart';
import 'package:whdanz/features/places/domain/place_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService.instance;
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  return PracticeRepository();
});

final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  return PlaceRepository();
});

final feedPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getFeedPosts();
});

final userPostsProvider = FutureProvider.family<List<PostModel>, String>((ref, userId) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getUserPosts(userId);
});

final userProfileProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserById(userId);
});

final practiceHistoryProvider = FutureProvider.family<List<PracticeSession>, String>((ref, userId) async {
  final repository = ref.watch(practiceRepositoryProvider);
  return repository.getUserSessions(userId);
});

final placesListProvider = FutureProvider<List<PlaceModel>>((ref) async {
  final repository = ref.watch(placeRepositoryProvider);
  return repository.getAllPlaces();
});

final notificationsProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection('notifications')
      .orderBy('createdAt', descending: true)
      .limit(20)
      .snapshots();
});

final themeProvider = StateProvider<bool>((ref) => true);

final voiceFeedbackProvider = StateProvider<bool>((ref) => true);

class SettingsState {
  final bool isDarkMode;
  final bool voiceFeedback;
  final bool notifications;
  final String language;

  const SettingsState({
    this.isDarkMode = true,
    this.voiceFeedback = true,
    this.notifications = true,
    this.language = 'es',
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? voiceFeedback,
    bool? notifications,
    String? language,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      voiceFeedback: voiceFeedback ?? this.voiceFeedback,
      notifications: notifications ?? this.notifications,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void toggleVoiceFeedback() {
    state = state.copyWith(voiceFeedback: !state.voiceFeedback);
  }

  void toggleNotifications() {
    state = state.copyWith(notifications: !state.notifications);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class AppState {
  final bool isLoading;
  final String? error;

  const AppState({
    this.isLoading = false,
    this.error,
  });

  AppState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier() : super(const AppState());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier();
});
