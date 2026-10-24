import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';
import '../widgets/contact_modal.dart';

/// A single open position within a [JobSpecialization].
class JobOpening {
  final String title;
  final String summary;
  final List<String> responsibilities;
  final List<String> requirements;
  const JobOpening({
    required this.title,
    required this.summary,
    required this.responsibilities,
    required this.requirements,
  });
}

/// One hiring track (IoT / Cybersecurity / Cloud) with its own openings.
class JobSpecialization {
  final IconData icon;
  final String name;
  final String tagline;
  final Color accent;
  final List<JobOpening> jobs;
  const JobSpecialization({
    required this.icon,
    required this.name,
    required this.tagline,
    required this.accent,
    required this.jobs,
  });
}

// TODO: [HR] Replace with a real feed (ATS API) once one is connected.
// Content below is ported from the team's job-vacancy draft.
const List<JobSpecialization> _specializations = [
  JobSpecialization(
    icon: Icons.sensors,
    name: 'Internet of Things (IoT)',
    tagline: 'Connect, deploy and maintain smart devices.',
    accent: AppColors.accentLight,
    jobs: [
      JobOpening(
        title: 'IoT Support & Deployment Technician',
        summary: 'Handles the on-site physical setup, sensor mounting, and '
            'field troubleshooting of smart hardware, microcontrollers, and '
            'edge gateways.',
        responsibilities: [
          'Install sensors, microcontrollers, and edge gateways at client sites',
          'Troubleshoot hardware and connectivity issues in the field',
          'Document installations and hand over setups to clients',
        ],
        requirements: [
          'Diploma or degree in Electronics, IT, or a related field',
          'Basic knowledge of Arduino, ESP32, or Raspberry Pi',
          'Willingness to travel to client sites',
        ],
      ),
      JobOpening(
        title: 'IoT Head',
        summary: 'Leads the IoT team: oversees device deployment, protocol '
            'integration (MQTT, Zigbee, LoRaWAN, Wi-Fi), OTA updates, and '
            'device health monitoring across client sites.',
        responsibilities: [
          'Lead and mentor the IoT technicians and engineers',
          'Oversee integration of edge devices with dashboards and servers',
          'Manage OTA updates, telemetry monitoring, and vulnerability patches',
        ],
        requirements: [
          'Several years of experience in IoT systems and networking',
          'Prior team leadership or supervisory experience',
          'Strong planning and client communication skills',
        ],
      ),
    ],
  ),
  JobSpecialization(
    icon: Icons.security,
    name: 'Cybersecurity',
    tagline: 'Detect, prevent and respond to digital threats.',
    accent: AppColors.danger,
    jobs: [
      JobOpening(
        title: 'Security Operations Center (SOC) Support Analyst',
        summary: 'Monitors real-time alerts, investigates suspected malware '
            'or phishing incidents, and escalates active network breaches.',
        responsibilities: [
          'Monitor security alerts and logs in real time',
          'Investigate suspected malware and phishing incidents',
          'Escalate confirmed breaches following incident procedures',
        ],
        requirements: [
          'Knowledge of networking and security fundamentals',
          'Familiarity with SIEM tools is an advantage',
          'Willing to work in shifts',
        ],
      ),
      JobOpening(
        title: 'Cybersecurity Head',
        summary: 'Leads the security team: oversees vulnerability scanning '
            'and patching, identity and access management (MFA, SSO, '
            'role-based permissions), and incident response for clients.',
        responsibilities: [
          'Lead the security team and set security standards',
          'Oversee vulnerability assessments, patching, and configuration audits',
          'Manage MFA, SSO, and access control for client staff',
        ],
        requirements: [
          'Several years of experience in cybersecurity',
          'Security certification (e.g., Security+, CEH, CISSP) is a plus',
          'Leadership and strong reporting skills',
        ],
      ),
    ],
  ),
  JobSpecialization(
    icon: Icons.cloud_outlined,
    name: 'Cloud Computing',
    tagline: 'Build, migrate and optimize cloud environments.',
    accent: AppColors.primaryLight,
    jobs: [
      JobOpening(
        title: 'Cloud Support Engineer',
        summary: 'Acts as the frontline troubleshooter for client cloud '
            'environments (AWS, Azure, Google Cloud), resolving issues '
            'related to virtual machines, cloud storage buckets, and user access.',
        responsibilities: [
          'Resolve tickets on virtual machines, storage, and user access',
          'Troubleshoot AWS, Azure, and Google Cloud environments',
          'Communicate clearly with clients about issues and fixes',
        ],
        requirements: [
          'Hands-on knowledge of at least one major cloud platform',
          'Basic networking and server administration skills',
          'Cloud certification is a plus',
        ],
      ),
      JobOpening(
        title: 'Cloud Computing Head',
        summary: 'Leads the cloud team: oversees migration of legacy '
            'on-premise infrastructure to the cloud, client onboarding, and '
            'cloud cost and resource optimization.',
        responsibilities: [
          'Lead the cloud team and plan client migrations',
          'Oversee onboarding of shared folders, databases, and servers to the cloud',
          'Audit usage to cut idle resources and optimize monthly spending',
        ],
        requirements: [
          'Several years of experience in cloud and infrastructure',
          'Experience leading projects and teams',
          'Knowledge of cloud pricing and cost tools',
        ],
      ),
    ],
  ),
];

