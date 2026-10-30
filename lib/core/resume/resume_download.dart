import 'resume_download_stub.dart'
    if (dart.library.html) 'resume_download_web.dart' as platform;

/// Starts a browser download on Flutter Web. Other platforms return false.
bool downloadResume() => platform.downloadResume();
