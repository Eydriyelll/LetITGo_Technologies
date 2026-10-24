import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'legal_page_scaffold.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static const _chapters = <_HistoryChapter>[
    _HistoryChapter(
      icon: Icons.bug_report_outlined,
      title: 'A frustration shared across fields',
      body: 'It started with Robby, the founder of our company. Across cloud '
          'computing, IoT, and cybersecurity, she saw people running into the '
          'same frustration: bugs getting in the way of their work.',
    ),
    _HistoryChapter(
      icon: Icons.lightbulb_outline,
      title: 'A vision takes shape',
      body:
          'Robby wanted to build a company people could turn to whenever bugs '
          'became a problem—a team ready to help, so no one had to face those '
          'challenges alone.',
    ),
    _HistoryChapter(
      icon: Icons.groups_outlined,
      title: 'Built together, growing together',
      body:
          'She brought together a close group of friends to bring that idea to '
          'life. Together, we shaped the company’s direction and kept improving '
          'it. We continue to learn, adapt to new tools and trends, and solve '
          'that same problem better every day.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LegalPageScaffold(
      title: 'Our History',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A company built so no one has to face bugs alone.',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.accentLight,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Our story began with a familiar challenge—and a belief that '
            'people deserve a team they can turn to when technology gets in '
            'the way.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.xl),
          for (var index = 0; index < _chapters.length; index++)
            _ChapterRow(
              chapter: _chapters[index],
              isLast: index == _chapters.length - 1,
            ),
        ],
      ),
    );
  }
}

class _HistoryChapter {
  final IconData icon;
  final String title;
  final String body;

  const _HistoryChapter({
    required this.icon,
    required this.title,
    required this.body,
  });
}

class _ChapterRow extends StatelessWidget {
  final _HistoryChapter chapter;
  final bool isLast;

  const _ChapterRow({required this.chapter, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.accentGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentLight.withValues(alpha: 0.2),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Icon(
                    chapter.icon,
                    color: AppColors.abyssDark,
                    size: 19,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.2,
                      margin:
                          const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      color: AppColors.glassBorder,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chapter.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      chapter.body,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
