import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/features/social_feed/domain/reel_model.dart';
import 'package:whdanz/core/theme/app_theme.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isPaused = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reels = _getMockReels();

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          return _ReelVideo(
            reel: reels[index],
            isPaused: _isPaused,
            onTap: () {
              setState(() => _isPaused = !_isPaused);
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab('Para ti', 0),
          const SizedBox(width: AppDimensions.lg),
          _buildTab('Siguiendo', 1),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: AppDimensions.md),
          child: IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: () => context.push('/feed/reels/create'),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _currentIndex == 0;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index == 0 ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 30,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  List<ReelModel> _getMockReels() {
    return [
      ReelModel(
        id: '1',
        userId: 'user1',
        userName: 'Maria Dance',
        videoURL: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        caption: 'Nueva coreografía de Salsa 🕺💃 #salsa #baile',
        musicTitle: 'La Gota Fría',
        musicArtist: 'Carlos Vives',
        likesCount: 1240,
        commentsCount: 89,
        sharesCount: 45,
        viewsCount: 15600,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['salsa', 'baile', 'coreografia'],
      ),
      ReelModel(
        id: '2',
        userId: 'user2',
        userName: 'Juan Baila',
        videoURL: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        caption: 'Aprendiendo pasos de Bachata 💃',
        musicTitle: 'Bachata',
        musicArtist: 'Juan Luis Guerra',
        likesCount: 892,
        commentsCount: 45,
        sharesCount: 23,
        viewsCount: 8900,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        tags: ['bachata', 'baile'],
      ),
      ReelModel(
        id: '3',
        userId: 'user3',
        userName: 'Sofia KPop',
        videoURL: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        caption: 'Coreografía completa de KPop 🦋',
        musicTitle: 'Butter',
        musicArtist: 'BTS',
        likesCount: 5420,
        commentsCount: 234,
        sharesCount: 156,
        viewsCount: 45000,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['kpop', 'bts', 'coreografia'],
      ),
    ];
  }
}

class _ReelVideo extends StatelessWidget {
  final ReelModel reel;
  final bool isPaused;
  final VoidCallback onTap;

  const _ReelVideo({
    required this.reel,
    required this.isPaused,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: AppColors.surfaceLight,
            child: Center(
              child: isPaused
                  ? const Icon(
                      Icons.play_arrow,
                      size: 80,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.music_note,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
            ),
          ),
          if (!isPaused) _buildAudioVisualizer(),
          _buildRightActions(),
          _buildBottomContent(),
        ],
      ),
    );
  }

  Widget _buildAudioVisualizer() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 80,
      right: AppDimensions.md,
      child: Column(
        children: List.generate(
          5,
          (index) => Container(
            width: 3,
            height: 10 + (index * 3).toDouble(),
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightActions() {
    return Positioned(
      right: AppDimensions.md,
      bottom: 120,
      child: Column(
        children: [
          _buildActionButton(
            icon: Icons.favorite,
            label: _formatNumber(reel.likesCount),
            onTap: () {},
          ),
          const SizedBox(height: AppDimensions.lg),
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            label: _formatNumber(reel.commentsCount),
            onTap: () {},
          ),
          const SizedBox(height: AppDimensions.lg),
          _buildActionButton(
            icon: Icons.send,
            label: 'Compartir',
            onTap: () {},
          ),
          const SizedBox(height: AppDimensions.lg),
          _buildActionButton(
            icon: Icons.bookmark_outline,
            label: 'Guardar',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomContent() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 20,
      left: AppDimensions.md,
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    reel.userName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Text(
                reel.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Seguir',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            reel.caption,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              const Icon(Icons.music_note, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              if (reel.musicTitle != null) ...[
                Text(
                  reel.musicTitle!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                if (reel.musicArtist != null) ...[
                  const Text(
                    ' - ',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    reel.musicArtist!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              const Icon(Icons.visibility, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                '${_formatNumber(reel.viewsCount)} reproducciones',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
