# Ayomide Arowolo, Flutter Developer Portfolio

A premium single page portfolio built with Flutter Web. It presents my work as a Flutter mobile developer through an editorial layout, a travelling bird that follows the page scroll along a signal line, a lamp switch that reveals the contact section, a project case study carousel, and a light and dark theme that remembers the visitor's choice.

Live site: add your deployed URL here

## Highlights

* Scroll linked travelling bird and signal line that connect the sections of the page
* Interactive lamp switch that reveals and hides the contact panel, with full keyboard support
* Project carousel with arrow, keyboard and swipe navigation, plus a dedicated case study page for each project
* Light and dark themes that follow the system setting on the first visit and persist after that
* Responsive layouts for small mobile, mobile, tablet, laptop and large desktop
* Reduced motion support: animations simplify when the visitor asks for less movement
* Contact form with validation and an honest submission status

## Tech stack

* Flutter Web and Dart
* go_router for the home page and the case study routes
* Manrope for headings and Inter for body text
* A shared design token system for colour, type, spacing and motion

<!-- ## Getting started

Requirements: Flutter SDK 3.22 or newer on the stable channel, and Chrome for local development.

```bash
flutter pub get
flutter run -d chrome
```

## Quality checks

```bash
flutter analyze
flutter build web --release
```

The production build is written to `build/web`.

## Build and deploy

For static hosting such as Firebase Hosting, Netlify or Cloudflare Pages, build the release version and deploy the contents of `build/web`.

```bash
flutter build web --release
```

For GitHub Pages as a project page, set the base path to your repository name:

```bash
flutter build web --release --base-href "/your-repo-name/"
```

Before release, add `web/favicon.png` and set the canonical URL in `web/index.html` once the production domain is known.

## Configuration

Content lives in data files, so the layout never needs editing to update it.

* LinkedIn URL: `lib/core/constants/profile.dart`, field `linkedin`. The link stays hidden while the value is empty.
* Years of experience: `lib/core/constants/profile.dart`, field `experienceSinceYear`. It drives the hero metadata.
* Projects, wording and URLs: `lib/core/constants/project_data.dart`
* Contact delivery: `lib/features/home/presentation/sections/contact_section.dart`, method `_sendViaMailto` -->

### Connecting the contact form

The form currently uses a mailto fallback. On submit it opens the visitor's own mail client with the message prefilled for my address. It needs no server and no credentials, and it never shows a false success message.

To submit directly instead, replace `_sendViaMailto()` with a call to a form endpoint such as Formspree:

```dart
final response = await http.post(
  Uri.parse('https://formspree.io/f/YOUR_FORM_ID'),
  headers: {'Accept': 'application/json'},
  body: {
    'name': _name.text,
    'email': _email.text,
    'subject': _subject.text,
    'message': _message.text,
  },
);
if (response.statusCode != 200) throw StateError('send failed');
```

Add `http: ^1.2.0` to `pubspec.yaml`. Never place private API keys in client side code. Use a hosted form endpoint or a small serverless proxy instead.

## Project structure

```text
lib/
  main.dart
  app/
    app.dart                 MaterialApp.router and the theme controller
    router.dart              routes for / and /projects/:id
    theme/                   colours, type scale, ThemeData, persistence
  core/
    animation/
      signal_controller.dart scroll progress and section anchors
    constants/               profile.dart and project_data.dart
    responsive/
      responsive.dart
  features/
    home/presentation/
      pages/home_page.dart   layout, overlays and anchor measuring
      sections/              navigation, hero, about, projects, expertise,
                             experience, process, contact (lamp), footer
      widgets/               travelling_bird, signal_line, project_visual,
                             project_carousel
    projects/
      models/project.dart
      presentation/pages/project_detail_page.dart
```

## Design system

Colours (dark, then light):

* Background: `#0D1220` and `#F5F6F7`
* Surface: `#151C2B` and `#E9EDF0`
* Primary text: `#F1F3F6` and `#192332`
* Secondary text: `#A6AFBD` and `#596575`
* Accent: `#6EBEAD` and `#287F73`
* Border: `#303A4A` and `#D8DEE5`

The accent is used sparingly for primary actions, one heading emphasis, the active navigation state and key interaction indicators.

Other design rules:

* Type: Manrope and Inter, scaled fluidly across breakpoints
* Spacing: a 4 and 8 pixel scale, with a content width of up to 1240 pixels
* Motion: hover feedback 120 to 180 ms, colour changes 180 to 250 ms, reveals 250 to 450 ms, lamp and contact reveal 350 to 600 ms
* Breakpoints: under 375, 375 to 599, 600 to 899, 900 to 1199, and 1200 and above

## Accessibility

* Semantic headings in a logical order
* Visible focus states and full keyboard navigation, including the carousel and the lamp switch
* Switch semantics and state announcements for the contact light
* Reduced motion support through `MediaQuery.disableAnimations`, where the bird becomes a static mark
* The contact section is also reachable from the navigation and the footer without using the lamp

## Content accuracy

Project descriptions, roles and dates are based on my real work. No metrics, clients or outcomes have been invented. Every device mockup and diagram uses clearly labelled illustrative sample data and is not real product activity.

## Author

Ayomide Arowolo, Flutter Mobile Developer. Use the contact section of the site to get in touch.