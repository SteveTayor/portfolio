/// Central, verified professional identity. Update values here only.
class Profile {
  static const String name = 'Ayomide Arowolo';
  static const String wordmark = 'A. AROWOLO';
  static const String title = 'Flutter Mobile Developer';
  static const String email = 'ayomidearose75@gmail.com';
  static const String github = 'https://github.com/SteveTayor';

  // TODO(ayomide): insert verified LinkedIn URL to reveal the link.
  static const String linkedin = '';

  static const String location = 'Nigeria';
  static const String resumeAsset = 'assets/resume.pdf';

  /// Professional Flutter experience since February 2022 (per CV).
  /// Used for the hero metadata line.
  static const int experienceSinceYear = 2022;

  static int get yearsExperience {
    final now = DateTime.now().year;
    return now - experienceSinceYear;
  }
}
