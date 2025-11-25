// ignore_for_file: unused_import, deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';

import 'port.dart' show PortfolioLandingPage;

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // ✨ Floating Glass Navbar
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
              )
            ],
          ),
          child: const Text(
            "Alex Streamer",
            style: TextStyle(
                fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      body: Stack(
        children: [
          // 🌌 Animated soft glowing background blobs
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, _) {
              return CustomPaint(
                painter: BlobPainter(_bgController.value),
                size: MediaQuery.of(context).size,
              );
            },
          ),

          // 📜 Scrollable main content
          ListView(
            controller: _scrollController,
            children: [
              _buildHeroSection(context),
              _buildWaveDivider(),
              _buildAboutSection(),
              _buildWaveDivider(),
              _buildSkillsSection(),
              _buildWaveDivider(),
              _buildContactSection(),
            ],
          ),
        ],
      ),
    );
  }

  // 🌄 Parallax + Fade Hero
  Widget _buildHeroSection(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) {
                double offset = (_scrollController.offset * 0.3);
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: child,
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/hero.jpg"),
                    fit: BoxFit.cover,
                    opacity: 0.8,
                  ),
                ),
              ),
            ),
          ),

          // Text & CTA
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _fadeUp(
                  delay: 1.0,
                  child: const Text(
                    "Hi, I'm Alex",
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 320),
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blueGrey, // 🔵 button color
    foregroundColor: Colors.white,    // text color
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PortfolioLandingPage()),
    );
  },
child: const Text(
                      "Hire Me ",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),),
                const SizedBox(height: 16),
                
              ],
            ),
          )
        ],
      ),
    );
  }

  // 🌊 Animated wavy divider
  Widget _buildWaveDivider() {
    return SizedBox(
      height: 90,
      child: CustomPaint(
        painter: WavePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }

  // 👤 About section with tilt cards
  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _sectionTitle("About Me"),
          const SizedBox(height: 20),
          _TiltCard(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "I am a passionate Flutter developer who loves creating elegant, "
                "interactive mobile experiences. I strive for performance, beauty, "
                "and meaningful user interaction.",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🛠 Skills with animated counters
  Widget _buildSkillsSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _sectionTitle("Skills"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _AnimatedCounter(label: "Projects", value: 32),
              _AnimatedCounter(label: "Clients", value: 14),
              _AnimatedCounter(label: "Years", value: 3),
            ],
          )
        ],
      ),
    );
  }

  // 📞 Contact
  Widget _buildContactSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _sectionTitle("Contact"),
          const SizedBox(height: 20),
          _MagneticButton(
            child: const Text(
              "Send Email",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  // 🔥 Fade up reusable animation
  Widget _fadeUp({required double delay, required Widget child}) {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 7),
      curve: Curves.easeOut,
      tween: Tween<double>(begin: 40, end: 0),
      child: child,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: Opacity(
            opacity: (1 - value / 40).clamp(0, 1),
            child: child,
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 28, color: Colors.blueGrey, fontWeight: FontWeight.bold),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                           🎨  CUSTOM PAINTERS                               */
/* -------------------------------------------------------------------------- */

// glowing background blobs
class BlobPainter extends CustomPainter {
  final double value;
  BlobPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);

    paint.color = Colors.greenAccent.withOpacity(0.3);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * (0.2 + value * 0.1)), 180, paint);

    paint.color = Colors.blueAccent.withOpacity(0.25);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * (0.5 - value * 0.1)), 150, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// wave divider
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * 0.75, 0, size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/* -------------------------------------------------------------------------- */
/*                             🧲 Magnetic Button                              */
/* -------------------------------------------------------------------------- */

class _MagneticButton extends StatefulWidget {
  final Widget child;
  const _MagneticButton({required this.child});

  @override
  State<_MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<_MagneticButton> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          offset = Offset((event.localPosition.dx - 50) / 12,
              (event.localPosition.dy - 20) / 12);
        });
      },
      onExit: (_) {
        setState(() => offset = Offset.zero);
      },
      child: Transform.translate(
        offset: offset,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black38, blurRadius: 12)
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                             🎚 3D Tilt Card                                 */
/* -------------------------------------------------------------------------- */

class _TiltCard extends StatefulWidget {
  final Widget child;
  const _TiltCard({required this.child});

  @override
  State<_TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<_TiltCard> {
  double x = 0;
  double y = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final size = context.size!;
        setState(() {
          x = (event.localPosition.dy - size.height / 2) / 40;
          y = -(event.localPosition.dx - size.width / 2) / 40;
        });
      },
      onExit: (_) => setState(() {
        x = 0;
        y = 0;
      }),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(x * 0.2)
          ..rotateY(y * 0.2),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                          🔢 Animated Number Counter                         */
/* -------------------------------------------------------------------------- */

class _AnimatedCounter extends StatelessWidget {
  final int value;
  final String label;
  const _AnimatedCounter({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(seconds: 9),
      builder: (context, val, child) {
        return Column(
          children: [
            Text("$val",
                style: const TextStyle(
                    fontSize: 28,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.black)),
          ],
        );
      },
    );
  }
}
