import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/home/drawer/drawer_screen.dart';
import 'package:vocality_ai/screen/routing/app_path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPersonality = 'Personality A';
  bool isListening = false;
  int selectedIndex = 0;

  final List<String> tabs = [
    'Personality\nA',
    'Personality\nB',
    'Personality\nC',
    'Personality\nD',
  ];

  final List<Color> buttonColors = [
    const Color(0xFFFFD300),
    const Color(0xFFFF2D78),
    const Color(0xFF660033),
    const Color(0xFF0A1F44),
  ];

  final List<Color> scaffoldColors = [
    const Color(0xFFFDD835),
    const Color(0xFFFF2D78),
    const Color(0xFF660033),
    const Color(0xFF0A1F44),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColors[selectedIndex],
      drawer: const ProfileDrawer(), // Drawer added here
      body: SafeArea(
        child: Column(
          children: [
            // Menu Button with Builder to access correct context
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        color: selectedIndex >= 2 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),

                const Spacer(),
                // ...existing code...
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 35,
                    width: 140,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          child: Image.asset(
                            Assets.icons.trcord.path,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Start Recording',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ...existing code...
              ],
            ),

            Text(
              'K',
              style: GoogleFonts.montserrat(
                fontSize: 135,
                fontWeight: FontWeight.w700,
                color: selectedIndex >= 1 ? Colors.white : Colors.black,
              ),
            ),

            // ...existing code...
            GestureDetector(
              onTap: () {
                setState(() {
                  isListening = !isListening;
                });
              },
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      width: isListening ? 140 : 110,
                      height: isListening ? 140 : 110,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      width: isListening ? 120 : 90,
                      height: isListening ? 120 : 90,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ...existing code...
            const Spacer(),
            // Personality Buttons Box
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(tabs.length, (index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 80,
                        height: 54,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? buttonColors[index]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            tabs[index],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isSelected && index >= 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            // Image Analysis Button
            GestureDetector(
              onTap: () {
                context.push(AppPath.imageAnalysisScreen);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Text(
                  'Image analysis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
