import 'package:flutter/material.dart';
import 'package:sih/widgets/app_colors.dart';
import 'dart:async';

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

class TestimonialData {
  final String message;
  final String author;

  TestimonialData({required this.message, required this.author});
}
