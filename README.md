# Let IT Go Technologies — Corporate Web App

Flutter Web single-page site. Enterprise-grade glassmorphism ("Frozen /
Permafrost" theme), modular section widgets, go_router-based routing (ready
to grow beyond a single page), EmailJS-powered contact form, and the SEO /
security / compliance scaffolding described below.

This is a **barebone architecture** — content sections are wired up,
responsive, accessible and production-structured, but most copy is
placeholder text marked `// TODO: [Owner]` for the relevant team to replace.

---

## 1. Getting set up

```bash
flutter pub get
```

Requires a reasonably current Flutter stable (3.22+) for `go_router: ^14`
and Material 3 APIs used in `app_theme.dart`.

### Run locally

```bash
flutter run -d chrome \
  --dart-define=EMAILJS_SERVICE_ID=your_service_id \
  --dart-define=EMAILJS_TEMPLATE_ID=your_template_id \
  --dart-define=EMAILJS_PUBLIC_KEY=your_public_key
```

Without the three `EMAILJS_*` defines, the app still runs — the contact
modal will show a "not configured yet" message instead of silently failing.

---

## 2. EmailJS setup (contact / inquiry form)

1. Create a free account at [emailjs.com](https://www.emailjs.com/).
2. Add an **Email Service** (e.g. Gmail, Outlook, SMTP) → note its **Service ID**.
3. Create an **Email Template** with these variables (they must match
   exactly, they're wired in `lib/widgets/contact_modal.dart`):
   - `{{from_name}}`
   - `{{from_email}}`
   - `{{company}}`
   - `{{message}}`
4. Copy the template's **Template ID**.
5. Copy your account's **Public Key** (Account → General).
6. In the EmailJS dashboard, restrict allowed origins to your production
   domain (and `localhost` for local dev) — this is EmailJS's built-in
   protection against the public key being used from other sites.
7. Feed all three values in as `--dart-define` flags (see below for Vercel).

The honeypot field and client-side validation (`lib/widgets/contact_modal.dart`)
run before any request reaches EmailJS, so most bot traffic never gets that far.

---

## 3. Deploying to Vercel

`vercel.json` is already configured with:
- The Flutter build command, wired to pull `EMAILJS_*` from Vercel
  environment variables at build time.
- SPA rewrites so deep links like `/privacy-policy` resolve correctly with
  `go_router`'s path-based routing (Vercel would 404 on a raw path reload
  without this).
- Basic security headers and long-cache headers for `/assets/*`.

**In the Vercel project settings**, add these Environment Variables
(Production, and Preview if you want the form to work on preview deploys):

| Name | Value |
|---|---|
| `EMAILJS_SERVICE_ID` | from EmailJS dashboard |
| `EMAILJS_TEMPLATE_ID` | from EmailJS dashboard |
| `EMAILJS_PUBLIC_KEY` | from EmailJS dashboard |

Vercel auto-detects Flutter poorly, so confirm in Project Settings:
- **Framework Preset:** Other
- **Build Command:** (already set via `vercel.json`)
- **Output Directory:** `build/web` (already set via `vercel.json`)
- **Install Command:** leave default, or add a step to install the Flutter
  SDK on the build image if your Vercel build image doesn't already have it
  (see note below).

> **Note:** Vercel's default build images do not ship the Flutter SDK. The
> simplest reliable options are: (a) use a GitHub Action / other CI to run
> `flutter build web` and deploy the static `build/web` output to Vercel via
> the Vercel CLI (`vercel deploy --prebuilt`), or (b) use a custom Vercel
> build image with Flutter preinstalled. Either way, `vercel.json`'s
> `outputDirectory: build/web` stays correct.

---

## 4. Rendering: CanvasKit

This project targets **CanvasKit** rather than the HTML renderer, since the
`GlassCard` system leans on `BackdropFilter` blur, which CanvasKit renders
far more faithfully (the HTML renderer's blur support is inconsistent
across browsers). The tradeoff is a larger initial download (CanvasKit
`.wasm`/`.js` payload, cached after first visit).

- Flutter 3.22 and earlier: `flutter build web --web-renderer canvaskit`
- Flutter 3.29+: renderer selection changed to an auto/WASM model — CanvasKit
  is generally the default fallback already; if your installed SDK exposes
  `--web-renderer`, keep using `canvaskit` explicitly for consistency.

See `lib/widgets/glass_card.dart` for the performance ground rules
(no nested blurred cards, capped blur sigma) that keep this fast.

---

## 5. Fonts

`lib/theme/app_theme.dart` declares two font family names —
`ClashDisplay` (headlines) and `GeneralSans` (body) — as placeholders for a
distinct display/text pairing. **No font files are bundled yet**, so Flutter
currently falls back to the system sans-serif.

To activate real fonts:
1. Obtain licensed `.ttf`/`.otf` files (or Google Fonts equivalents).
2. Drop them under `assets/fonts/`.
3. Register them in `pubspec.yaml` under a `fonts:` block.
4. The family name strings in `app_theme.dart` already match — no widget
   code changes needed.

---

## 6. Logo

No logo file exists yet, so the navbar and footer currently render a
generated **"LIGT"** wordmark + circular glyph (`lib/sections/navbar.dart`
`_Logo`, and the matching block in `lib/sections/footer_section.dart`).
Swap in `assets/images/logo.svg` (or `.png`) once available — both spots are
marked `// TODO: [Design]`.

---

## 7. Analytics

Deferred for now per project decision. The GA4 `<script>` block in
`web/index.html` is present but commented out, along with a consent-aware
stub (`window.grantAnalyticsConsent`) that ties into the cookie consent
banner's "Accept" action. When a Measurement ID is ready, uncomment and
replace `G-XXXXXXXXXX`.

`AnalyticsRouteObserver` in `lib/routing/app_router.dart` already fires on
every route change (currently just `debugPrint`s) — that's the hook point
to send `page_view` events once analytics is wired up.

---

## 8. Project structure

```
lib/
  main.dart                     # App entry point
  theme/app_theme.dart          # Colors, gradients, type scale, breakpoints
  utils/
    responsive.dart             # Responsive/ContentBounds helpers
    section_keys.dart           # GlobalKeys + smooth-scroll for nav
  widgets/
    glass_card.dart             # Core glassmorphism surface (+ GlassChip)
    skeleton_loader.dart        # Shimmer skeleton shown on boot
    cookie_consent_banner.dart  # Floating glass consent banner + persistence
    contact_modal.dart          # Validated form + honeypot + EmailJS submit
  services/
    emailjs_service.dart        # EmailJS REST integration, dart-define config
  routing/
    app_router.dart             # go_router route table + 404 + analytics observer
  sections/                     # One StatelessWidget per homepage section
    navbar.dart
    hero_banner_section.dart
    mission_section.dart
    vision_section.dart
    values_section.dart
    history_section.dart
    products_services_section.dart
    org_chart_section.dart
    careers_job_vacancy_section.dart
    footer_section.dart
  pages/
    home_page.dart               # Assembles all sections
    privacy_policy_page.dart
    terms_page.dart
    legal_page_scaffold.dart     # Shared chrome for legal pages
    not_found_page.dart          # Custom 404
web/
  index.html                     # SEO/OG/Twitter meta, favicon, analytics stub
  robots.txt
  sitemap.xml
vercel.json
```

Each section file is a self-contained `StatelessWidget` so multiple
developers can work in parallel without merge conflicts — content edits stay
inside a single file's `// TODO:` blocks.
