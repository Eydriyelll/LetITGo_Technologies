import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';
import '../widgets/contact_modal.dart';

/// TODO: [HR/Content] Replace the sample job below with a real feed
/// (e.g. from an ATS API) once one is connected. The modal trigger and
/// layout are production-ready as-is.
class CareersJobVacancySection extends StatelessWidget {
  const CareersJobVacancySection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Open roles', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.md),
          Text(
            'We\'re hiring across engineering, security and client operations.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          const _JobCard(
            title: 'Senior Cloud Infrastructure Engineer', // TODO: [HR] Replace
            location: 'Manila, PH · Hybrid', // TODO: [HR] Replace
            type: 'Full-time',
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final String title;
  final String location;
  final String type;
  const _JobCard({required this.title, required this.location, required this.type});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Responsive(
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _details(context),
            const SizedBox(height: AppSpacing.md),
            _viewButton(context, fullWidth: true),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(child: _details(context)),
            _viewButton(context, fullWidth: false),
          ],
        ),
      ),
    );
  }

  Widget _details(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            GlassChip(child: Text(location, style: Theme.of(context).textTheme.bodyMedium)),
            GlassChip(child: Text(type, style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
      ],
    );
  }

  Widget _viewButton(BuildContext context, {required bool fullWidth}) {
    final button = OutlinedButton(
      onPressed: () => _showJobModal(context),
      child: const Text('View role'),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  void _showJobModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => _JobDetailModal(title: title, location: location, type: type),
    );
  }
}

class _JobDetailModal extends StatelessWidget {
  final String title;
  final String location;
  final String type;
  const _JobDetailModal({required this.title, required this.location, required this.type});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dialogWidth = width < AppBreakpoints.mobile ? width * 0.92 : 520.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.md),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth, maxHeight: 600),
        child: GlassCard(
          fillColor: AppColors.abyssLight.withValues(alpha: 0.8),
          blurSigma: 14,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineMedium)),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    GlassChip(child: Text(location, style: Theme.of(context).textTheme.bodyMedium)),
                    GlassChip(child: Text(type, style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  // TODO: [HR] Replace with the real job description.
                  'Placeholder job description. Outline responsibilities, '
                  'required experience, and what makes this role and team '
                  'distinct. Replace this block entirely with real content.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showContactModal(context);
                    },
                    child: const Text('Apply now'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
