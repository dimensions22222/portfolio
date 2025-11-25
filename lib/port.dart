// mobile_portfolio_landing_page.dart
// ignore_for_file: unused_element, unused_element_parameter, unused_import

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioLandingPage extends StatefulWidget {
  const PortfolioLandingPage({super.key});

  @override
  State<PortfolioLandingPage> createState() => _PortfolioLandingPageState();
}

class _PortfolioLandingPageState extends State<PortfolioLandingPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollCtrl = ScrollController();
  final Map<String, bool> _boxHover = {};
  bool _countersTriggered = false;
  late AnimationController _particleCtrl;

  @override
  void initState() {
    super.initState();
    _particleCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 18))
          ..repeat();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_countersTriggered) return;
    if (_scrollCtrl.offset > 300) {
      setState(() => _countersTriggered = true);
    }
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: _Background(particleCtrl: _particleCtrl)),
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Mobile Hero
                  _heroText(),
                  const SizedBox(height: 30),
                  ClipOval(
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child:
                          Image.asset("assets/hero.jpg", fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 80),
                  // Worked With
                  _WorkedWithSection(
                    boxHover: _boxHover,
                    triggerCounters: _countersTriggered,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ HERO TEXT ------------------
  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "ALEX DEV",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Flutter Developer • Creative Builder\n• Future Full-Stack Dev",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => openUrl("https://your-cta-link.com"),
          child: const Text("Let’s get started →"),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => openUrl("mailto:you@email.com"),
          child: const Text(
            "Get In Touch",
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
      ],
    );
  }
}

// ------------------ BACKGROUND ------------------
class _Background extends StatelessWidget {
  final AnimationController particleCtrl;
  const _Background({required this.particleCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.3, -0.4),
          radius: 1.2,
          colors: [Colors.white12, Colors.blueGrey],
        ),
      ),
    );
  }
}

// ------------------ WORKED WITH SECTION ------------------
class _WorkedWithSection extends StatelessWidget {
  final Map<String, bool> boxHover;
  final bool triggerCounters;
  const _WorkedWithSection(
      {required this.boxHover, required this.triggerCounters});

  @override
  Widget build(BuildContext context) {
    final companies = ["ClickUp", "Dropbox", "PAYCHEX", "elastic", "stripe"];
    return Column(
      children: [
        const Text(
          "Worked with",
          style: TextStyle(color: Colors.greenAccent, fontSize: 18),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: companies.map((c) => _CompanyTile(title: c)).toList(),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _AnimatedCounter(
              label: "Years",
              endValue: 5,
              trigger: triggerCounters,
            ),
            _AnimatedCounter(
              label: "Projects",
              endValue: 30,
              trigger: triggerCounters,
            ),
            _AnimatedCounter(
              label: "Clients",
              endValue: 10,
              trigger: triggerCounters,
            ),
          ],
        ),
      ],
    );
  }
}

class _CompanyTile extends StatelessWidget {
  final String title;
  const _CompanyTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[900],
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }
}

class _AnimatedCounter extends StatefulWidget {
  final String label;
  final int endValue;
  final bool trigger;
  const _AnimatedCounter(
      {required this.label, required this.endValue, this.trigger = false});

  @override
  State<_AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<_AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  int displayed = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 10));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)
      ..addListener(() {
        setState(() {
          displayed = (_anim.value * widget.endValue).round();
        });
      });
    if (widget.trigger) _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant _AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) _ctrl.forward(from: 0);
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
        Text(
          "$displayed+",
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent),
        ),
        const SizedBox(height: 4),
        Text(widget.label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
