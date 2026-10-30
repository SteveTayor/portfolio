/// Verified professional identity. Edit values here, never in the layout.
abstract final class Profile {
  static const String name = 'Ayomide Arowolo';
  static const String title = 'Flutter Developer';
  static const String experience = '4+ years';
  static const String email = 'ayomidearose75@gmail.com';
  static const String github = 'https://github.com/SteveTayor';
  static const String linkedin =
      'https://linkedin.com/in/ayomidestephen-arowolo-636bb5242';

  /// Flutter Web serves declared assets from the generated assets directory.
  /// Keep this path in sync with the actual PDF filename and pubspec.yaml.
  static const String resumeWebPath = '/assets/resume.pdf';
  static const String resumeDownloadName = 'resume.pdf';

  /// Contact form endpoint (Formspree). The id is public by design.
  static const String formEndpoint = 'https://formspree.io/f/xjygnevj';

  static const String location = 'Nigeria';

  /// Human, product-led introduction: specific without a canned "I build" line.
  static const String heroTitle = 'The little things are the whole experience.';
  static const String line =
      'A payment that makes sense. A reminder that arrives on time. A '
      'screen that stays responsive when it matters. I care about the '
      'careful engineering that makes these moments feel simple.';

  static const String closing =
      'Thoughtful software starts with understanding the problem.';
}
