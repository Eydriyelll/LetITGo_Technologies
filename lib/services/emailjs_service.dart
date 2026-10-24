import 'dart:convert';
import 'package:http/http.dart' as http;

/// ---------------------------------------------------------------------------
/// EmailJS integration for the contact / inquiry modal.
///
/// Uses EmailJS's REST endpoint directly (no JS SDK / script tag needed),
/// so this works cleanly from pure Dart on Flutter Web.
///
/// SECURITY NOTE: EmailJS's "Public Key" is designed to be exposed on the
/// client — that's the whole point of calling it a *public* key, the same
/// way a Stripe publishable key or a Firebase web config is meant to be
/// visible in client code. It is not a secret, so baking it in as the
/// default below is fine. Two things still matter:
///   1. Restrict allowed origins/domains in the EmailJS dashboard to your
///      production domain (and localhost for dev), so the key can't be
///      reused from a copy-pasted site.
///   2. Never put a Private Key here. If EmailJS issues one for your
///      account, it must stay server-side only — this file never needs it.
///
/// The defaultValue below is the team's live EmailJS config, so the
/// contact form works out of the box with no build flags needed. The
/// --dart-define override still works on top of it (e.g. to point a
/// staging build at a different EmailJS template), so nothing about the
/// override mechanism changed — only the fallback did.
/// ---------------------------------------------------------------------------
class EmailJsConfig {
  static const String serviceId = String.fromEnvironment(
    'EMAILJS_SERVICE_ID',
    defaultValue: 'service_u23qwze',
  );
  static const String templateId = String.fromEnvironment(
    'EMAILJS_TEMPLATE_ID',
    defaultValue: 'template_phno594',
  );
  static const String publicKey = String.fromEnvironment(
    'EMAILJS_PUBLIC_KEY',
    defaultValue: 'hLBrULwvuQVqGeqlz',
  );

  static bool get isConfigured =>
      serviceId.isNotEmpty && templateId.isNotEmpty && publicKey.isNotEmpty;
}

class EmailJsResult {
  final bool success;
  final String message;
  const EmailJsResult(this.success, this.message);
}

class EmailJsService {
  static const _endpoint = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Sends the contact form. [templateParams] keys must match the variable
  /// names configured in your EmailJS template (e.g. {{from_name}},
  /// {{from_email}}, {{company}}, {{message}}).
  static Future<EmailJsResult> send({
    required Map<String, String> templateParams,
  }) async {
    if (!EmailJsConfig.isConfigured) {
      // TODO: [Dev] Remove this early-return once EMAILJS_* dart-define
      // values are wired into the CI/Vercel build command.
      return const EmailJsResult(
        false,
        'Email service is not configured yet. Set EMAILJS_SERVICE_ID, '
        'EMAILJS_TEMPLATE_ID and EMAILJS_PUBLIC_KEY via --dart-define.',
      );
    }

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': EmailJsConfig.serviceId,
          'template_id': EmailJsConfig.templateId,
          'user_id': EmailJsConfig.publicKey,
          'template_params': templateParams,
        }),
      );

      if (response.statusCode == 200) {
        return const EmailJsResult(true, 'Message sent successfully.');
      }
      return EmailJsResult(
        false,
        'Could not send your message right now (${response.statusCode}). '
        'Please try again shortly.',
      );
    } catch (_) {
      return const EmailJsResult(
        false,
        'Network error — please check your connection and try again.',
      );
    }
  }
}
