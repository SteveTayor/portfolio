import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../core/content/profile.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/links.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/reveal.dart';
import '../../../core/widgets/stage.dart';
import 'footer_section.dart';

/// Contact and footer share one dark stage. The lamp lights the form: with the
/// lamp off the form sits in the dark and cannot be used, with it on the form
/// is lit. The email address and links are always available.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.onNav});

  final ValueChanged<int> onNav;

  @override
  Widget build(BuildContext context) {
    return StageBlock(
      child: Column(
        children: [
          const _ContactBody(),
          FooterSection(onNav: onNav),
        ],
      ),
    );
  }
}

class _ContactBody extends StatefulWidget {
  const _ContactBody();

  @override
  State<_ContactBody> createState() => _ContactBodyState();
}

class _ContactBodyState extends State<_ContactBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _light = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  // Controllers live here so a draft survives the lamp being switched off.
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _message = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool _on = false;
  bool _sending = false;
  bool _sent = false;
  String? _error;
  String? _note;

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

  String? _validEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Please enter your email address.';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : 'That email address does not look right.';
  }

  Future<void> _send() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final res = await http
          .post(
            Uri.parse(Profile.formEndpoint),
            headers: const {'Accept': 'application/json'},
            body: {
              'name': _name.text.trim(),
              'email': _email.text.trim(),
              'message': _message.text.trim(),
              '_subject': 'Portfolio message from ${_name.text.trim()}',
            },
          )
          .timeout(const Duration(seconds: 20));
      if (!mounted) return;
      if (res.statusCode >= 200 && res.statusCode < 300) {
        _name.clear();
        _email.clear();
        _message.clear();
        setState(() {
          _sending = false;
          _sent = true;
        });
        return;
      }
      var msg = 'The message could not be sent. Please try again, or write '
          'to ${Profile.email}.';
      try {
        final data = jsonDecode(res.body);
        final errors = data is Map ? data['errors'] : null;
        if (errors is List && errors.isNotEmpty && errors.first is Map) {
          final m = (errors.first as Map)['message'];
          if (m is String && m.isNotEmpty) msg = m;
        }
      } catch (_) {}
      setState(() {
        _sending = false;
        _error = msg;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _error = 'There was no connection. Please try again, or write to '
            '${Profile.email}.';
      });
    }
  }

  Future<void> _copy() async {
    await Clipboard.setData(const ClipboardData(text: Profile.email));
    if (!mounted) return;
    setState(() => _note = 'Email address copied.');
  }

  InputDecoration _field(Palette p, String label) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      labelText: label,
      labelStyle: Typo.label(p, size: 14),
      floatingLabelStyle: Typo.label(p, size: 14, color: p.accent),
      errorStyle: Typo.label(p, size: 12, color: p.text),
      filled: true,
      fillColor: p.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      enabledBorder: border(p.border),
      focusedBorder: border(p.accent, 1.5),
      errorBorder: border(p.text2),
      focusedErrorBorder: border(p.accent, 1.5),
    );
  }

  Widget _card(Palette p, bool stacked) {
    final style = Typo.body(p, size: 16, color: p.text, height: 1.3);
    final nameField = TextFormField(
      controller: _name,
      style: style,
      cursorColor: p.accent,
      textInputAction: TextInputAction.next,
      decoration: _field(p, 'Name'),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Please enter your name.' : null,
    );
    final emailField = TextFormField(
      controller: _email,
      style: style,
      cursorColor: p.accent,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: _field(p, 'Email address'),
      validator: _validEmail,
    );
    final fields = Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stacked) ...[
            nameField,
            const SizedBox(height: 16),
            emailField,
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: nameField),
                const SizedBox(width: 16),
                Expanded(child: emailField),
              ],
            ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _message,
            style: style,
            cursorColor: p.accent,
            minLines: 4,
            maxLines: 8,
            decoration: _field(p, 'What would you like to build?'),
            validator: (v) => (v == null || v.trim().length < 10)
                ? 'Please write a few words about the project.'
                : null,
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              PrimaryButton(
                label: _sending ? 'Sending' : 'Send message',
                onTap: _sending ? null : _send,
              ),
              if (_error != null) ...[
                const SizedBox(width: 18),
                Expanded(
                  child: Semantics(
                    liveRegion: true,
                    child: Text(_error!,
                        style: Typo.body(p, size: 13, color: p.text, height: 1.35)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );

    final thanks = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          liveRegion: true,
          child: Text('Message sent.', style: Typo.display(p, 44)),
        ),
        const SizedBox(height: 12),
        Text(
          'Thank you. I will reply to the address you gave.',
          style: Typo.body(p, size: 16, height: 1.45),
        ),
        const SizedBox(height: 14),
        TextLink(
          label: 'Write another message',
          onTap: () => setState(() => _sent = false),
        ),
      ],
    );

    return AnimatedBuilder(
      animation: _light,
      builder: (context, _) {
        final lit = Curves.easeOut.transform(_light.value);
        return Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(stacked ? 22 : 32),
              decoration: BoxDecoration(
                color: p.raised.withAlpha(120 + (lit * 120).round()),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Color.lerp(p.border, p.accent, lit * 0.5)!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _on ? 'Write to me' : 'Switch on the lamp to write a message',
                    style: Typo.label(p, size: 14, color: _on ? p.accent : p.muted),
                  ),
                  const SizedBox(height: 22),
                  ExcludeFocus(
                    excluding: !_on,
                    child: IgnorePointer(
                      ignoring: !_on,
                      child: Opacity(
                        opacity: 0.2 + 0.8 * lit,
                        child: _sent ? thanks : fields,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Light falling across the card from the lamp side.
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: RadialGradient(
                      center: const Alignment(-1.1, -1.2),
                      radius: 1.3,
                      colors: [
                        const Color(0xFFF2F4EE).withAlpha((lit * 26).round()),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return LayoutBuilder(
      builder: (context, c) {
        final stacked = c.maxWidth < 900;
        final mobile = c.maxWidth < Bp.mobile;

        final lamp = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _light,
              builder: (context, _) => CustomPaint(
                size: Size(stacked ? 300 : 400, stacked ? 400 : 540),
                painter: _LampPainter(p, Curves.easeOut.transform(_light.value)),
              ),
            ),
            const SizedBox(height: 8),
            Pressable(
              label: 'Contact lamp',
              toggled: _on,
              onTap: _toggle,
              builder: (context, hot) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    width: 68,
                    height: 36,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _on ? p.accent.withAlpha(60) : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: (hot || _on) ? p.accent : p.border,
                        width: 1.5,
                      ),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutBack,
                      alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _on ? p.accent : p.muted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    _on ? 'Lamp on' : 'Switch on the lamp',
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
                  Text('Contact', style: Typo.label(p, color: p.accent, size: 14)),
                  const SizedBox(height: 18),
                  Text(
                    'Have a project in mind?',
                    style: Typo.display(p, mobile ? 52 : 84, height: 0.98),
                  ),
                  const SizedBox(height: 26),
                  Pressable(
                    label: 'Email ${Profile.email}',
                    onTap: () => openExternal('mailto:${Profile.email}'),
                    builder: (context, on) => AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: Typo.display(
                        p,
                        mobile ? 24 : 38,
                        height: 1.1,
                        color: on ? p.accent : p.text,
                        style: FontStyle.italic,
                      ).copyWith(
                        decoration: on ? TextDecoration.underline : TextDecoration.none,
                        decorationColor: p.accent,
                      ),
                      child: Text(Profile.email),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 26,
                    runSpacing: 2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TextLink(label: 'Copy email', onTap: _copy),
                      TextLink(label: 'GitHub', onTap: () => openExternal(Profile.github)),
                      if (Profile.linkedin.isNotEmpty)
                        TextLink(label: 'LinkedIn', onTap: () => openExternal(Profile.linkedin)),
                      if (_note != null)
                        Text(_note!, style: Typo.label(p, size: 13, color: p.accent)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            _card(p, mobile),
          ],
        );

        return Padding(
          padding: EdgeInsets.fromLTRB(
            Bp.pad(c.maxWidth),
            mobile ? 72 : 112,
            Bp.pad(c.maxWidth),
            mobile ? 56 : 80,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Bp.maxContent),
              child: stacked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [words, const SizedBox(height: 56), Center(child: lamp)],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: Center(child: lamp)),
                        const SizedBox(width: 56),
                        Expanded(flex: 7, child: words),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

/// A desk lamp drawn with curves, soft metal and blurred light. The light is a
/// neutral soft white, never warm or golden.
class _LampPainter extends CustomPainter {
  const _LampPainter(this.p, this.on);

  final Palette p;
  final double on;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 400;
    canvas.scale(s, s);
    final w = 400.0;
    final h = size.height / s;
    final cx = w / 2;
    final floor = h - 70;
    const light = Color(0xFFF2F4EE);

    // Contact shadow and base.
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, floor + 6), width: 190, height: 26),
      Paint()
        ..color = const Color(0xAA000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Light on the desk: a wide soft pool and a blurred cone.
    if (on > 0) {
      final pool = Rect.fromCenter(center: Offset(cx, floor + 4), width: 380, height: 70);
      canvas.drawOval(
        pool,
        Paint()
          ..shader = RadialGradient(colors: [
            light.withAlpha((on * 70).round()),
            light.withAlpha(0),
          ]).createShader(pool),
      );
      final cone = Path()
        ..moveTo(cx - 78, 205)
        ..lineTo(cx + 78, 205)
        ..lineTo(cx + 190, floor)
        ..lineTo(cx - 190, floor)
        ..close();
      final coneBox = Rect.fromLTRB(cx - 190, 205, cx + 190, floor);
      canvas.drawPath(
        cone,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [light.withAlpha((on * 64).round()), light.withAlpha(0)],
          ).createShader(coneBox)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
      );
    }

    // Base disc with a soft highlight.
    final base = Rect.fromCenter(center: Offset(cx, floor), width: 150, height: 20);
    canvas.drawOval(
      base,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF2C312C), Color(0xFF5A615A), Color(0xFF232823)],
        ).createShader(base),
    );

    // Arm: one curved sweep, then a second short bend into the shade.
    final arm = Path()
      ..moveTo(cx, floor - 6)
      ..cubicTo(cx - 118, floor - 80, cx - 96, 300, cx - 18, 238)
      ..cubicTo(cx + 12, 214, cx + 6, 196, cx, 178);
    canvas.drawPath(
      arm,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF3B413B),
    );
    canvas.drawPath(
      arm,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF7B837B).withAlpha(150),
    );

    // Shade: a rounded dome with a soft metal gradient.
    final dome = Path()
      ..moveTo(cx - 86, 205)
      ..cubicTo(cx - 80, 130, cx - 40, 112, cx, 112)
      ..cubicTo(cx + 40, 112, cx + 80, 130, cx + 86, 205)
      ..quadraticBezierTo(cx, 218, cx - 86, 205)
      ..close();
    final domeBox = Rect.fromLTRB(cx - 90, 108, cx + 90, 220);
    canvas.drawPath(
      dome,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF1E231E), Color(0xFF4C534C), Color(0xFF181C18)],
          stops: [0.0, 0.42, 1.0],
        ).createShader(domeBox),
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx - 60, 150)
        ..quadraticBezierTo(cx - 20, 124, cx + 10, 124),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFFB5BCB5).withAlpha(70),
    );

    // The lit opening and a soft halo around it.
    if (on > 0) {
      final mouth = Rect.fromCenter(center: Offset(cx, 208), width: 150, height: 16);
      canvas.drawOval(
        mouth.inflate(14),
        Paint()
          ..color = light.withAlpha((on * 90).round())
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
      );
      canvas.drawOval(mouth, Paint()..color = light.withAlpha((on * 255).round()));
    } else {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, 208), width: 150, height: 16),
        Paint()..color = const Color(0xFF0E110E),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LampPainter old) => old.on != on;
}
