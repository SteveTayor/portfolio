import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../core/content/story.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/reveal.dart';
import '../../../core/widgets/section.dart';

class TechnologiesSection extends StatelessWidget {
  const TechnologiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return LayoutBuilder(
      builder: (context, c) {
        final mobile = c.maxWidth < Bp.mobile;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: mobile ? 80 : 128),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Frame(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SectionHead(
                    label: 'Technologies',
                    title: 'The tools behind the interface.',
                    body: 'What I reach for, grouped by the job it does.',
                  ),
                ),
              ),
              const SizedBox(height: 64),
              _Band(words: Story.bandOne, size: mobile ? 56 : 104, reverse: false),
              _Band(words: Story.bandTwo, size: mobile ? 56 : 104, reverse: true, quiet: true),
              const SizedBox(height: 72),
              Frame(
                child: Column(
                  children: [
                    for (final n in Story.expertise)
                      Reveal(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: p.border)),
                          ),
                          child: LayoutBuilder(
                            builder: (context, cc) {
                              final stacked = cc.maxWidth < 900;
                              final title = Text(n.title,
                                  style: Typo.display(p, stacked ? 36 : 44));
                              final body = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.body,
                                      style: Typo.body(p, size: 17, height: 1.5)),
                                  const SizedBox(height: 20),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      for (final t in n.tags) _Tag(t),
                                    ],
                                  ),
                                ],
                              );
                              if (stacked) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [title, const SizedBox(height: 18), body],
                                );
                              }
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 5, child: title),
                                  const SizedBox(width: 48),
                                  Expanded(flex: 6, child: body),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    const Hairline(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Typo.body(p, size: 14, height: 1.2, color: p.text2)),
    );
  }
}

/// A slow, endless band of large words. Two of them drift in opposite
/// directions. It stands still when the visitor prefers reduced motion.
class _Band extends StatefulWidget {
  const _Band({
    required this.words,
    required this.size,
    required this.reverse,
    this.quiet = false,
  });

  final List<String> words;
  final double size;
  final bool reverse;
  final bool quiet;

  @override
  State<_Band> createState() => _BandState();
}

class _BandState extends State<_Band> with SingleTickerProviderStateMixin {
  final ScrollController _c = ScrollController();
  Ticker? _ticker;
  double _offset = 0;
  Duration _last = Duration.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced) {
      _ticker?.dispose();
      _ticker = null;
    } else {
      _ticker ??= createTicker(_tick)..start();
    }
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1000000;
    _last = elapsed;
    if (!_c.hasClients || !_c.position.hasContentDimensions) return;
    _offset += dt * 34;
    _c.jumpTo(_offset);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return ExcludeSemantics(
      child: SizedBox(
        height: widget.size * 1.3,
        child: ListView.builder(
          controller: _c,
          scrollDirection: Axis.horizontal,
          reverse: widget.reverse,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            final word = widget.words[i % widget.words.length];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    word,
                    style: Typo.display(
                      p,
                      widget.size,
                      height: 1.2,
                      color: widget.quiet ? p.muted : p.text,
                      style: widget.quiet ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                  const SizedBox(width: 60),
                  Container(width: 1, height: widget.size * 0.5, color: p.border),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
