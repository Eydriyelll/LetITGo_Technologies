import 'package:flutter/material.dart';
import '../sections/hero_banner_section.dart';
import '../sections/explore_links_section.dart';

/// / — landing page. Just the hero and a set of quick links into the
/// other pages (About, Values, Products & Services, History, Careers),
/// which are now full routes rather than scroll-anchors on this page.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HeroBannerSection(),
        ExploreLinksSection(),
      ],
    );
  }
}