class CareersJobVacancySection extends StatefulWidget {
  const CareersJobVacancySection({super.key});

  @override
  State<CareersJobVacancySection> createState() => _CareersJobVacancySectionState();
}

class _CareersJobVacancySectionState extends State<CareersJobVacancySection> {
  int? _selected;
  final _jobsAnchorKey = GlobalKey();

  void _select(int index) {
    setState(() => _selected = index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _jobsAnchorKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  int get _totalOpenings =>
      _specializations.fold(0, (sum, s) => sum + s.jobs.length);

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final columns = AppBreakpoints.isDesktop(width) ? 3 : 1;

    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Open roles', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.md),
          Text(
            'We\'re hiring across IoT, cybersecurity and cloud computing \u2014 '
            '$_totalOpenings open positions. Pick a specialization to see '
            'its roles.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = AppSpacing.lg;
              final cardWidth = columns == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (int i = 0; i < _specializations.length; i++)
                    SizedBox(
                      width: cardWidth,
                      child: _SpecializationCard(
                        spec: _specializations[i],
                        selected: _selected == i,
                        onTap: () => _select(i),
                      ),
                    ),
                ],
              );
            },
          ),
          SizedBox(key: _jobsAnchorKey, height: AppSpacing.xl),
          if (_selected == null)
            Text(
              'Select a specialization above to view its open positions.',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else ...[
            Text(
              'Open positions \u2014 ${_specializations[_selected!].name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final job in _specializations[_selected!].jobs)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _JobCard(job: job, spec: _specializations[_selected!]),
              ),
          ],
        ],
      ),
    );
  }
}

class _SpecializationCard extends StatelessWidget {
  final JobSpecialization spec;
  final bool selected;
  final VoidCallback onTap;
  const _SpecializationCard({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${spec.name}: ${spec.tagline}, ${spec.jobs.length} openings',
      button: true,
      selected: selected,
      child: GlassCard(
        onTap: onTap,
        borderColor: selected ? spec.accent : null,
        borderWidth: selected ? 1.8 : 1.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: spec.accent, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(spec.icon, color: AppColors.abyssDark, size: 22),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(spec.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(spec.tagline, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${spec.jobs.length} openings',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: spec.accent),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobOpening job;
  final JobSpecialization spec;
  const _JobCard({required this.job, required this.spec});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Responsive(
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _details(context),
            const SizedBox(height: AppSpacing.md),
            SizedBox(width: double.infinity, child: _viewButton(context)),
          ],
        ),
        desktop: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _details(context)),
            const SizedBox(width: AppSpacing.md),
            _viewButton(context),
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
        Text(job.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: const [
            GlassChip(child: Text('Full-time')),
            GlassChip(child: Text('On-site / Hybrid')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(job.summary, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _viewButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => showDialog(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.55),
        builder: (_) => _JobDetailModal(job: job, spec: spec),
      ),
      child: const Text('View details'),
    );
  }
}

class _JobDetailModal extends StatelessWidget {
  final JobOpening job;
  final JobSpecialization spec;
  const _JobDetailModal({required this.job, required this.spec});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dialogWidth = width < AppBreakpoints.mobile ? width * 0.92 : 560.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.md),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth, maxHeight: 640),
        child: GlassCard(
          fillColor: AppColors.abyssLight.withValues(alpha: 0.85),
          blurSigma: 14,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    GlassChip(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(spec.icon, size: 14, color: spec.accent),
                          const SizedBox(width: AppSpacing.xs),
                          Text(spec.name, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Text(job.title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: const [
                    GlassChip(child: Text('Full-time')),
                    GlassChip(child: Text('On-site / Hybrid')),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('About the role', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(job.summary, style: Theme.of(context).textTheme.bodyMedium),
                _bulletSection(context, 'Responsibilities', job.responsibilities),
                _bulletSection(context, 'Requirements', job.requirements),
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

  Widget _bulletSection(BuildContext context, String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, size: 18, color: spec.accent),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
