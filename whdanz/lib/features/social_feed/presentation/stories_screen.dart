import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/features/social_feed/domain/story_model.dart';
import 'package:whdanz/core/theme/app_theme.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final List<StoryModel> _stories = _getMockStories();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.backgroundSecondary,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: _buildYourStory(),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: AppDimensions.xxl),
              sliver: SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _StoryThumbnail(
                      story: _stories[index],
                      onTap: () => _openStory(index),
                    ),
                    childCount: _stories.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.background.withValues(alpha: 0.9),
      title: const Text(
        'Historias',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: IconButton(
            icon: const Icon(Icons.add, size: 22),
            onPressed: () => _createStory(),
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
      ],
    );
  }

  Widget _buildYourStory() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu Historia',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          _YourStoryButton(onTap: () => _createStory()),
        ],
      ),
    );
  }

  void _openStory(int index) {
    context.push('/feed/stories/view/$index');
  }

  void _createStory() {
    context.push('/feed/stories/create');
  }

  static List<StoryModel> _getMockStories() {
    return [
      StoryModel(
        id: '1',
        userId: 'user1',
        userName: 'Maria Dance',
        mediaURL: 'https://picsum.photos/400/600',
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      StoryModel(
        id: '2',
        userId: 'user2',
        userName: 'Juan Baila',
        mediaURL: 'https://picsum.photos/400/601',
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      StoryModel(
        id: '3',
        userId: 'user3',
        userName: 'Sofia KPop',
        mediaURL: 'https://picsum.photos/400/602',
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      StoryModel(
        id: '4',
        userId: 'user4',
        userName: 'Carlos Salsa',
        mediaURL: 'https://picsum.photos/400/603',
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      StoryModel(
        id: '5',
        userId: 'user5',
        userName: 'Ana Reggaeton',
        mediaURL: 'https://picsum.photos/400/604',
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      StoryModel(
        id: '6',
        userId: 'user6',
        userName: 'Luis Bachata',
        mediaURL: 'https://picsum.photos/400/605',
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}

class _YourStoryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _YourStoryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          gradient: AppColors.primaryGradient,
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Text(
                'Crear',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryThumbnail extends StatelessWidget {
  final StoryModel story;
  final VoidCallback onTap;

  const _StoryThumbnail({
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          image: DecorationImage(
            image: NetworkImage(story.mediaURL),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(AppDimensions.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    story.userName[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                story.userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
