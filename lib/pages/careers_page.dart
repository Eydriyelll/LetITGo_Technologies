import 'package:flutter/material.dart';
import '../sections/careers_job_vacancy_section.dart';

/// /careers — open roles, as its own page.
class CareersPage extends StatelessWidget {
  const CareersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CareersJobVacancySection();
  }
}
