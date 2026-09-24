import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/emailjs_service.dart';
import 'glass_card.dart';

/// Shows the contact/inquiry modal as a centered glass dialog.
Future<void> showContactModal(BuildContext context) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => const ContactModal(),
  );
}

class ContactModal extends StatefulWidget {
  const ContactModal({super.key});

  @override
  State<ContactModal> createState() => _ContactModalState();
}

class _ContactModalState extends State<ContactModal> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _messageController = TextEditingController();

  // Honeypot: real users never see or fill this field (see build() below —
  // it's rendered with zero size, off-screen, and excluded from the tab
  // order / screen readers). Bots that auto-fill every input will trip it.
  final _honeypotController = TextEditingController();

  static final RegExp _emailRegex =
      RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[\w\-\.]+$');

  bool _submitting = false;
  String? _statusMessage;
  bool _statusIsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _messageController.dispose();
    _honeypotController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Honeypot check — silently "succeed" for bots so they don't learn
    // to look for a different signal, without ever sending an email.
    if (_honeypotController.text.isNotEmpty) {
      setState(() {
        _statusIsError = false;
        _statusMessage = 'Thanks — we\'ll be in touch shortly.';
      });
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _statusMessage = null;
    });

    final result = await EmailJsService.send(templateParams: {
      'from_name': _nameController.text.trim(),
      'from_email': _emailController.text.trim(),
      'company': _companyController.text.trim(),
      'message': _messageController.text.trim(),
    });

    if (!mounted) return;
    setState(() {
      _submitting = false;
      _statusIsError = !result.success;
      _statusMessage = result.message;
    });

    if (result.success) {
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _companyController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dialogWidth = width < AppBreakpoints.mobile ? width * 0.92 : 480.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.md),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth, maxHeight: 640),
        child: GlassCard(
          fillColor: AppColors.abyssLight.withValues(alpha: 0.75),
          blurSigma: 14,
          semanticLabel: 'Contact and inquiry form',
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Let\'s talk', style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      Semantics(
                        button: true,
                        label: 'Close contact form',
                        child: IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textSecondary),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Tell us about your project and we\'ll get back to you within one business day.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _field(
                    controller: _nameController,
                    label: 'Full name',
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter your name.'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    controller: _emailController,
                    label: 'Work email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'Please enter your email.';
                      if (!_emailRegex.hasMatch(value)) {
                        return 'Enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    controller: _companyController,
                    label: 'Company (optional)',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _field(
                    controller: _messageController,
                    label: 'How can we help?',
                    maxLines: 4,
                    validator: (v) => (v == null || v.trim().length < 10)
                        ? 'Tell us a little more (10+ characters).'
                        : null,
                  ),

                  // --- Honeypot field -----------------------------------
                  // Zero-size, offstage-styled, excluded from Semantics and
                  // never given a visible label — invisible to sighted
                  // users and screen readers alike, but present in the DOM
                  // for naive bots that fill every <input>.
                  Offstage(
                    offstage: true,
                    child: ExcludeSemantics(
                      child: TextFormField(
                        controller: _honeypotController,
                        autofocus: false,
                        decoration: const InputDecoration(labelText: 'Company website'),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  if (_statusMessage != null) ...[
                    Text(
                      _statusMessage!,
                      style: TextStyle(
                        color: _statusIsError ? AppColors.danger : AppColors.success,
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Send message'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary, fontFamily: AppTheme.bodyFontFamily),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.accentLight, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
