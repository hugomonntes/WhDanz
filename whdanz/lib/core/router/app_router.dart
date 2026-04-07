import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/auth/presentation/settings_screen.dart';
import '../../features/auth/presentation/edit_profile_screen.dart';
import '../../features/camera/presentation/simple_camera_screen.dart';
import '../../features/social_feed/presentation/feed_screen.dart';
import '../../features/social_feed/presentation/create_post_screen.dart';
import '../../features/social_feed/presentation/stories_screen.dart';
import '../../features/social_feed/presentation/story_viewer_screen.dart';
import '../../features/social_feed/presentation/create_story_screen.dart';
import '../../features/social_feed/presentation/messages_screen.dart';
import '../../features/social_feed/presentation/chat_screen.dart';
import '../../features/social_feed/presentation/new_message_screen.dart';
import '../../features/social_feed/presentation/comments_screen.dart';
import '../../features/places/presentation/map_screen.dart';
import '../../features/places/presentation/place_detail_screen.dart';
import '../../features/places/presentation/add_place_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/social_feed/presentation/search_screen.dart';
import '../widgets/shell_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => ShellScaffold(child: child),
      routes: [
        GoRoute(
          path: '/feed',
          builder: (context, state) => const FeedScreen(),
          routes: [
            GoRoute(
              path: 'create',
              builder: (context, state) => const CreatePostScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/camera',
          builder: (context, state) => const SimpleCameraScreen(),
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) => const MapScreen(),
          routes: [
            GoRoute(
              path: 'place/:placeId',
              builder: (context, state) {
                final placeId = state.pathParameters['placeId'] ?? '';
                return PlaceDetailScreen(placeId: placeId);
              },
            ),
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddPlaceScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/profile/:userId',
          builder: (context, state) {
            final userId = state.pathParameters['userId'] ?? '';
            return ProfileScreen(userId: userId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/feed/stories',
      builder: (context, state) => const StoriesScreen(),
      routes: [
        GoRoute(
          path: 'view/:index',
          builder: (context, state) {
            final index = int.tryParse(state.pathParameters['index'] ?? '0') ?? 0;
            return StoryViewerScreen(initialIndex: index);
          },
        ),
        GoRoute(
          path: 'create',
          builder: (context, state) => const CreateStoryScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/feed/messages',
      builder: (context, state) => const MessagesScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const NewMessageScreen(),
        ),
        GoRoute(
          path: ':participantId',
          builder: (context, state) {
            final participantId = state.pathParameters['participantId'] ?? '';
            final participantName = state.uri.queryParameters['name'] ?? 'Usuario';
            return ChatScreen(
              participantId: participantId,
              participantName: participantName,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/feed/comments/:postId',
      builder: (context, state) {
        final postId = state.pathParameters['postId'] ?? '';
        return CommentsScreen(postId: postId);
      },
    ),
  ],
);
