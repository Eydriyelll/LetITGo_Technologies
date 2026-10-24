import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../sections/values_section.dart';

/// /values — what guides us, as its own page.
class ValuesPage extends StatelessWidget {
  const ValuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.lg),
      child: ValuesSection(),
    );
  }
}
