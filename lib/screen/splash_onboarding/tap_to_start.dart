import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TapToStart extends StatefulWidget {
  const TapToStart({super.key});

  @override
  State<TapToStart> createState() => _TapToStartState();
}

class _TapToStartState extends State<TapToStart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Pulse animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Auto navigate to SignIn screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.push('/signInScreen');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;
    final circleDiameter = (isPortrait ? size.width : size.height) * 0.4;

    return Scaffold(
      backgroundColor: const Color(0xFFFDC500),
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (_, __) {
              return Transform.scale(
                scale: _animation.value,
                child: Container(
                  width: circleDiameter,
                  height: circleDiameter,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
