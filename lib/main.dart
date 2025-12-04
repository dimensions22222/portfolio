// lib/main.dart
// Mobile-first responsive fused portfolio UI (single file).
// Add assets/hero.jpg to your project and list it in pubspec.yaml.

// ignore_for_file: unused_local_variable, prefer_const_constructors, unused_element_parameter, sort_child_properties_last, deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const ResponsivePortfolio(),
    );
  }
}

/// Mobile-first responsive landing screen.
/// Small widths => mobile layout. Wide widths => desktop-enhanced layout.
class ResponsivePortfolio extends StatefulWidget {
  const ResponsivePortfolio({super.key});

  @override
  State<ResponsivePortfolio> createState() => _ResponsivePortfolioState();
}

class _ResponsivePortfolioState extends State<ResponsivePortfolio>
    with TickerProviderStateMixin {
  // shared controllers
  late final AnimationController _bgShiftCtrl;
  late final AnimationController _particleCtrl;
  late final ScrollController _scrollController;

  // counters trigger (when scrolled)
  bool _countersTriggered = false;

  @override
  void initState() {
    super.initState();
    _bgShiftCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat(reverse: true);

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _scrollController = ScrollController()
      ..addListener(() {
        if (!_countersTriggered && _scrollController.offset > 280) {
          setState(() {
            _countersTriggered = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _bgShiftCtrl.dispose();
    _particleCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // mobile-first breakpoint
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;
    final isTablet = width >= 700 && width < 900;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _AppBarCompact(isDesktop: isDesktop),
      body: Stack(
        children: [
          // combined animated background (gradient shift + blobs + particles)
          AnimatedBuilder(
            animation: _bgShiftCtrl,
            builder: (context, _) {
              final shift = _bgShiftCtrl.value;
              return CombinedBackground(
                shiftValue: shift,
                particleValue: _particleCtrl.value,
              );
            },
          ),

          // content
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : 20,
                vertical: isDesktop ? 40 : 16,
              ),
              child: Column(
                children: [
                  // HERO
                  HeroSection(isDesktop: isDesktop),
                  const SizedBox(height: 30),

                  // On desktop, show wave divider to break sections
                  if (isDesktop) const SizedBox(height: 8),
                  if (isDesktop) const WaveDivider(),

                  // ABOUT + CTA (mobile-first)
                  AboutSection(isDesktop: isDesktop),

                  const SizedBox(height: 20),
                  const WaveDivider(),

                  // Worked with + counters (scroll triggered)
                  WorkedWithAndCounters(
                    triggerCounters: _countersTriggered,
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 28),

                  // Skills & contact
                  SkillsAndContact(isDesktop: isDesktop),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isDesktop ? null : FloatingActionButton.extended(
        label: const Text('Hire Me', style: TextStyle(color: Colors.black)),
        icon: const Icon(Icons.send, color: Colors.black),
        onPressed: () => _launchMail('hello@alex.dev'),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}

/// Compact/transparent AppBar used on all sizes.
class _AppBarCompact extends StatelessWidget implements PreferredSizeWidget {
  final bool isDesktop;
  const _AppBarCompact({required this.isDesktop, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black.withOpacity(isDesktop ? 0.35 : 0.45),
      elevation: isDesktop ? 8 : 0,
      centerTitle: true,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: const Text(
          'Alex Streamer',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
      actions: isDesktop
          ? [
              TextButton(
                onPressed: () => _launchMail('hello@alex.dev'),
                child: const Text('Contact', style: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(width: 12),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

/// HERO SECTION (mobile-first; expands on desktop)
class HeroSection extends StatelessWidget {
  final bool isDesktop;
  const HeroSection({required this.isDesktop, super.key});

  @override
  Widget build(BuildContext context) {
    final heroPic = ClipOval(
      child: SizedBox(
        width: isDesktop ? 260 : 200,
        height: isDesktop ? 260 : 200,
        child: Image.asset(
          'assets/hero.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );

    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'ALEX DEV',
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: isDesktop ? 42 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Flutter Developer • Creative Builder\n• Future Full-Stack Dev',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isDesktop ? 18 : 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          children: [
            MagneticButton(
              child: Text('Hire Me', style: TextStyle(color: Colors.black)),
              onTap: () => _launchMail('hello@alex.dev'),
              wide: isDesktop,
            ),
            ElevatedButton(
              onPressed: () => _launchUrl('https://your-cta-link.com'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: BorderSide(color: Colors.white24),
                elevation: 0,
              ),
              child: const Text('View Work'),
            ),
          ],
        ),
      ],
    );

    return Column(
      children: [
        // On desktop we arrange horizontally for a big hero,
        if (isDesktop)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: title),
              const SizedBox(width: 40),
              heroPic,
            ],
          )
        else
          Column(
            children: [
              heroPic,
              const SizedBox(height: 18),
              title,
            ],
          ),
      ],
    );
  }
}

/// Magnetic button — reacts to mouse hover on desktop; subtle scale on mobile tap
class MagneticButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool wide;
  const MagneticButton({required this.child, required this.onTap, this.wide = false, super.key});

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final box = GestureDetector(
      onTap: widget.onTap,
      child: Transform.translate(
        offset: _offset,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 12)],
          ),
          child: widget.child,
        ),
      ),
    );

    // on desktop use MouseRegion to produce little offset movement
    return MouseRegion(
      onHover: (ev) {
        final dx = (ev.localPosition.dx - 40) / 18;
        final dy = (ev.localPosition.dy - 16) / 18;
        setState(() => _offset = Offset(dx.clamp(-8, 8), dy.clamp(-8, 8)));
      },
      onExit: (_) => setState(() => _offset = Offset.zero),
      child: widget.wide
          ? SizedBox(width: 160, child: box)
          : box,
    );
  }
}

/// ABOUT section containing Tilt Card and short bio.
class AboutSection extends StatelessWidget {
  final bool isDesktop;
  const AboutSection({required this.isDesktop, super.key});

  @override
  Widget build(BuildContext context) {
    final tiltCard = TiltCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'I am a passionate Flutter developer who loves creating elegant, interactive mobile experiences. '
          'I strive for performance, beauty, and meaningful user interaction.',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SectionTitle('About Me'),
          const SizedBox(height: 12),
          tiltCard,
        ],
      ),
    );
  }
}

/// TiltCard (3D tilt on mouse movement; static touch transform on mobile)
class TiltCard extends StatefulWidget {
  final Widget child;
  const TiltCard({required this.child, super.key});

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  double rx = 0;
  double ry = 0;

  void _onHover(PointerEvent ev, BoxConstraints constraints) {
    final local = ev.localPosition;
    final cx = constraints.maxWidth / 2;
    final cy = constraints.maxHeight / 2;
    setState(() {
      rx = (local.dy - cy) / cy * 0.08;
      ry = -(local.dx - cx) / cx * 0.08;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return MouseRegion(
        onHover: (ev) => _onHover(ev, constraints),
        onExit: (_) => setState(() {
          rx = 0;
          ry = 0;
        }),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(rx)
            ..rotateY(ry),
          alignment: Alignment.center,
          child: widget.child,
        ),
      );
    });
  }
}

/// Worked-with logos & animated counters
class WorkedWithAndCounters extends StatelessWidget {
  final bool triggerCounters;
  final bool isDesktop;
  const WorkedWithAndCounters({required this.triggerCounters, required this.isDesktop, super.key});

  @override
  Widget build(BuildContext context) {
    final companies = ['ClickUp', 'Dropbox', 'PAYCHEX', 'elastic', 'stripe'];

    return Column(
      children: [
        SectionTitle('Worked With'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: companies.map((c) => CompanyTile(title: c)).toList(),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 28,
          alignment: WrapAlignment.center,
          children: [
            AnimatedStat(label: 'Years', endValue: 5, trigger: triggerCounters),
            AnimatedStat(label: 'Projects', endValue: 30, trigger: triggerCounters),
            AnimatedStat(label: 'Clients', endValue: 10, trigger: triggerCounters),
          ],
        ),
      ],
    );
  }
}

class CompanyTile extends StatelessWidget {
  final String title;
  const CompanyTile({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}


/// Animated numeric stat. Plays when `trigger` becomes true.
class AnimatedStat extends StatefulWidget {
  final String label;
  final int endValue;
  final bool trigger;
  const AnimatedStat({required this.label, required this.endValue, required this.trigger, super.key});

  @override
  State<AnimatedStat> createState() => _AnimatedStatState();
}

class _AnimatedStatState extends State<AnimatedStat> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;
  int displayed = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(seconds: 6), vsync: this);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)
      ..addListener(() {
        setState(() => displayed = (widget.endValue * _anim.value).round());
      });

    if (widget.trigger) {
      _ctrl.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedStat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$displayed+', style: const TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(widget.label, style: const TextStyle(color: Colors.black54, fontSize: 16)),
      ],
    );
  }
}

