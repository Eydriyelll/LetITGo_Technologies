import 'package:flutter/material.dart';

/// Data model backing [ValuesSection]. Kept as plain data (rather than
/// inline in the widget) so content can be edited without touching layout
/// code, and so a future CMS/remote-config source can swap this out.
class CompanyValue {
  final IconData icon;
  final String title;
  final String description;
  const CompanyValue(this.icon, this.title, this.description);
}

// TODO: [Content Dev] Review/replace copy as the brand voice firms up.
const List<CompanyValue> companyValues = [
  CompanyValue(
    Icons.bug_report_outlined,
    'We don\'t flinch at bugs',
    'Every system we touch — cloud, IoT, or on-prem — gets the same '
        'patient, methodical troubleshooting. Bugs are a Tuesday, not a crisis.',
  ),
  CompanyValue(
    Icons.shield_outlined,
    'Security is not an add-on',
    'We design for it from day one rather than bolting it on after '
        'something goes wrong. Fewer surprises, fewer 2 a.m. calls.',
  ),
  CompanyValue(
    Icons.visibility_outlined,
    'Plain-language transparency',
    'You\'ll always know what we\'re doing, why, and what it costs — '
        'no jargon walls between you and your own infrastructure.',
  ),
  CompanyValue(
    Icons.bolt_outlined,
    'Built to scale quietly',
    'Good infrastructure is the kind you stop thinking about. We aim '
        'for systems that grow with you without drama.',
  ),
  CompanyValue(
    Icons.support_agent_outlined,
    'Actually reachable',
    'A real person picks up. Managed services shouldn\'t mean '
        'disappearing after the contract is signed.',
  ),
  CompanyValue(
    Icons.groups_outlined,
    'Small team, high trust',
    'We stayed close-knit on purpose — it\'s easier to keep our '
        'standards high when everyone still knows every client.',
  ),
];
