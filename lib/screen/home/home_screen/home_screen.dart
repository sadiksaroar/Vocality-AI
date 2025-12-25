// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vocality_ai/core/gen/assets.gen.dart';
// import 'package:vocality_ai/screen/home/drawer/drawer_screen.dart';
// import 'package:vocality_ai/screen/routing/app_path.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String selectedPersonality = 'Personality A';
//   bool isListening = false;
//   int selectedIndex = 0;

//   final List<String> tabs = [
//     'Personality\nA',
//     'Personality\nB',
//     'Personality\nC',
//     'Personality\nD',
//   ];

//   final List<Color> buttonColors = [
//     const Color(0xFFFFD300),
//     const Color(0xFFFF2D78),
//     const Color(0xFF660033),
//     const Color(0xFF0A1F44),
//   ];

//   final List<Color> scaffoldColors = [
//     const Color(0xFFFDD835),
//     const Color(0xFFFF2D78),
//     const Color(0xFF660033),
//     const Color(0xFF0A1F44),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: scaffoldColors[selectedIndex],
//       drawer: const ProfileDrawer(), // Drawer added here
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Menu Button with Builder to access correct context
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Align(
//                     alignment: Alignment.topLeft,
//                     child: Builder(
//                       builder: (context) => IconButton(
//                         icon: const Icon(Icons.menu),
//                         onPressed: () {
//                           Scaffold.of(context).openDrawer();
//                         },
//                         color: selectedIndex >= 2 ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const Spacer(),
//                 // ...existing code...
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Container(
//                     height: 35,
//                     width: 140,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF1F1F1),
//                       borderRadius: BorderRadius.circular(50),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 15,
//                           height: 15,
//                           child: Image.asset(
//                             Assets.icons.trcord.path,
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                         const SizedBox(width: 2),
//                         Text(
//                           'Start Recording',
//                           style: GoogleFonts.inter(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // ...existing code...
//               ],
//             ),

//             Text(
//               'K',
//               style: GoogleFonts.montserrat(
//                 fontSize: 135,
//                 fontWeight: FontWeight.w700,
//                 color: selectedIndex >= 1 ? Colors.white : Colors.black,
//               ),
//             ),

//             // ...existing code...
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isListening = !isListening;
//                 });
//               },
//               child: Container(
//                 width: 160,
//                 height: 160,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 20,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 600),
//                       curve: Curves.easeInOut,
//                       width: isListening ? 140 : 110,
//                       height: isListening ? 140 : 110,
//                       decoration: BoxDecoration(
//                         color: Colors.blue.withOpacity(0.12),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 600),
//                       curve: Curves.easeInOut,
//                       width: isListening ? 120 : 90,
//                       height: isListening ? 120 : 90,
//                       decoration: BoxDecoration(
//                         color: Colors.blue.withOpacity(0.18),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     Container(
//                       width: 70,
//                       height: 70,
//                       decoration: const BoxDecoration(
//                         color: Colors.blue,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.mic,
//                         color: Colors.white,
//                         size: 32,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // ...existing code...
//             const Spacer(),
//             // Personality Buttons Box
//             const SizedBox(height: 12),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: 70,
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(50),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 20,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(tabs.length, (index) {
//                     final isSelected = selectedIndex == index;
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedIndex = index;
//                         });
//                       },
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                         width: 80,
//                         height: 54,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 6,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? buttonColors[index]
//                               : Colors.grey[200],
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: Center(
//                           child: Text(
//                             tabs[index],
//                             textAlign: TextAlign.center,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600,
//                               color: isSelected && index >= 1
//                                   ? Colors.white
//                                   : Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//             // Image Analysis Button
//             GestureDetector(
//               onTap: () {
//                 context.push(AppPath.imageAnalysisScreen);
//               },
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(25),
//                   border: Border.all(color: Colors.grey[300]!),
//                 ),
//                 child: const Text(
//                   'Image analysis',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/home/drawer/drawer_screen.dart';
import 'package:vocality_ai/screen/routing/app_path.dart';

import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/core/network/api_service.dart';
import 'package:vocality_ai/core/audio/audio_service.dart';
import 'package:vocality_ai/core/voice/speech_service.dart';
import 'package:vocality_ai/core/voice/recorder_service.dart';

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

  // Services
  final api = ApiService();
  final audio = AudioService();
  final speech = SpeechService();
  final recorder = RecorderService();

  bool isRecording = false;
  bool isPremiumUser = false; // TODO: set true if user has premium

  int get _personalityId => selectedIndex + 1; // A=1, B=2, C=3, D=4

  @override
  void dispose() {
    audio.stop();
    super.dispose();
  }

  Future<void> _onMicTap() async {
    if (!isListening) {
      final ok = await speech.start((t) {
        setState(() {});
      });
      if (!ok) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Speech not available')));
        return;
      }
      setState(() => isListening = true);
    } else {
      final text = await speech.stop();
      setState(() => isListening = false);
      if (text.isNotEmpty) {
        try {
          final data = await api.sendMessage(
            personalityId: _personalityId,
            message: text,
          );
          final audioUrl = data['audio_url'] as String?;
          print('🎵 Received audio_url from API: $audioUrl');
          if (audioUrl != null && audioUrl.isNotEmpty) {
            final resolvedUrl = AppConfig.resolveAudioUrl(audioUrl);
            print('🎵 Resolved audio URL: $resolvedUrl');
            await audio.playUrl(resolvedUrl);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('No audio_url')));
          }
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _toggleRecording() async {
    if (!isRecording) {
      final ok = await recorder.start();
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record permission denied')),
        );
        return;
      }
      setState(() => isRecording = true);
    } else {
      final path = await recorder.stop();
      setState(() => isRecording = false);
      if (path != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Saved: $path')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColors[selectedIndex],
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Top row: menu + record toggle
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
                GestureDetector(
                  onTap: _toggleRecording,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 35,
                      width: 160,
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
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: Image.asset(
                              Assets.icons.trcord.path,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isRecording ? 'Stop Recording' : 'Start Recording',
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
                ),
              ],
            ),

            // Big letter/logo
            Text(
              'K',
              style: GoogleFonts.montserrat(
                fontSize: 135,
                fontWeight: FontWeight.w700,
                color: selectedIndex >= 1 ? Colors.white : Colors.black,
              ),
            ),

            // Mic ripple + STT + POST + audio_url playback
            GestureDetector(
              onTap: _onMicTap,
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

            const Spacer(),

            // Personality selector
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
                    final isPremiumTab = index >= 1; // B/C/D premium
                    return GestureDetector(
                      onTap: () {
                        if (isPremiumTab && !isPremiumUser) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Premium required for B/C/D'),
                            ),
                          );
                          return;
                        }
                        setState(() {
                          selectedIndex = index;
                          selectedPersonality = tabs[index].replaceAll(
                            '\n',
                            ' ',
                          );
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

            // Image analysis button
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
