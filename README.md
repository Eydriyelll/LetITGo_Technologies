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
flutter run -d chrome
```

That's it — the team's live EmailJS Service ID, Template ID, and Public
Key are baked in as defaults in `lib/services/emailjs_service.dart`, so
the contact form works with no extra flags. To point a build at a
*different* EmailJS account (a personal test account, a staging template,
etc.), override any of the three with `--dart-define`:

```bash
flutter run -d chrome \
  --dart-define=EMAILJS_SERVICE_ID=your_service_id \
  --dart-define=EMAILJS_TEMPLATE_ID=your_template_id \
  --dart-define=EMAILJS_PUBLIC_KEY=your_public_key
```

---

## 2. EmailJS setup (contact / inquiry form)

Already configured — the live Service ID, Template ID, and Public Key are
set as defaults in `lib/services/emailjs_service.dart`. EmailJS's "Public
Key" is meant to be public (same idea as a Stripe publishable key), so
this is safe to ship; just make sure allowed origins are restricted to
your real domain in the EmailJS dashboard (Account → Security) so the key
can't be reused from a copy-pasted site.

The template expects these variables (wired in `lib/widgets/contact_modal.dart`):
- `{{from_name}}`
- `{{from_email}}`
- `{{company}}`
- `{{message}}`

To swap in a different EmailJS account later, see the `--dart-define`
override above — nothing else needs to change.

The honeypot field and client-side validation (`lib/widgets/contact_modal.dart`)
run before any request reaches EmailJS, so most bot traffic never gets that far.

---

## 3. Deploying to Vercel

`vercel.json` is already configured with:
- A plain `flutter build web --release` — no environment variables needed,
  since the EmailJS keys are baked in as defaults (see section 2). If you
  ever want a Vercel deploy to use a *different* EmailJS account (e.g. a
  separate staging template), add `EMAILJS_SERVICE_ID` /
  `EMAILJS_TEMPLATE_ID` / `EMAILJS_PUBLIC_KEY` as Vercel Environment
  Variables and append the matching `--dart-define=...=$VAR_NAME` flags
  back onto the `buildCommand` in `vercel.json`.
- SPA rewrites so deep links like `/privacy-policy` resolve correctly with
  `go_router`'s path-based routing (Vercel would 404 on a raw path reload
  without this).
- Basic security headers and long-cache headers for `/assets/*`.

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

## 6. Logo & favicons

The real logo is in:
- `assets/images/logo.png` — full lockup (icon + "LET IT GO TECHNOLOGIES"
  wordmark), transparent background. Not currently used in-app, but
  available for anywhere a full lockup is wanted (e.g. a print/export
  asset or a future splash screen).
- `assets/images/logo-mark.png` — just the snowflake, isolated from the
  wordmark, transparent background. This is what `lib/sections/navbar.dart`
  (`_Logo`) and `lib/sections/footer_section.dart` actually render, next
  to a "LET IT GO" text label — transparent works fine there since both
  sit on the app's own dark gradient background.

The browser-facing icons (favicon, Apple touch icon, Android/PWA icons) in
`web/` are generated **from that same snowflake mark, composited onto the
brand's dark navy (`#061838`) instead of left transparent** — a
transparent icon looks inconsistent depending on what's behind it (a white
browser tab, a light OS theme, a home-screen background), so every
browser/OS icon gets a solid brand-colored backing:
- `favicon.ico`, `favicon-16x16.png`, `favicon-32x32.png` — browser tab
- `apple-touch-icon.png` — iOS home screen
- `android-chrome-192x192.png` / `-512x512.png` — PWA/Android, full-bleed
- `android-chrome-maskable-192x192.png` / `-512x512.png` — same, but with
  extra padding inside the frame (per Android's adaptive-icon spec) so the
  mark survives being cropped into a circle/squircle/whatever shape a
  launcher applies
- `web/manifest.json` declares all of the above with the correct
  `purpose: any` / `purpose: maskable` split, and `web/index.html`'s
  `<link rel="icon">` / `<link rel="apple-touch-icon">` tags point at them
- `web/og-preview.png` — the logo on the brand gradient, used for social
  link previews (Open Graph / Twitter Card)

If the logo changes, regenerate this whole set rather than hand-editing
any one file — the icon mark needs to be re-isolated from the new lockup
and re-composited at each size.

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

The site is a true multi-page app: every major section is its own route
(`/`, `/about`, `/values`, `/products-services`, `/history`, `/careers`,
plus `/privacy-policy` and `/terms-and-conditions`), wrapped in a
persistent nav + footer via go_router's `ShellRoute`. The nav and footer
are built once and never rebuild on navigation — only the inner page swaps.

```
lib/
  main.dart                     # App entry point
  theme/app_theme.dart          # Colors, gradients, type scale, breakpoints
  utils/
    responsive.dart             # Responsive/ContentBounds helpers
    company_values.dart         # Data for the Values page
  widgets/
    glass_card.dart             # Core glassmorphism surface (+ GlassChip)
    skeleton_loader.dart        # Shimmer skeleton shown on first app load
    cookie_consent_banner.dart  # Floating glass consent banner + persistence
    contact_modal.dart          # Validated form + honeypot + EmailJS submit
  services/
    emailjs_service.dart        # EmailJS REST integration, dart-define config
  routing/
    app_router.dart             # go_router route table (AppRoutes, ShellRoute, 404)
    app_shell.dart              # Persistent nav + scroll area + footer
  sections/                     # One widget per content section, reused across pages
    navbar.dart                 # Persistent nav — real routes, active-state highlight
    footer_section.dart
    hero_banner_section.dart    # Home
    explore_links_section.dart  # Home — quick links into the other pages
    about_us_section.dart       # About — founder blurb + outreach photo
    motto_section.dart          # About
    mission_section.dart        # About
    vision_section.dart         # About — four pillars
    org_chart_section.dart      # About
    values_section.dart         # Values page
    products_services_section.dart  # Products & Services page
    careers_job_vacancy_section.dart # Careers page — specialization picker
  pages/
    home_page.dart
    about_page.dart
    values_page.dart
    products_services_page.dart
    careers_page.dart
    history_page.dart
    privacy_policy_page.dart
    terms_page.dart
    legal_page_scaffold.dart    # Shared title+content layout for simple pages
    not_found_page.dart         # Custom 404 (deliberately outside the shell)
web/
  index.html                     # SEO/OG/Twitter meta, favicon, analytics stub
  robots.txt
  sitemap.xml
assets/images/
  about-csce-donation.jpg       # Community outreach photo, used on /about
vercel.json
```

Each section file is a self-contained widget so multiple developers can
work in parallel without merge conflicts — content edits stay inside a
single file's `// TODO:` blocks. A page file (`lib/pages/*_page.dart`) is
just composition: it stacks one or more section widgets and adds no
content of its own, so moving a section between pages later is a one-line
change in the relevant page file plus a route/nav-link update.
