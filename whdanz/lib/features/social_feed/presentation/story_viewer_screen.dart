import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/features/social_feed/domain/story_model.dart';
import 'package:whdanz/core/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryViewerScreen extends StatefulWidget {
  final int initialIndex;

  const StoryViewerScreen({super.key, required this.initialIndex});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  final List<StoryModel> _stories = _getMockStories();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _nextStory();
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStory() {
    if (_currentIndex < _stories.length - 1) {
      setState(() => _currentIndex++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    } else {
      context.pop();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    } else {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final width = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < width / 3) {
            _previousStory();
          } else if (details.globalPosition.dx > width * 2 / 3) {
            _nextStory();
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _stories.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                _animationController.reset();
                _animationController.forward();
              },
              itemBuilder: (context, index) {
                return _StoryContent(story: _stories[index]);
              },
            ),
            _buildProgressBars(),
            _buildHeader(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBars() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
      right: 8,
      child: Row(
        children: List.generate(
          _stories.length,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final isCurrentStory = index == _currentIndex;
                    final isPastStory = index < _currentIndex;
                    return LinearProgressIndicator(
                      value: isPastStory
                          ? 1.0
                          : isCurrentStory
                              ? _animationController.value
                              : 0.0,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final story = _stories[_currentIndex];
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: story.userPhotoURL != null
                  ? CachedNetworkImageProvider(story.userPhotoURL!)
                  : null,
              child: story.userPhotoURL == null
                  ? Text(
                      story.userName[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppDimensions.sm),
            Text(
              story.userName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Text(
              _formatTimeAgo(story.createdAt),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 20,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.send,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Enviar mensaje...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays}h';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'ahora';
  }

  static List<StoryModel> _getMockStories() {
    return [
      StoryModel(
        id: '1',
        userId: 'user1',
        userName: 'Maria Dance',
        mediaURL: 'https://picsum.photos/800/1200',
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      StoryModel(
        id: '2',
        userId: 'user2',
        userName: 'Juan Baila',
        mediaURL: 'https://picsum.photos/800/1201',
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      StoryModel(
        id: '3',
        userId: 'user3',
        userName: 'Sofia KPop',
        mediaURL: 'https://picsum.photos/800/1202',
        mediaType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }
}

class _StoryContent extends StatelessWidget {
  final StoryModel story;

  const _StoryContent({required this.story});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: story.mediaURL,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.surfaceLight,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.surfaceLight,
            child: const Icon(Icons.error, color: Colors.white),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withValues(alpha: 0.5),
              ],
              stops: const [0.0, 0.2, 0.8, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
