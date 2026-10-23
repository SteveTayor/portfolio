import 'package:flutter/material.dart';

import '../theme/palette.dart';
import '../theme/typography.dart';

/// Hover, focus and keyboard aware tap target. Everything clickable uses it.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.builder,
    this.onTap,
    this.label,
    this.toggled,
  });

  final Widget Function(BuildContext context, bool active) builder;
  final VoidCallback? onTap;
  final String? label;
  final bool? toggled;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _hover = false;
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return FocusableActionDetector(
      enabled: enabled,
      mouseCursor:
          enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onShowHoverHighlight: (v) => setState(() => _hover = v),
      onShowFocusHighlight: (v) => setState(() => _focus = v),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: Semantics(
        button: widget.toggled == null,
        toggled: widget.toggled,
        enabled: enabled,
        label: widget.label,
        excludeSemantics: widget.label != null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: widget.builder(context, enabled && (_hover || _focus)),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Pressable(
      label: label,
      onTap: onTap,
      builder: (context, on) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        decoration: BoxDecoration(
          color: on ? p.text : p.accent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: Typo.body(
            p,
            size: 15,
            height: 1.2,
            weight: FontWeight.w600,
            color: on ? p.bg : p.onAccent,
          ),
        ),
      ),
    );
  }
}

class TextLink extends StatelessWidget {
  const TextLink({super.key, required this.label, this.onTap, this.size = 15});

  final String label;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Pressable(
      label: label,
      onTap: onTap,
      builder: (context, on) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 160),
          style: Typo.body(
            p,
            size: size,
            height: 1.2,
            weight: FontWeight.w500,
            color: on ? p.text : p.text2,
          ).copyWith(
            decoration: on ? TextDecoration.underline : TextDecoration.none,
            decorationColor: p.accent,
            decorationThickness: 1.5,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
