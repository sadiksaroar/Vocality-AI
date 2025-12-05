// import 'package:flutter/material.dart';

// class YellowCircleScreen extends StatelessWidget {
//   const YellowCircleScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Get screen dimensions for responsive sizing
//     final size = MediaQuery.of(context).size;
//     final isPortrait = size.height > size.width;

//     // Calculate circle diameter based on screen size (40% of smaller dimension)
//     final circleDiameter = (isPortrait ? size.width : size.height) * 0.4;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFDC500), // Yellow background
//       body: SafeArea(
//         child: Center(
//           child: Container(
//             width: circleDiameter,
//             height: circleDiameter,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class YellowCircleScreen extends StatefulWidget {
  const YellowCircleScreen({super.key});

  @override
  State<YellowCircleScreen> createState() => _YellowCircleScreenState();
}

class _YellowCircleScreenState extends State<YellowCircleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeats back and forth

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
            builder: (context, child) {
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
