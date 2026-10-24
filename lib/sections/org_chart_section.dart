import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

/// Org chart: CEO at the top, three C-level branches (COO, CFO, CMO),
/// each with its direct reports listed underneath.
///
/// Every role has an avatar slot. Photos live in assets/images/. If `photo`
/// is null, the icon shows instead.
///
/// TODO: [HR/Content] Confirm each photo matches the right person and
/// replace the remaining placeholder names.

// ─────────────────────────── Data ───────────────────────────

class _Role {
  final String title;
  final String abbr;
  final IconData icon;
  final String? photo; // e.g. 'assets/images/abaquin.PNG'
  final String name;

  const _Role({
    required this.title,
    required this.abbr,
    required this.icon,
    this.photo,
    this.name = 'Placeholder name',
  });
}

class _Branch {
  final _Role head;
  final List<_Role> reports;
  const _Branch(this.head, this.reports);
}

const _ceo = _Role(
  title: 'Chief Executive Officer',
  abbr: 'CEO',
  icon: Icons.workspace_premium_outlined,
  photo: 'assets/images/abaquin.PNG',
  name: 'Robby Ruth Abaquin',
);

const _branches = <_Branch>[
  _Branch(
    _Role(
      title: 'Chief Operating Officer',
      abbr: 'COO',
      icon: Icons.settings_suggest_outlined,
      photo: 'assets/images/araos.png',
      name: 'Adriel Lewis Araos',
    ),
    [
      _Role(
        title: 'Operations Manager',
        abbr: 'Operations',
        icon: Icons.account_tree_outlined,
        photo: 'assets/images/antido.jpg',
        name: 'Kevin Miguel Antido',
      ),
      _Role(
        title: 'Human Resources & Recruitment Officer',
        abbr: 'HR',
        icon: Icons.groups_outlined,
        photo: 'assets/images/yboa.jpg',
        name: 'John Angelo Yboa',
      ),
    ],
  ),
  _Branch(
    _Role(
      title: 'Chief Financial Officer',
      abbr: 'CFO',
      icon: Icons.account_balance_outlined,
      photo: 'assets/images/magpily.JPG',
      name: 'Justin Axcel Magpily',
    ),
    [
      _Role(
        title: 'Accounting Officer',
        abbr: 'Accounting',
        icon: Icons.calculate_outlined,
        photo: 'assets/images/sarmiento.jpg',
        name: 'Cleoh Amor Sarmiento',
      ),
    ],
  ),
  _Branch(
    _Role(
      title: 'Chief Marketing Officer',
      abbr: 'CMO',
      icon: Icons.campaign_outlined,
      photo: 'assets/images/vargas.jpg',
      name: 'Louis Andre Vargas',
    ),
    [
      _Role(
        title: 'Corporate Social Responsibility Head',
        abbr: 'CSR',
        icon: Icons.volunteer_activism_outlined,
        photo: 'assets/images/knowledge.jpg',
        name: 'Alejandro Antonio Karunungan',
      ),
      _Role(
        title: 'Digital Communications Officer',
        abbr: 'DCO',
        icon: Icons.alternate_email,
        photo: 'assets/images/estanislao.png',
        name: 'John Nixon Estanislao',
        // No photo left over, so the icon shows for now.
      ),
    ],
  ),
];

// ─────────────────────────── Section ───────────────────────────

class OrgChartSection extends StatelessWidget {
  const OrgChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      verticalPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How we\'re organized',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: const _RoleCard(role: _ceo, prominent: true),
            ),
          ),
          Responsive(
            mobile: Column(
              children: [
                for (final b in _branches) ...[
                  const _TopConnector(left: false, right: false),
                  _BranchView(branch: b),
                ],
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _branches.length; i++)
                  Expanded(
                    child: Column(
                      children: [
                        // Draws the horizontal bar + drop line above each branch.
                        _TopConnector(
                          left: i > 0,
                          right: i < _branches.length - 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm),
                          child: _BranchView(branch: _branches[i]),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Branch (head + reports) ───────────────────────────

class _BranchView extends StatelessWidget {
  final _Branch branch;
  const _BranchView({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoleCard(role: branch.head, fillColor: AppColors.glassFillTinted),
        for (var i = 0; i < branch.reports.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: _railWidth,
                  child: CustomPaint(
                    painter: _ElbowPainter(
                      isLast: i == branch.reports.length - 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: _gap),
                    child: _RoleCard(role: branch.reports[i]),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────── Role card ───────────────────────────

const double _avatarSize = 44;
const double _cardPad = 12;

class _RoleCard extends StatelessWidget {
  final _Role role;
  final bool prominent;
  final Color? fillColor;
  const _RoleCard({required this.role, this.prominent = false, this.fillColor});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final card = GlassCard(
      fillColor: prominent ? AppColors.glassFillTinted : fillColor,
      padding: const EdgeInsets.all(_cardPad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(role: role, size: prominent ? 56 : _avatarSize),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  role.title,
                  style: prominent ? text.titleLarge : text.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(role.name, style: text.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );

    return Semantics(
      label: '${role.title} (${role.abbr}) — ${role.name}',
      child: card,
    );
  }
}

class _Avatar extends StatelessWidget {
  final _Role role;
  final double size;
  const _Avatar({required this.role, required this.size});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = role.photo != null;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
        image: hasPhoto
            ? DecorationImage(
                image: AssetImage(role.photo!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: hasPhoto
          ? null
          : Icon(role.icon, size: size * 0.5, color: AppColors.accentLight),
    );
  }
}

// ─────────────────────────── Connector lines ───────────────────────────

const double _railWidth = 28;
const double _gap = AppSpacing.md;

/// The elbow tick y-position: gap above the card + center of the avatar row.
double get _tickY => _gap + _cardPad + _avatarSize / 2;

class _ElbowPainter extends CustomPainter {
  final bool isLast;
  const _ElbowPainter({required this.isLast});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.glassBorder
      ..strokeWidth = 2;
    const x = _railWidth / 2;
    final y = _tickY;
    // Vertical rail: stops at the tick for the last report.
    canvas.drawLine(Offset(x, 0), Offset(x, isLast ? y : size.height), paint);
    // Horizontal tick into the card.
    canvas.drawLine(Offset(x, y), Offset(size.width, y), paint);
  }

  @override
  bool shouldRepaint(covariant _ElbowPainter old) => old.isLast != isLast;
}

/// Connects a parent to a child column: a vertical drop in the middle,
/// plus a horizontal bar to the left and/or right to join siblings.
class _TopConnector extends StatelessWidget {
  final bool left;
  final bool right;
  const _TopConnector({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.lg,
      width: double.infinity,
      child: CustomPaint(painter: _TopConnectorPainter(left: left, right: right)),
    );
  }
}

class _TopConnectorPainter extends CustomPainter {
  final bool left;
  final bool right;
  const _TopConnectorPainter({required this.left, required this.right});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.glassBorder
      ..strokeWidth = 2;
    final cx = size.width / 2;
    canvas.drawLine(
      Offset(left ? 0 : cx, 1),
      Offset(right ? size.width : cx, 1),
      paint,
    );
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _TopConnectorPainter old) =>
      old.left != left || old.right != right;
}