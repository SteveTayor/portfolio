import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/content/profile.dart';
import '../../../core/links.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/reveal.dart';
import '../../../core/widgets/section.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _light = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  // Controllers live here, not in the form, so a draft survives the lamp
  // being switched off.
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _message = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool _on = false;
  bool _busy = false;
  String? _status;

  @override
  void dispose() {
    _light.dispose();
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _on = !_on);
    if (_on) {
      _light.forward();
    } else {
      _light.reverse();
    }
  }

  String? _required(String? v, String what) =>
      (v == null || v.trim().isEmpty) ? 'Please enter $what.' : null;

  String? _validEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Please enter your email address.';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : 'That email address does not look right.';
  }

  Future<void> _send() async {
    if (!(_form.currentState?.validate() ?? false)) {
      setState(() => _status = 'Please complete the highlighted fields.');
      return;
    }
    setState(() {
      _busy = true;
      _status = null;
    });
    final subject = 'Portfolio enquiry from ${_name.text.trim()}';
    final body = '${_message.text.trim()}\n\n'
        'From: ${_name.text.trim()} (${_email.text.trim()})';
    final url = 'mailto:${Profile.email}'
        '?subject=${Uri.encodeComponent(subject)}'
        '&body=${Uri.encodeComponent(body)}';
    final ok = await openExternal(url);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _status = ok
          ? 'Your email app should now open with the message ready to send.'
          : 'No email app could be opened. Copy my address below and write to me directly.';
    });
  }

  Future<void> _copy() async {
    await Clipboard.setData(const ClipboardData(text: Profile.email));
    if (!mounted) return;
    setState(() => _status = 'Email address copied.');
  }

  InputDecoration _decoration(Palette p, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: Typo.label(p, size: 14),
      floatingLabelStyle: Typo.label(p, size: 14, color: p.accent),
      errorStyle: Typo.label(p, size: 12, color: p.text),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.border)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.accent)),
      errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.text2)),
      focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.accent)),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  Widget _formBody(Palette p) {
    final style = Typo.body(p, size: 16, color: p.text);
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 36),
          TextFormField(
            controller: _name,
            style: style,
            cursorColor: p.accent,
            textInputAction: TextInputAction.next,
            decoration: _decoration(p, 'Name'),
            validator: (v) => _required(v, 'your name'),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _email,
            style: style,
            cursorColor: p.accent,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: _decoration(p, 'Email address'),
            validator: _validEmail,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _message,
            style: style,
            cursorColor: p.accent,
            minLines: 3,
            maxLines: 6,
            decoration: _decoration(p, 'What would you like to build?'),
            validator: (v) => (v == null || v.trim().length < 10)
                ? 'Please write a few words about the project.'
                : null,
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: _busy ? 'Opening' : 'Send message',
            onTap: _busy ? null : _send,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Section(
      color: p.surface,
      child: LayoutBuilder(
        builder: (context, c) {
          final stacked = c.maxWidth < 900;

          final lamp = Column(
            children: [
              AnimatedBuilder(
                animation: _light,
                builder: (context, _) => CustomPaint(
                  size: const Size(360, 400),
                  painter: _LampPainter(p, Curves.easeOut.transform(_light.value)),
                ),
              ),
              const SizedBox(height: 12),
              Pressable(
                label: 'Contact light',
                toggled: _on,
                onTap: _toggle,
                builder: (context, hot) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      width: 64,
                      height: 34,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _on ? p.accent.withAlpha(60) : Colors.transparent,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          color: (hot || _on) ? p.accent : p.border,
                          width: 1.5,
                        ),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOut,
                        alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _on ? p.accent : p.muted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      _on ? 'Light on' : 'Turn on the light',
                      style: Typo.body(p, size: 15, height: 1.2, color: p.text),
                    ),
                  ],
                ),
              ),
            ],
          );

          final words = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reveal(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact',
                        style: Typo.label(p, color: p.accent, size: 14)),
                    const SizedBox(height: 18),
                    Text(
                      'Have a project in mind?',
                      style: Typo.display(p, stacked ? 48 : 72, height: 1.0),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Text(
                        'If you need a Flutter developer to build a feature, '
                        'improve an existing application or talk through a '
                        'product idea, I would like to hear about it.',
                        style: Typo.body(p, size: 17),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 28,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TextLink(
                          label: Profile.email,
                          onTap: () => openExternal('mailto:${Profile.email}'),
                        ),
                        TextLink(label: 'Copy email', onTap: _copy),
                        TextLink(
                          label: 'GitHub',
                          onTap: () => openExternal(Profile.github),
                        ),
                        if (Profile.linkedin.isNotEmpty)
                          TextLink(
                            label: 'LinkedIn',
                            onTap: () => openExternal(Profile.linkedin),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 480),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: _on
                    ? ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: _formBody(p),
                      )
                    : const SizedBox(width: double.infinity),
              ),
              if (_status != null) ...[
                const SizedBox(height: 18),
                Semantics(
                  liveRegion: true,
                  child: Text(_status!, style: Typo.body(p, size: 14, color: p.text)),
                ),
              ],
            ],
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                words,
                const SizedBox(height: 56),
                Center(child: lamp),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: Center(child: lamp)),
              const SizedBox(width: 56),
              Expanded(flex: 6, child: words),
            ],
          );
        },
      ),
    );
  }
}

/// A desk lamp. Its light is a neutral soft white, never warm or golden.
class _LampPainter extends CustomPainter {
  const _LampPainter(this.p, this.on);

  final Palette p;
  final double on;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final floor = size.height - 40;

    if (on > 0) {
      final cone = Path()
        ..moveTo(cx - 60, 150)
        ..lineTo(cx + 60, 150)
        ..lineTo(cx + 175, floor)
        ..lineTo(cx - 175, floor)
        ..close();
      final tint = p.isDark ? const Color(0xFFEDEFE7) : const Color(0xFFFFFFFF);
      canvas.drawPath(
        cone,
        Paint()..color = tint.withAlpha((on * (p.isDark ? 30 : 200)).round()),
      );
    }

    canvas.drawLine(
      Offset(cx, 0),
      Offset(cx, 70),
      Paint()
        ..color = p.accent.withAlpha(120 + (on * 135).round())
        ..strokeWidth = 1.5,
    );

    final shade = Path()
      ..moveTo(cx - 52, 70)
      ..lineTo(cx + 52, 70)
      ..lineTo(cx + 86, 150)
      ..lineTo(cx - 86, 150)
      ..close();
    canvas.drawPath(
      shade,
      Paint()..color = p.isDark ? const Color(0xFF2A302B) : const Color(0xFF333832),
    );

    final glow = (on * 255).round();
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, 150), width: 150, height: 12),
      Paint()..color = const Color(0xFFF4F5EF).withAlpha(glow),
    );

    canvas.drawLine(
      Offset(cx, 150),
      Offset(cx, floor - 8),
      Paint()
        ..color = Palette.silverEdge
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, floor - 2), width: 96, height: 12),
        const Radius.circular(6),
      ),
      Paint()..color = Palette.silver,
    );
  }

  @override
  bool shouldRepaint(covariant _LampPainter old) =>
      old.on != on || old.p != p;
}
