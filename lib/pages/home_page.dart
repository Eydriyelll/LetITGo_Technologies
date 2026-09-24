import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../utils/section_keys.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/cookie_consent_banner.dart';
import '../sections/navbar.dart';
import '../sections/hero_banner_section.dart';
import '../sections/mission_section.dart';
import '../sections/vision_section.dart';
import '../sections/values_section.dart';
import '../sections/history_section.dart';
import '../sections/products_services_section.dart';
import '../sections/org_chart_section.dart';
import '../sections/careers_job_vacancy_section.dart';
import '../sections/footer_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // TODO: [Dev] Replace with real bootstrap work if needed (remote
    // config fetch, font preloading, etc). The skeleton stays visible
    // for at least this long so the shimmer isn't a single-frame flash.
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: !_ready
            ? const SkeletonLoadingScreen()
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 88), // Space for sticky navbar.
                        HeroBannerSection(key: SectionKeys.hero),
                        MissionSection(key: SectionKeys.mission),
                        VisionSection(key: SectionKeys.vision),
                        ValuesSection(key: SectionKeys.values),
                        HistorySection(key: SectionKeys.history),
                        ProductsServicesSection(key: SectionKeys.products),
                        OrgChartSection(key: SectionKeys.orgChart),
                        CareersJobVacancySection(key: SectionKeys.careers),
                        FooterSection(key: SectionKeys.footer),
                      ],
                    ),
                  ),
                  const Positioned(top: 0, left: 0, right: 0, child: Navbar()),
                  CookieConsentBanner(
                    onViewPrivacyPolicy: () => context.push('/privacy-policy'),
                  ),
                ],
              ),
      ),
    );
  }
}
