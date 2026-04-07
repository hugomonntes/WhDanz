import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/features/social_feed/domain/message_model.dart';
import 'package:whdanz/core/theme/app_theme.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    final conversations = _getMockConversations();

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
            SliverPadding(
              padding: const EdgeInsets.only(bottom: AppDimensions.xxl),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _ConversationTile(
                    conversation: conversations[index],
                    onTap: () => context.push(
                      '/feed/messages/${conversations[index].participantId}?name=${Uri.encodeComponent(conversations[index].participantName)}',
                    ),
                  ),
                  childCount: conversations.length,
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
        'Mensajes',
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
            icon: const Icon(Icons.edit_square, size: 22),
            onPressed: () => context.push('/feed/messages/new'),
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
      ],
    );
  }

  static List<ConversationModel> _getMockConversations() {
    return [
      ConversationModel(
        id: '1',
        participantId: 'user1',
        participantName: 'Maria Dance',
        lastMessage: '¡Hola! Muy buena tu coreografía 🔥',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 2,
      ),
      ConversationModel(
        id: '2',
        participantId: 'user2',
        participantName: 'Juan Baila',
        lastMessage: '¿Nos vemos mañana a practicar?',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
      ),
      ConversationModel(
        id: '3',
        participantId: 'user3',
        participantName: 'Sofia KPop',
        lastMessage: 'Me encantó tu reel! 💃',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 1,
      ),
      ConversationModel(
        id: '4',
        participantId: 'user4',
        participantName: 'Carlos Salsa',
        lastMessage: 'Voy a llegar tarde a la clase',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
      ),
      ConversationModel(
        id: '5',
        participantId: 'user5',
        participantName: 'Ana Reggaeton',
        lastMessage: '¿Qué ritmo vamos a aprender hoy?',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
        unreadCount: 0,
      ),
    ];
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.surfaceLight.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      conversation.participantName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          conversation.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.participantName,
                        style: TextStyle(
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _formatTime(conversation.lastMessageTime),
                        style: TextStyle(
                          color: hasUnread ? AppColors.primary : AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.lastMessage,
                    style: TextStyle(
                      color: hasUnread ? AppColors.textPrimary : AppColors.textMuted,
                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'ahora';
  }
}
