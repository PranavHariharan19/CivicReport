// File: LandingPage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih/login_page.dart';
import 'package:sih/services/auth_service.dart';
import 'package:sih/main.dart';
import 'dart:async';

// Rotating Testimonials Widget remains the same
class RotatingTestimonials extends StatefulWidget {
  const RotatingTestimonials({super.key});

  @override
  State<RotatingTestimonials> createState() => _RotatingTestimonialsState();
}

class _RotatingTestimonialsState extends State<RotatingTestimonials>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Timer _timer;
  int _currentIndex = 0;

  final List<TestimonialData> testimonials = [
    TestimonialData(
      message:
      'I reported a dangerous pothole on my street and it was fixed within 48 hours! This app actually works and makes city officials accountable.',
      author: 'Sarah Chen, Community Advocate',
    ),
    TestimonialData(
      message:
      'Finally, a way to report broken streetlights that actually gets results! Our neighborhood feels so much safer now. Thank you CivicReport!',
      author: 'Michael Rodriguez, Local Resident',
    ),
    TestimonialData(
      message:
      'As a city councilor, this app has revolutionized how we handle citizen complaints. We can prioritize issues better and respond faster than ever.',
      author: 'Dr. Amanda Williams, City Council Member',
    ),
    TestimonialData(
      message:
      'The garbage overflow problem near our school was resolved in just 3 days after reporting. My kids can walk safely to school again!',
      author: 'James Park, Parent & Teacher',
    ),
    TestimonialData(
      message:
      'Illegal parking was blocking our bus stop daily. One report through CivicReport and now we have proper enforcement. Amazing results!',
      author: 'Maria Santos, Daily Commuter',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _rotateTestimonial();
    });
  }

  void _rotateTestimonial() {
    _controller.reverse().then((_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % testimonials.length;
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _fadeAnimation.value) * 20),
            child: Column(
              children: [
                const Icon(
                  Icons.format_quote,
                  size: 40,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(height: 20),
                Text(
                  testimonials[_currentIndex].message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: AppColors.mediumGray,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  '— ${testimonials[_currentIndex].author}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    testimonials.length,
                        (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentIndex
                            ? AppColors.primaryBlue
                            : AppColors.primaryBlue.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Testimonial Data Model
class TestimonialData {
  final String message;
  final String author;

  TestimonialData({
    required this.message,
    required this.author,
  });
}

// ------------------- Landing Page -------------------
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeroSection(),
            FeaturesSection(),
            ProblemSolutionSection(),
            SocialProofSection(),
            FinalCTASection(),
          ],
        ),
      ),
    );
  }
}

// ------------------- Animation Components -------------------
class AnimatedFadeSlide extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const AnimatedFadeSlide({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedFadeSlide> createState() => _AnimatedFadeSlideState();
}

class _AnimatedFadeSlideState extends State<AnimatedFadeSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

// ------------------- Hover Button -------------------
class HoverButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const HoverButton({super.key, required this.label, required this.onPressed});

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: _isHovered ? AppColors.primaryBlue : AppColors.successGreen,
          borderRadius: BorderRadius.circular(50),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: widget.onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : 30,
                vertical: isDesktop ? 16 : 14,
              ),
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- Hoverable Card -------------------
class HoverableCard extends StatefulWidget {
  final Widget child;
  const HoverableCard({super.key, required this.child});

  @override
  State<HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<HoverableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
        child: widget.child,
      ),
    );
  }
}

