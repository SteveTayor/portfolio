// This file is selected only by the Flutter Web conditional import.
// ignore_for_file: deprecated_member_use
import 'dart:html' as html;

import '../content/profile.dart';

bool downloadResume() {
  try {
    final uri = Uri.base.resolve(Profile.resumeWebPath).toString();
    final anchor = html.AnchorElement(href: uri)
      ..download = Profile.resumeDownloadName
      ..style.display = 'none';
    html.document.body?.children.add(anchor);
    anchor.click();
    anchor.remove();
    return true;
  } catch (_) {
    return false;
  }
}
