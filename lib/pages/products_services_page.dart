import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../sections/products_services_section.dart';

/// /products-services — what we offer, as its own page.
class ProductsServicesPage extends StatelessWidget {
  const ProductsServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.lg),
      child: ProductsServicesSection(),
    );
  }
}
