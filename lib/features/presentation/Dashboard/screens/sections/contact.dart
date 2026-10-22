import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/profile.dart';
import '../../../../../core/responsive/responsive.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';

enum ContactFormStatus { idle, submitting, sent, failed }

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _lampOn = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      color: c.bgSecondary,
      padding: EdgeInsets.symmetric(
        vertical: Responsive.sectionSpacing(context),
        horizontal: Responsive.sidePadding(context),
      ),
      child: Center(
        child: SizedBox(
          width: Responsive.contentWidth(context),
          child: Column(
            children: [
              Text(
                'Have a problem worth solving?',
                style: AppTextStyles.sectionTitle(context, c.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(
                  "If you're looking for a Flutter developer to build a "
                  'feature, improve an existing application, or discuss a '
                  'product idea, let\'s start a conversation.',
                  style: AppTextStyles.body(context, c.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              LampSwitch(
                on: _lampOn,
                onChanged: (v) => setState(() => _lampOn = v),
              ),
              const SizedBox(height: 28),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 450),
                crossFadeState: _lampOn
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: const ContactPanel(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom, accessible lamp + switch assembly. The lamp illuminates when
/// the switch is on; neutral soft-white light only.
class LampSwitch extends StatelessWidget {
  final bool on;
  final ValueChanged<bool> onChanged;
  const LampSwitch({super.key, required this.on, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Semantics(
      toggled: on,
      label: on
          ? 'Switch off the lamp to hide the contact panel'
          : 'Switch on the lamp to reveal the contact panel',
      child: InkWell(
        onTap: () => onChanged(!on),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(150, 190),
              painter: _LampPainter(colors: c, on: on),
            ),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              width: 74,
              height: 34,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: c.bgSecondary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: on ? c.accentTeal : c.border,
                  width: on ? 1.4 : 1,
                ),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                alignment: on ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: on ? c.accentTeal : c.border,
                  ),
                  child: Icon(
                    on ? Icons.wb_incandescent : Icons.lightbulb_outline,
                    size: 14,
                    color: on ? c.bg : c.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              on ? 'ON' : 'OFF',
              style: AppTextStyles.meta(on ? c.accentTeal : c.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _LampPainter extends CustomPainter {
  final AppColors colors;
  final bool on;
  _LampPainter({required this.colors, required this.on});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = on ? colors.accentTeal : colors.textMuted
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    // Light pool (soft, neutral white  never gold/amber).
    if (on) {
      final pool = Rect.fromCenter(
        center: Offset(w / 2, h * 0.30),
        width: w * 0.9,
        height: h * 0.42,
      );
      canvas.drawOval(
        pool,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withOpacity(0.28),
              Colors.white.withOpacity(0.0),
            ],
          ).createShader(pool),
      );
    }

    // Shade.
    final shade = Path()
      ..moveTo(w * 0.30, h * 0.22)
      ..lineTo(w * 0.70, h * 0.22)
      ..lineTo(w * 0.80, h * 0.40)
      ..lineTo(w * 0.20, h * 0.40)
      ..close();
    canvas.drawPath(
      shade,
      Paint()
        ..color = on
            ? colors.accentTeal.withOpacity(0.18)
            : colors.bg.withOpacity(0.0)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(shade, stroke);

    // Bulb glow.
    if (on) {
      canvas.drawCircle(
        Offset(w / 2, h * 0.44),
        4,
        Paint()..color = Colors.white.withOpacity(0.9),
      );
    } else {
      canvas.drawCircle(
        Offset(w / 2, h * 0.44),
        3,
        Paint()..color = colors.textMuted,
      );
    }

    // Stem.
    canvas.drawLine(Offset(w / 2, h * 0.40), Offset(w / 2, h * 0.86), stroke);
    // Base.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.32, h * 0.86)
        ..lineTo(w * 0.68, h * 0.86)
        ..lineTo(w * 0.74, h * 0.94)
        ..lineTo(w * 0.26, h * 0.94)
        ..close(),
      stroke,
    );
    // Cord from base to the signal line.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.26, h * 0.94)
        ..quadraticBezierTo(w * 0.05, h * 0.99, -20, h * 0.99),
      stroke..strokeWidth = 1.1,
    );
  }

  @override
  bool shouldRepaint(_LampPainter old) => old.on != on || old.colors != colors;
}

class ContactPanel extends StatefulWidget {
  const ContactPanel({super.key});

  @override
  State<ContactPanel> createState() => _ContactPanelState();
}

class _ContactPanelState extends State<ContactPanel> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  ContactFormStatus _status = ContactFormStatus.idle;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _status = ContactFormStatus.submitting);
    try {
      // Default delivery: opens the visitor's mail client with the message
      // prefilled  no server, no credentials. Replace `_sendViaMailto`
      // with a real service (Formspree, EmailJS, custom backend) to get
      // direct submission; see README section "Connecting the contact form".
      await _sendViaMailto();
      if (mounted) setState(() => _status = ContactFormStatus.sent);
    } catch (_) {
      if (mounted) setState(() => _status = ContactFormStatus.failed);
    }
  }

  Future<void> _sendViaMailto() async {
    final body =
        'Name: ${_name.text}'
        'Email: ${_email.text}'
        '${_message.text}';
    final uri = Uri(
      scheme: 'mailto',
      path: Profile.email,
      query:
          'subject=${Uri.encodeComponent(_subject.text.isEmpty ? 'Portfolio inquiry  ${_name.text}' : _subject.text)}'
          '&body=${Uri.encodeComponent(body)}',
    );
    final ok = await launchUrl(uri);
    if (!ok) throw StateError('Could not open mail client');
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final mobile = Responsive.isMobile(context);
    final submitting = _status == ContactFormStatus.submitting;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.of(context).surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's make something useful.",
            style: AppTextStyles.projectTitle(context, c.textPrimary),
          ),
          const SizedBox(height: 10),
          Text(
            'Tell me about the project, the role, or the problem  I read '
            'every message.',
            style: AppTextStyles.body(context, c.textSecondary),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => launchUrl(Uri(scheme: 'mailto', path: Profile.email)),
            child: Text(
              Profile.email,
              style: AppTextStyles.button(c.accentTeal),
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _Field(
                        controller: _name,
                        label: 'Name',
                        required: true,
                      ),
                    ),
                    SizedBox(width: mobile ? 0 : 16),
                    if (!mobile)
                      Expanded(
                        child: _Field(
                          controller: _email,
                          label: 'Email address',
                          required: true,
                          email: true,
                        ),
                      ),
                  ],
                ),
                if (mobile) ...[
                  const SizedBox(height: 16),
                  _Field(
                    controller: _email,
                    label: 'Email address',
                    required: true,
                    email: true,
                  ),
                ],
                const SizedBox(height: 16),
                _Field(controller: _subject, label: 'Subject (optional)'),
                const SizedBox(height: 16),
                _Field(
                  controller: _message,
                  label: 'Message',
                  required: true,
                  maxLines: 5,
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: submitting ? null : _submit,
                      child: submitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Send message'),
                    ),
                    if (_status == ContactFormStatus.sent) ...[
                      const SizedBox(width: 14),
                      Icon(
                        Icons.check_circle_outline,
                        size: 17,
                        color: c.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Your mail client should open with the message.',
                        style: AppTextStyles.body(
                          context,
                          c.success,
                        ).copyWith(fontSize: 13),
                      ),
                    ],
                    if (_status == ContactFormStatus.failed) ...[
                      const SizedBox(width: 14),
                      Icon(Icons.error_outline, size: 17, color: c.error),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Could not open your mail client. Email me directly at ${Profile.email}.',
                          style: AppTextStyles.body(
                            context,
                            c.error,
                          ).copyWith(fontSize: 13),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 22,
                  runSpacing: 10,
                  children: [
                    _ProfileLink(label: 'GitHub', url: Profile.github),
                    if (Profile.linkedin.isNotEmpty)
                      _ProfileLink(label: 'LinkedIn', url: Profile.linkedin),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool required;
  final bool email;
  final int maxLines;
  const _Field({
    required this.controller,
    required this.label,
    this.required = false,
    this.email = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        alignLabelWithHint: true,
      ),
      validator: (value) {
        final v = value?.trim() ?? '';
        if (required && v.isEmpty) return '$label is required';
        if (email && v.isNotEmpty && !v.contains('@')) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }
}

class _ProfileLink extends StatelessWidget {
  final String label;
  final String url;
  const _ProfileLink({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return InkWell(
      onTap: () =>
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.button(c.accentTeal)),
            const SizedBox(width: 4),
            Icon(Icons.open_in_new, size: 13, color: c.accentTeal),
          ],
        ),
      ),
    );
  }
}
