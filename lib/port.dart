import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioLandingPage extends StatefulWidget {
  const PortfolioLandingPage({super.key});

  @override
  State<PortfolioLandingPage> createState() => _PortfolioLandingPageState();
}

class _PortfolioLandingPageState extends State<PortfolioLandingPage>
    with TickerProviderStateMixin {
  // hover tracking
  final Map<String, bool> _hover = {
    "Home": false,
    "Case Studies": false,
    "Testimonials": false,
    "Recent work": false,
    "Get In Touch": false,
  };

  // hover for company boxes
  final Map<String, bool> _boxHover = {};

  // animations
  late AnimationController fadeCtrl;
  late AnimationController slideCtrl;

  @override
  void initState() {
    super.initState();

    fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    fadeCtrl.dispose();
    slideCtrl.dispose();
    super.dispose();
  }

  // ------------------ URL LAUNCH METHOD ------------------
  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final bool isMobile = size.maxWidth < 750;

        return Scaffold(
          backgroundColor: const Color(0xFF000000),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------ NAVBAR ------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // navigation
                    if (!isMobile)
                      Row(
                        children: [
                          _navItem("Home", "https://your-home-url.com"),
                          _navItem("Case Studies",
                              "https://your-casestudies.com"),
                          _navItem("Testimonials",
                              "https://your-testimonials.com"),
                          _navItem("Recent work", "https://your-work.com"),
                          _navItem("Get In Touch", "https://your-contact.com"),
                        ],
                      )
                    else
                      const SizedBox(),

                    // Social Icons
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => openUrl("https://linkedin.com"),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: const Icon(Icons.linked_camera,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => openUrl("https://dribbble.com"),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: const Icon(Icons.brush, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => openUrl("mailto:you@email.com"),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: const Icon(Icons.alternate_email,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 80),

                // ------------------ HERO SECTION ------------------
                FadeTransition(
                  opacity: fadeCtrl,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                        parent: slideCtrl, curve: Curves.easeOut)),
                    child: isMobile
                        ? _buildMobileHero()
                        : _buildDesktopHero(),
                  ),
                ),

                const SizedBox(height: 100),

                // ------------------ WORKED WITH ------------------
                Text(
                  "Worked with",
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 30),

                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _companyBox("ClickUp"),
                    _companyBox("Dropbox"),
                    _companyBox("PAYCHEX"),
                    _companyBox("elastic"),
                    _companyBox("stripe"),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------------ MOBILE HERO ------------------
  Widget _buildMobileHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _heroText(),
        const SizedBox(height: 40),
        _heroImage(),
      ],
    );
  }

  // ------------------ DESKTOP HERO ------------------
  Widget _buildDesktopHero() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // left
        Expanded(child: _heroText()),
        const SizedBox(width: 80),
        _heroImage(),
      ],
    );
  }

  // ------------------ HERO TEXT LEFT ------------------
  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ALEX DEV",
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Intro text: Lorem ipsum dolor sit amet, consectetur\n"
          "adipiscing elit, sed do eiusmod tempor incididunt ut\n"
          "labore et dolore magna aliqua.",
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 17,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 30),

        // CTA BUTTON WITH SCALE ANIMATION
        MouseRegion(
          onEnter: (_) => setState(() => _hover["CTA"] = true),
          onExit: (_) => setState(() => _hover["CTA"] = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => openUrl("https://your-cta-link.com"),
            child: AnimatedScale(
              scale: _hover["CTA"] == true ? 1.06 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2ECC40),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                child: const Text(
                  "Let’s get started  →",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  // ------------------ HERO IMAGE RIGHT ------------------
  Widget _heroImage() {
    return ClipOval(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Image.asset(
          "assets/profile.png", // update YOUR PATH
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ------------------ NAV TEXT ITEM ------------------
  Widget _navItem(String text, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover[text] = true),
      onExit: (_) => setState(() => _hover[text] = false),
      child: GestureDetector(
        onTap: () => openUrl(url),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            color: _hover[text]! ? Colors.greenAccent : Colors.white,
            fontSize: 16,
            fontWeight: _hover[text]! ? FontWeight.bold : FontWeight.normal,
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  // ------------------ COMPANY BOX ------------------
  Widget _companyBox(String title) {
    _boxHover.putIfAbsent(title, () => false);

    return MouseRegion(
      onEnter: (_) => setState(() => _boxHover[title] = true),
      onExit: (_) => setState(() => _boxHover[title] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 150,
        height: 70,
        margin: const EdgeInsets.only(right: 0),
        transform: _boxHover[title] == true
            ? (Matrix4.identity()..translate(0, -6, 0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF111111),
          border: Border.all(color: Colors.grey.shade800),
          boxShadow: _boxHover[title] == true
              ? [
                  BoxShadow(
                      color: Colors.green.withOpacity(0.25),
                      blurRadius: 20,
                      spreadRadius: 1)
                ]
              : [],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
