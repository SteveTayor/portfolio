/// Verified professional identity. Edit values here, never in the layout.
abstract final class Profile {
  static const String name = 'Ayomide Arowolo';
  static const String title = 'Mobile Developer';
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
  static const String heroTitlePrefix = 'Mobile ';
  static const String heroTitleEmphasis = 'Developer.';
  static const String heroTitle = 'Mobile Developer.';
  static const String line =
      'Payments, identity verification and real-time communication '
      'are only as reliable as the systems behind them. My work has '
      'included authentication, KYC liveness checks to help deter '
      'identity fraud, and service integrations that keep mobile '
      'experiences dependable.';
  static const String closing =
      'Thoughtful software starts with understanding the problem.';
}