// ------------------- UPDATED Hero Section -------------------
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768 && size.width <= 1024;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.deepBlue],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : (isTablet ? 40 : 20),
        vertical: isDesktop ? 120 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedFadeSlide(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  'CivicReport',
                  style: TextStyle(
                    fontSize: isDesktop ? 64 : (isTablet ? 48 : 36),
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              AnimatedFadeSlide(
                delay: const Duration(milliseconds: 500),
                child: Text(
                  'Report. Track. Transform Your City.',
                  style: TextStyle(
                    fontSize: isDesktop ? 28 : (isTablet ? 24 : 20),
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.95),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              AnimatedFadeSlide(
                delay: const Duration(milliseconds: 700),
                child: Text(
                  'Empower your community to fix urban issues faster. Report problems instantly, track progress, and create positive change in your neighborhood.',
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : 16,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 50),
              AnimatedFadeSlide(
                delay: const Duration(milliseconds: 900),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    HoverButton(
                      label: 'Admin Login',
                      onPressed: () {
                        Navigator.pushNamed(context, '/admin-login');
                      },
                    ),
                    HoverButton(
                      label: 'Public Login',
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : (isTablet ? 40 : 20),
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              AnimatedFadeSlide(
                child: Column(
                  children: [
                    Text(
                      'Powerful Features for Civic Action',
                      style: TextStyle(
                        fontSize: isDesktop ? 48 : (isTablet ? 36 : 28),
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Everything you need to report, track, and resolve community issues efficiently',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.mediumGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                crossAxisSpacing: 40,
                mainAxisSpacing: 40,
                childAspectRatio: isDesktop ? 1.1 : (isTablet ? 1.0 : 1.2),
                children: [
                  _buildFeatureCard(
                    Icons.camera_alt,
                    'Photo Documentation',
                    'Capture clear evidence with in-app camera. Visual proof helps authorities understand and prioritize issues faster.',
                  ),
                  _buildFeatureCard(
                    Icons.location_pin,
                    'Precise Location Tagging',
                    'Automatic GPS coordinates ensure authorities find the exact problem location without confusion or delays.',
                  ),
                  _buildFeatureCard(
                    Icons.notifications_active,
                    'Real-Time Updates',
                    'Receive notifications when your report is acknowledged, assigned, and resolved. Stay informed every step.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return HoverableCard(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 35,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProblemSolutionSection extends StatelessWidget {
  const ProblemSolutionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768;

    return Container(
      width: double.infinity,
      color: AppColors.lightGray,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : (isTablet ? 40 : 20),
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isDesktop || isTablet
              ? Row(
            children: [
              Expanded(child: _buildProblemCard()),
              const SizedBox(width: 60),
              Expanded(child: _buildSolutionCard()),
            ],
          )
              : Column(
            children: [
              _buildProblemCard(),
              const SizedBox(height: 40),
              _buildSolutionCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemCard() {
    return AnimatedFadeSlide(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: const Border(
            left: BorderSide(color: AppColors.warningRed, width: 5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.warningRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.warning,
                color: AppColors.warningRed,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'The Urban Challenge',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Cities face countless daily issues—potholes, overflowing garbage, broken streetlights, illegal parking...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Traditional reporting methods are slow, bureaucratic, and often ignored.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionCard() {
    return AnimatedFadeSlide(
      delay: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: const Border(
            left: BorderSide(color: AppColors.successGreen, width: 5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.lightbulb,
                color: AppColors.successGreen,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Solution',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'CivicReport transforms community engagement. Instant issue reporting, photos, and GPS precision.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Join thousands of citizens making neighborhoods better, one report at a time.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialProofSection extends StatelessWidget {
  const SocialProofSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768;

    return Container(
      width: double.infinity,
      color: AppColors.lightGray,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : (isTablet ? 40 : 20),
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              AnimatedFadeSlide(
                child: Column(
                  children: [
                    Text(
                      'Making Real Impact',
                      style: TextStyle(
                        fontSize: isDesktop ? 48 : (isTablet ? 36 : 28),
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Join a growing community of engaged citizens creating positive change',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.mediumGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isDesktop ? 4 : (isTablet ? 2 : 2),
                crossAxisSpacing: 40,
                mainAxisSpacing: 40,
                childAspectRatio: isDesktop ? 1.2 : 1.0,
                children: [
                  _buildStatCard('25,847', 'Issues Reported'),
                  _buildStatCard('18,394', 'Problems Resolved'),
                  _buildStatCard('127', 'Partner Cities'),
                  _buildStatCard('4.8★', 'App Store Rating'),
                ],
              ),
              const SizedBox(height: 60),
              AnimatedFadeSlide(
                delay: const Duration(milliseconds: 600),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const RotatingTestimonials(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return AnimatedFadeSlide(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FinalCTASection extends StatelessWidget {
  const FinalCTASection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkGray, Color(0xFF374151)],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : (isTablet ? 40 : 20),
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              AnimatedFadeSlide(
                child: Text(
                  'Ready to Transform Your Community?',
                  style: TextStyle(
                    fontSize: isDesktop ? 48 : (isTablet ? 36 : 28),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              AnimatedFadeSlide(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  'Download CivicReport today and start making a difference in your neighborhood. Together, we can build better, more responsive cities.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              AnimatedFadeSlide(
                delay: const Duration(milliseconds: 400),
                child: isDesktop || isTablet
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAppStoreButton(true),
                    const SizedBox(width: 20),
                    _buildAppStoreButton(false),
                  ],
                )
                    : Column(
                  children: [
                    _buildAppStoreButton(true),
                    const SizedBox(height: 20),
                    _buildAppStoreButton(false),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              AnimatedFadeSlide(
                delay: const Duration(milliseconds: 600),
                child: Text(
                  'Start reporting. Start changing. Start now.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppStoreButton(bool isAppStore) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAppStore ? Icons.apple : Icons.android,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isAppStore ? 'Download on the' : 'Get it on',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      isAppStore ? 'App Store' : 'Google Play',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }}