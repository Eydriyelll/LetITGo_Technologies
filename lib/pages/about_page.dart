import 'package:flutter/material.dart';
import '../sections/about_us_section.dart';
import '../sections/motto_section.dart';
import '../sections/mission_section.dart';
import '../sections/vision_section.dart';
import '../sections/org_chart_section.dart';

/// /about — who we are, our motto, mission, vision, and how we're
/// organized. Each piece is its own reusable section widget; this page
/// just stacks them.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AboutUsSection(),
        MottoSection(),
        MissionSection(),
        VisionSection(),
        OrgChartSection(),
      ],
    );
  }
}