/// Skills & contact row (responsive)
class SkillsAndContact extends StatelessWidget {
  final bool isDesktop;
  const SkillsAndContact({required this.isDesktop, super.key});

  @override
  Widget build(BuildContext context) {
    final skills = ['Flutter', 'Dart', 'UI/UX', 'Firebase', 'REST APIs'];

    return Column(
      children: [
        SectionTitle('Skills'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: skills.map((s) => Chip(label: Text(s))).toList(),
        ),
        const SizedBox(height: 18),
        MagneticButton(
          wide: isDesktop,
          onTap: () => _launchMail('hello@alex.dev'),
          child: const Text('Send Email', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}

/// Section title widget
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        color: Colors.blueGrey,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Wave divider painter (small widget)
class WaveDivider extends StatelessWidget {
  const WaveDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: CustomPaint(
        painter: _WavePainter(),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.greenAccent.withOpacity(0.06);
    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Combined background that blends: moving radial gradient, soft blobs, and floating particles.
class CombinedBackground extends StatelessWidget {
  final double shiftValue;
  final double particleValue;
  const CombinedBackground({required this.shiftValue, required this.particleValue, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CombinedBgPainter(shiftValue: shiftValue, particleValue: particleValue),
      size: MediaQuery.of(context).size,
    );
  }
}

class _CombinedBgPainter extends CustomPainter {
  final double shiftValue;
  final double particleValue;
  final Random _rng = Random(12345);

  _CombinedBgPainter({required this.shiftValue, required this.particleValue});

  @override
  void paint(Canvas canvas, Size size) {
    // 1) radial gradient base
    final center = Offset(size.width * (shiftValue * 1.8 - 0.4), size.height * (0.4 - shiftValue));
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment((center.dx / size.width) * 2 - 1, (center.dy / size.height) * 2 - 1),
        radius: 1.1,
        colors: [Colors.white12, Colors.blueGrey.shade900, Colors.black],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, gradientPaint);

    // 2) soft blurred blobs
    final blobPaint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);
    blobPaint.color = Colors.greenAccent.withOpacity(0.18);
    canvas.drawCircle(Offset(size.width * 0.22, size.height * (0.22 + shiftValue * 0.12)), 200, blobPaint);

    blobPaint.color = Colors.blueAccent.withOpacity(0.12);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * (0.55 - shiftValue * 0.12)), 160, blobPaint);

    // 3) particles (deterministic-ish to avoid heavy randomness each frame)
    final particlePaint = Paint();
    final particleCount = 45;
    final rng = _rng;
    for (int i = 0; i < particleCount; i++) {
      final px = (size.width * ((i + (particleValue * 100).floor()) % particleCount) / particleCount) +
          (rng.nextDouble() * 18 - 9);
      final py = (size.height * ((i / particleCount + particleValue) % 1));
      final r = rng.nextDouble() * 2.2 + 0.6;
      particlePaint.color = Colors.white.withOpacity(0.06 + rng.nextDouble() * 0.18);
      canvas.drawCircle(Offset(px.clamp(0, size.width), py.clamp(0, size.height)), r, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CombinedBgPainter oldDelegate) =>
      oldDelegate.shiftValue != shiftValue || oldDelegate.particleValue != particleValue;
}

/// Utility functions to open external links / mail
Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    // ignore: avoid_print
    print('Could not open $url');
  }
}

Future<void> _launchMail(String toEmail) async {
  final uri = Uri(scheme: 'mailto', path: toEmail);
  if (!await launchUrl(uri)) {
    // ignore: avoid_print
    print('Could not mail to $toEmail');
  }
}
