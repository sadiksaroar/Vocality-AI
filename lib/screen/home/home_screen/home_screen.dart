// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:vocality_ai/core/gen/assets.gen.dart';
// import 'package:vocality_ai/screen/home/drawer/drawer_screen.dart';
// import 'package:vocality_ai/screen/routing/app_path.dart';

// import 'package:vocality_ai/core/config/app_config.dart';
// import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
// import 'package:vocality_ai/core/network/api_service.dart';
// import 'package:vocality_ai/screen/home/home_screen/audio/audio_service.dart';

// import 'package:vocality_ai/core/voice/web_recorder_service.dart';
// import 'package:vocality_ai/widget/brand_widget.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

//   // Services
//   final api = ApiService();
//   final audio = AudioService();
//   final recorder = WebRecorderService();

//   bool isRecording = false;
//   bool isPremiumUser = false;
//   bool _isConversationActive = false;
//   bool _isProcessing = false; // Lock to prevent multiple concurrent sessions
//   bool _isAudioPlaying = false; // Track audio playback state

//   // Timer for tracking speaking duration
//   int _speakingSeconds = 0;
//   Timer? _speakingTimer;

//   // Animation controllers
//   late AnimationController _outerWaveController;
//   late AnimationController _middleWaveController;
//   late AnimationController _innerWaveController;
//   late AnimationController _pulseController;

//   // Color intensity tracking
//   double _colorIntensity = 0.0;

//   int get _personalityId => selectedIndex + 1;

//   Future<void> _ensureAudioStopped() async {
//     if (_isAudioPlaying) {
//       try {
//         await audio.stop();
//       } catch (e) {
//         print('❌ Error stopping audio: $e');
//       }
//       _isAudioPlaying = false;
//     }
//   }

//   Future<void> _reportUsageToBackend() async {
//     if (_speakingSeconds == 0) return;

//     try {
//       final token = await StorageHelper.getToken();
//       var headers = {
//         'Content-Type': 'application/json',
//         if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
//       };

//       var request = http.Request(
//         'POST',
//         Uri.parse(
//           '${AppConfig.httpBase}/subscription/subscription/report_usage/',
//         ),
//       );
//       request.body = json.encode({
//         "seconds": _speakingSeconds,
//         "personality_id": _personalityId,
//       });
//       request.headers.addAll(headers);

//       print(
//         '📤 Sending usage report: $_speakingSeconds seconds for personality $_personalityId',
//       );
//       print('   Authorization present: ${token != null && token.isNotEmpty}');

//       http.StreamedResponse response = await request.send();
//       String responseBody = await response.stream.bytesToString();

//       print('📥 Response status: ${response.statusCode}');
//       print('📥 Response body: $responseBody');

//       if (response.statusCode == 200) {
//         print('✅ Usage reported successfully');
//       } else {
//         print(
//           '❌ Failed to report usage: ${response.statusCode} - ${response.reasonPhrase}',
//         );
//       }
//     } catch (e) {
//       print('❌ Error reporting usage: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     _outerWaveController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     );

//     _middleWaveController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     _innerWaveController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );

//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//   }

//   @override
//   void dispose() {
//     _outerWaveController.dispose();
//     _middleWaveController.dispose();
//     _innerWaveController.dispose();
//     _pulseController.dispose();
//     _speakingTimer?.cancel();
//     _isConversationActive = false;
//     audio.stop();
//     audio.dispose();
//     super.dispose();
//   }

//   Future<void> _onMicTap() async {
//     // Prevent multiple taps while processing
//     if (_isProcessing) {
//       debugPrint('⚠️ Already processing, ignoring tap');
//       return;
//     }

//     if (!isListening) {
//       _isProcessing = true;
//       _isConversationActive = true;
//       setState(() {
//         isListening = true;
//         _colorIntensity = 0.0;
//         _speakingSeconds = 0;
//       });

//       _outerWaveController.repeat();
//       _middleWaveController.repeat();
//       _innerWaveController.repeat();
//       _pulseController.repeat(reverse: true);

//       _isProcessing = false; // Release lock after UI update
//       await _startContinuousConversation();
//     } else {
//       _isProcessing = true;
//       _isConversationActive = false;
//       _speakingTimer?.cancel();

//       // Stop animations first
//       _outerWaveController.stop();
//       _middleWaveController.stop();
//       _innerWaveController.stop();
//       _pulseController.stop();
//       _pulseController.reset();

//       // Stop recording and audio
//       await recorder.cancel();
//       _isAudioPlaying = false;
//       await audio.stop();
//       await Future.delayed(
//         const Duration(milliseconds: 300),
//       ); // Ensure audio stops completely

//       setState(() {
//         isListening = false;
//         _colorIntensity = 0.0;
//       });

//       try {
//         await api.endActiveConversation(personalityId: _personalityId);
//         await _reportUsageToBackend();
//       } catch (e) {
//         debugPrint('❌ Failed to end conversation: $e');
//       }

//       _isProcessing = false;
//     }
//   }

//   Future<void> _startContinuousConversation() async {
//     debugPrint('🎤 Starting continuous conversation (audio recording mode)');

//     while (_isConversationActive && mounted) {
//       // Start recording audio
//       _speakingTimer?.cancel();
//       _speakingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (_isConversationActive) {
//           setState(() {
//             _speakingSeconds++;
//             // Simulate color intensity based on recording duration
//             _colorIntensity = ((_speakingSeconds % 5) / 5.0).clamp(0.0, 1.0);
//           });
//         }
//       });

//       final recordingStarted = await recorder.start();

//       if (!recordingStarted) {
//         _speakingTimer?.cancel();
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Recording permission denied')),
//           );
//         }
//         _isConversationActive = false;
//         setState(() {
//           isListening = false;
//           _colorIntensity = 0.0;
//         });

//         _outerWaveController.stop();
//         _middleWaveController.stop();
//         _innerWaveController.stop();
//         _pulseController.stop();
//         _pulseController.reset();

//         return;
//       }

//       debugPrint('🔴 Recording started...');

//       // Record for a fixed duration (e.g., 4 seconds) or until user stops
//       // Using a listening window approach
//       await Future.delayed(const Duration(seconds: 4));

//       if (!_isConversationActive) break;

//       // Stop timer when recording ends
//       _speakingTimer?.cancel();

//       // Stop any playing audio before stopping recording
//       await _ensureAudioStopped();

//       // Stop recording and get the audio recording result
//       final recordingResult = await recorder.stop();
//       debugPrint(
//         '⏹️ Recording stopped. Has bytes: ${recordingResult.hasBytes}, Has file: ${recordingResult.hasFilePath}',
//       );

//       // Skip if no audio recorded
//       if (recordingResult.isEmpty) {
//         debugPrint('⏭️ No audio recorded, continuing to next cycle');
//         setState(() {
//           _colorIntensity = 0.0;
//         });
//         await Future.delayed(const Duration(milliseconds: 200));
//         continue;
//       }

//       // Send audio directly to backend (no speech-to-text conversion)
//       try {
//         debugPrint('📤 Sending audio to backend...');
//         final data = await api.sendAudioRecording(
//           personalityId: _personalityId,
//           recording: recordingResult,
//         );

//         if (!_isConversationActive) break;

//         // Backend returns 'audio_path' not 'audio_url'
//         final audioPath =
//             data['audio_path'] as String? ?? data['audio_url'] as String?;
//         debugPrint('🎵 Received audio_path from API: $audioPath');

//         if (audioPath != null && audioPath.isNotEmpty) {
//           final resolvedUrl = AppConfig.resolveAudioUrl(audioPath);
//           debugPrint('🎵 Playing resolved audio URL: $resolvedUrl');

//           try {
//             if (!_isConversationActive) break;

//             _isAudioPlaying = true;
//             await audio.playUrl(resolvedUrl);
//           } catch (e) {
//             debugPrint('❌ Audio playback interrupted/error: $e');
//           } finally {
//             _isAudioPlaying = false;
//           }

//           debugPrint('✅ Audio playback completed');

//           // Small delay before next cycle
//           if (_isConversationActive) {
//             await Future.delayed(const Duration(milliseconds: 300));
//           }
//         } else {
//           debugPrint('⚠️ No audio_url received');
//           if (mounted) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(const SnackBar(content: Text('No audio response')));
//           }
//         }
//       } catch (e) {
//         debugPrint('❌ Error in conversation: $e');
//         if (mounted) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text('Error: $e')));
//         }
//       }

//       setState(() {
//         _colorIntensity = 0.0;
//       });

//       await Future.delayed(const Duration(milliseconds: 200));
//     }

//     if (mounted) {
//       setState(() {
//         isListening = false;
//         _colorIntensity = 0.0;
//       });

//       _outerWaveController.stop();
//       _middleWaveController.stop();
//       _innerWaveController.stop();
//       _pulseController.stop();
//       _pulseController.reset();
//     }

//     _isAudioPlaying = false;
//     await audio.stop();
//   }

//   Future<void> _toggleRecording() async {
//     if (!isRecording) {
//       final ok = await recorder.start();
//       if (!ok) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Record permission denied')),
//         );
//         return;
//       }
//       setState(() => isRecording = true);
//     } else {
//       final result = await recorder.stop();
//       setState(() => isRecording = false);
//       if (!result.isEmpty) {
//         final info = result.hasFilePath
//             ? 'Saved: ${result.filePath}'
//             : 'Recorded ${result.bytes?.length ?? 0} bytes';
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(info)));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: scaffoldColors[selectedIndex],
//       drawer: const ProfileDrawer(),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             // Calculate available height and adjust spacing dynamically
//             final availableHeight = constraints.maxHeight;
//             final micSize = availableHeight < 600 ? 200.0 : 260.0;

//             final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//             return SingleChildScrollView(
//               padding: EdgeInsets.only(bottom: bottomInset),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: availableHeight - bottomInset,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Top row: menu + record toggle
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Builder(
//                               builder: (context) => IconButton(
//                                 icon: const Icon(Icons.menu),
//                                 onPressed: () {
//                                   Scaffold.of(context).openDrawer();
//                                 },
//                                 color: selectedIndex >= 2
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           GestureDetector(
//                             onTap: _toggleRecording,
//                             child: Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Container(
//                                 height: 35,
//                                 width: 160,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 10,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFF1F1F1),
//                                   borderRadius: BorderRadius.circular(50),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.1),
//                                       blurRadius: 10,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SizedBox(
//                                       width: 15,
//                                       height: 15,
//                                       child: Image.asset(
//                                         Assets.icons.trcord.path,
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       isRecording
//                                           ? 'Stop Recording'
//                                           : 'Start Recording',
//                                       style: GoogleFonts.inter(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 35),
//                       // Brand logo
//                       BrandWidget(
//                         fontSize: availableHeight < 600 ? 30 : 38,
//                         color: selectedIndex >= 1 ? Colors.white : Colors.black,
//                       ),
//                       const SizedBox(height: 40),
//                       // Mic with animated waves
//                       Center(
//                         child: GestureDetector(
//                           onTap: _onMicTap,
//                           child: SizedBox(
//                             width: micSize,
//                             height: micSize,
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 // Outer wave circle
//                                 AnimatedBuilder(
//                                   animation: _outerWaveController,
//                                   builder: (context, child) {
//                                     return Transform.scale(
//                                       scale: isListening
//                                           ? 1.0 +
//                                                 (_outerWaveController.value *
//                                                     0.1)
//                                           : 1.0,
//                                       child: Container(
//                                         width: micSize * 1.07,
//                                         height: micSize * 1.07,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           gradient: RadialGradient(
//                                             colors: [
//                                               Color.lerp(
//                                                 Colors.white,
//                                                 scaffoldColors[selectedIndex],
//                                                 isListening
//                                                     ? _colorIntensity * 0.8
//                                                     : 0,
//                                               )!.withOpacity(
//                                                 isListening
//                                                     ? 0.7 *
//                                                           (1 -
//                                                               _outerWaveController
//                                                                       .value *
//                                                                   0.4)
//                                                     : 0.1,
//                                               ),
//                                               Color.lerp(
//                                                 Colors.white,
//                                                 scaffoldColors[selectedIndex],
//                                                 isListening
//                                                     ? _colorIntensity * 0.6
//                                                     : 0,
//                                               )!.withOpacity(
//                                                 isListening ? 0.3 : 0.05,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 // Middle wave circle
//                                 AnimatedBuilder(
//                                   animation: _middleWaveController,
//                                   builder: (context, child) {
//                                     return Transform.scale(
//                                       scale: isListening
//                                           ? 1.0 +
//                                                 (_middleWaveController.value *
//                                                     0.15)
//                                           : 1.0,
//                                       child: Container(
//                                         width: micSize * 0.46,
//                                         height: micSize * 0.46,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           gradient: RadialGradient(
//                                             colors: [
//                                               Color.lerp(
//                                                 Colors.white,
//                                                 scaffoldColors[selectedIndex],
//                                                 isListening
//                                                     ? _colorIntensity * 0.9
//                                                     : 0,
//                                               )!.withOpacity(
//                                                 isListening
//                                                     ? 0.5 *
//                                                           (1 -
//                                                               _middleWaveController
//                                                                       .value *
//                                                                   0.5)
//                                                     : 0.15,
//                                               ),
//                                               Color.lerp(
//                                                 Colors.white,
//                                                 scaffoldColors[selectedIndex],
//                                                 isListening
//                                                     ? _colorIntensity * 0.7
//                                                     : 0,
//                                               )!.withOpacity(
//                                                 isListening ? 0.25 : 0.08,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 // Inner wave circle
//                                 AnimatedBuilder(
//                                   animation: _innerWaveController,
//                                   builder: (context, child) {
//                                     return Transform.scale(
//                                       scale: isListening
//                                           ? 1.0 +
//                                                 (_innerWaveController.value *
//                                                     0.2)
//                                           : 1.0,
//                                       child: Container(
//                                         width: micSize * 0.38,
//                                         height: micSize * 0.38,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           gradient: RadialGradient(
//                                             colors: [
//                                               Color.lerp(
//                                                 Colors.white,
//                                                 scaffoldColors[selectedIndex],
//                                                 isListening
//                                                     ? _colorIntensity
//                                                     : 0,
//                                               )!.withOpacity(
//                                                 isListening
//                                                     ? 0.4 *
//                                                           (1 -
//                                                               _innerWaveController
//                                                                       .value *
//                                                                   0.2)
//                                                     : 0.2,
//                                               ),
//                                               Color.lerp(
//                                                 Colors.white,
//                                                 scaffoldColors[selectedIndex],
//                                                 isListening
//                                                     ? _colorIntensity * 0.8
//                                                     : 0,
//                                               )!.withOpacity(
//                                                 isListening ? 0.2 : 0.12,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 // Center white circle with pulsing effect
//                                 AnimatedBuilder(
//                                   animation: _pulseController,
//                                   builder: (context, child) {
//                                     return Transform.scale(
//                                       scale: isListening
//                                           ? 1.0 +
//                                                 (_pulseController.value * 0.08)
//                                           : 1.0,
//                                       child: Container(
//                                         width: micSize * 0.31,
//                                         height: micSize * 0.31,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           shape: BoxShape.circle,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black.withOpacity(
//                                                 0.15,
//                                               ),
//                                               blurRadius: isListening
//                                                   ? 20 +
//                                                         (_pulseController
//                                                                 .value *
//                                                             10)
//                                                   : 20,
//                                               offset: const Offset(0, 8),
//                                               spreadRadius: isListening
//                                                   ? _pulseController.value * 2
//                                                   : 0,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       // Personality selector
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Container(
//                           height: 70,
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(50),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: List.generate(tabs.length, (index) {
//                               final isSelected = selectedIndex == index;
//                               final isPremiumTab = index >= 1;
//                               return GestureDetector(
//                                 onTap: () async {
//                                   if (isPremiumTab && !isPremiumUser) {
//                                     context.push(AppPath.purchaseScreen);
//                                     return;
//                                   }

//                                   if (selectedIndex != index) {
//                                     try {
//                                       await api.endActiveConversation(
//                                         personalityId: _personalityId,
//                                       );
//                                     } catch (e) {
//                                       print('❌ Failed to end conversation: $e');
//                                     }
//                                   }

//                                   setState(() {
//                                     selectedIndex = index;
//                                     selectedPersonality = tabs[index]
//                                         .replaceAll('\n', ' ');
//                                   });
//                                 },
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 300),
//                                   curve: Curves.easeInOut,
//                                   width: 80,
//                                   height: 54,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 6,
//                                     vertical: 6,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? buttonColors[index]
//                                         : Colors.grey[200],
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       tabs[index],
//                                       textAlign: TextAlign.center,
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w600,
//                                         color: isSelected && index >= 1
//                                             ? Colors.white
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       // Image analysis button
//                       GestureDetector(
//                         onTap: () {
//                           context.push(AppPath.imageAnalysisScreen);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 16),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 10,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(25),
//                             border: Border.all(color: Colors.grey[300]!),
//                           ),
//                           child: const Text(
//                             'Image analysis',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/home/drawer/drawer_screen.dart';
import 'package:vocality_ai/screen/routing/app_path.dart';
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:vocality_ai/core/network/api_service.dart';
import 'package:vocality_ai/screen/home/home_screen/audio/audio_service.dart';
import 'package:vocality_ai/core/voice/web_recorder_service.dart';
import 'package:vocality_ai/widget/brand_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
  final recorder = WebRecorderService();

  bool isRecording = false;
  bool isPremiumUser = false;
  bool _isConversationActive = false;
  bool _isProcessing = false;
  bool _isAudioPlaying = false;

  // Timer for tracking speaking duration
  int _speakingSeconds = 0;
  Timer? _speakingTimer;

  // Animation controllers
  late AnimationController _outerWaveController;
  late AnimationController _middleWaveController;
  late AnimationController _innerWaveController;
  late AnimationController _pulseController;

  // Color intensity tracking
  double _colorIntensity = 0.0;

  int get _personalityId => selectedIndex + 1;

  Future<void> _ensureAudioStopped() async {
    if (_isAudioPlaying) {
      try {
        await audio.stop();
      } catch (e) {
        print('❌ Error stopping audio: $e');
      }
      _isAudioPlaying = false;
    }
  }

  Future<void> _reportUsageToBackend() async {
    if (_speakingSeconds == 0) return;

    try {
      final token = await StorageHelper.getToken();
      var headers = {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      var request = http.Request(
        'POST',
        Uri.parse(
          '${AppConfig.httpBase}/subscription/subscription/report_usage/',
        ),
      );
      request.body = json.encode({
        "seconds": _speakingSeconds,
        "personality_id": _personalityId,
      });
      request.headers.addAll(headers);

      print(
        '📤 Sending usage report: $_speakingSeconds seconds for personality $_personalityId',
      );
      print('   Authorization present: ${token != null && token.isNotEmpty}');

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: $responseBody');

      if (response.statusCode == 200) {
        print('✅ Usage reported successfully');
      } else {
        print(
          '❌ Failed to report usage: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('❌ Error reporting usage: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _outerWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _middleWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _innerWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _outerWaveController.dispose();
    _middleWaveController.dispose();
    _innerWaveController.dispose();
    _pulseController.dispose();
    _speakingTimer?.cancel();
    _isConversationActive = false;
    audio.stop();
    audio.dispose();
    super.dispose();
  }

  Future<void> _onMicTap() async {
    // Prevent multiple taps while processing
    if (_isProcessing) {
      debugPrint('⚠️ Already processing, ignoring tap');
      return;
    }

    _isProcessing = true;

    if (!isListening) {
      // START LISTENING
      debugPrint('🎤 Starting to listen...');

      _isConversationActive = true;
      setState(() {
        isListening = true;
        _colorIntensity = 0.0;
        _speakingSeconds = 0;
      });

      // Start animations
      _outerWaveController.repeat();
      _middleWaveController.repeat();
      _innerWaveController.repeat();
      _pulseController.repeat(reverse: true);

      _isProcessing = false;

      // Start the continuous conversation in background
      _startContinuousConversation();
    } else {
      // STOP LISTENING
      debugPrint('🛑 Stopping listening...');

      // Stop the conversation loop
      _isConversationActive = false;

      // Cancel timer
      _speakingTimer?.cancel();

      // Stop animations
      _outerWaveController.stop();
      _middleWaveController.stop();
      _innerWaveController.stop();
      _pulseController.stop();
      _pulseController.reset();

      // Stop recording
      try {
        await recorder.cancel();
      } catch (e) {
        debugPrint('Error canceling recorder: $e');
      }

      // Stop audio
      try {
        _isAudioPlaying = false;
        await audio.stop();
      } catch (e) {
        debugPrint('Error stopping audio: $e');
      }

      // Update UI
      setState(() {
        isListening = false;
        _colorIntensity = 0.0;
      });

      // End conversation on backend
      try {
        await api.endActiveConversation(personalityId: _personalityId);
        await _reportUsageToBackend();
      } catch (e) {
        debugPrint('❌ Failed to end conversation: $e');
      }

      _isProcessing = false;
    }
  }

  Future<void> _startContinuousConversation() async {
    debugPrint('🎤 Starting continuous conversation (audio recording mode)');

    while (_isConversationActive && mounted) {
      // Check again at the start of each loop
      if (!_isConversationActive) break;

      // Start speaking timer
      _speakingTimer?.cancel();
      _speakingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isConversationActive && mounted) {
          setState(() {
            _speakingSeconds++;
            _colorIntensity = ((_speakingSeconds % 5) / 5.0).clamp(0.0, 1.0);
          });
        } else {
          timer.cancel();
        }
      });

      // Start recording
      final recordingStarted = await recorder.start();

      if (!recordingStarted) {
        _speakingTimer?.cancel();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recording permission denied')),
          );
        }
        _isConversationActive = false;
        if (mounted) {
          setState(() {
            isListening = false;
            _colorIntensity = 0.0;
          });
        }
        _outerWaveController.stop();
        _middleWaveController.stop();
        _innerWaveController.stop();
        _pulseController.stop();
        _pulseController.reset();
        return;
      }

      debugPrint('🔴 Recording started...');

      // Record for 4 seconds
      await Future.delayed(const Duration(seconds: 4));

      // Check if still active
      if (!_isConversationActive || !mounted) {
        await recorder.cancel();
        break;
      }

      // Stop timer
      _speakingTimer?.cancel();

      // Stop any playing audio
      await _ensureAudioStopped();

      // Stop recording
      final recordingResult = await recorder.stop();
      debugPrint(
        '⏹️ Recording stopped. Has bytes: ${recordingResult.hasBytes}',
      );

      // Check again after recording
      if (!_isConversationActive || !mounted) break;

      // Skip if no audio
      if (recordingResult.isEmpty) {
        debugPrint('⏭️ No audio recorded, continuing to next cycle');
        if (mounted) {
          setState(() {
            _colorIntensity = 0.0;
          });
        }
        await Future.delayed(const Duration(milliseconds: 200));
        continue;
      }

      // Send audio to backend
      try {
        debugPrint('📤 Sending audio to backend...');
        final data = await api.sendAudioRecording(
          personalityId: _personalityId,
          recording: recordingResult,
        );

        if (!_isConversationActive || !mounted) break;

        final audioPath =
            data['audio_path'] as String? ?? data['audio_url'] as String?;
        debugPrint('🎵 Received audio_path from API: $audioPath');

        if (audioPath != null && audioPath.isNotEmpty) {
          final resolvedUrl = AppConfig.resolveAudioUrl(audioPath);
          debugPrint('🎵 Playing resolved audio URL: $resolvedUrl');

          try {
            if (!_isConversationActive || !mounted) break;

            _isAudioPlaying = true;
            await audio.playUrl(resolvedUrl);
            _isAudioPlaying = false;

            debugPrint('✅ Audio playback completed');
          } catch (e) {
            debugPrint('❌ Audio playback error: $e');
            _isAudioPlaying = false;
          }

          // Check again after audio
          if (_isConversationActive && mounted) {
            await Future.delayed(const Duration(milliseconds: 300));
          }
        } else {
          debugPrint('⚠️ No audio_url received');
        }
      } catch (e) {
        debugPrint('❌ Error in conversation: $e');
        if (mounted && _isConversationActive) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }

      if (mounted) {
        setState(() {
          _colorIntensity = 0.0;
        });
      }

      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Cleanup when loop ends
    debugPrint('🏁 Conversation loop ended');
    if (mounted) {
      setState(() {
        isListening = false;
        _colorIntensity = 0.0;
      });

      _outerWaveController.stop();
      _middleWaveController.stop();
      _innerWaveController.stop();
      _pulseController.stop();
      _pulseController.reset();
    }

    _isAudioPlaying = false;
    await audio.stop();
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
      final result = await recorder.stop();
      setState(() => isRecording = false);
      if (!result.isEmpty) {
        final info = result.hasFilePath
            ? 'Saved: ${result.filePath}'
            : 'Recorded ${result.bytes?.length ?? 0} bytes';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(info)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColors[selectedIndex],
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final micSize = availableHeight < 600 ? 200.0 : 260.0;
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: availableHeight - bottomInset,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top row: menu + record toggle
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                color: selectedIndex >= 2
                                    ? Colors.white
                                    : Colors.black,
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
                                      isRecording
                                          ? 'Stop Recording'
                                          : 'Start Recording',
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
                      const SizedBox(height: 35),
                      // Brand logo
                      BrandWidget(
                        fontSize: availableHeight < 600 ? 30 : 38,
                        color: selectedIndex >= 1 ? Colors.white : Colors.black,
                      ),
                      const SizedBox(height: 40),
                      // Mic with animated waves
                      Center(
                        child: GestureDetector(
                          onTap: _onMicTap,
                          child: SizedBox(
                            width: micSize,
                            height: micSize,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer wave circle
                                AnimatedBuilder(
                                  animation: _outerWaveController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: isListening
                                          ? 1.0 +
                                                (_outerWaveController.value *
                                                    0.1)
                                          : 1.0,
                                      child: Container(
                                        width: micSize * 1.07,
                                        height: micSize * 1.07,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Color.lerp(
                                                Colors.white,
                                                scaffoldColors[selectedIndex],
                                                isListening
                                                    ? _colorIntensity * 0.8
                                                    : 0,
                                              )!.withOpacity(
                                                isListening
                                                    ? 0.7 *
                                                          (1 -
                                                              _outerWaveController
                                                                      .value *
                                                                  0.4)
                                                    : 0.1,
                                              ),
                                              Color.lerp(
                                                Colors.white,
                                                scaffoldColors[selectedIndex],
                                                isListening
                                                    ? _colorIntensity * 0.6
                                                    : 0,
                                              )!.withOpacity(
                                                isListening ? 0.3 : 0.05,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Middle wave circle
                                AnimatedBuilder(
                                  animation: _middleWaveController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: isListening
                                          ? 1.0 +
                                                (_middleWaveController.value *
                                                    0.15)
                                          : 1.0,
                                      child: Container(
                                        width: micSize * 0.46,
                                        height: micSize * 0.46,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Color.lerp(
                                                Colors.white,
                                                scaffoldColors[selectedIndex],
                                                isListening
                                                    ? _colorIntensity * 0.9
                                                    : 0,
                                              )!.withOpacity(
                                                isListening
                                                    ? 0.5 *
                                                          (1 -
                                                              _middleWaveController
                                                                      .value *
                                                                  0.5)
                                                    : 0.15,
                                              ),
                                              Color.lerp(
                                                Colors.white,
                                                scaffoldColors[selectedIndex],
                                                isListening
                                                    ? _colorIntensity * 0.7
                                                    : 0,
                                              )!.withOpacity(
                                                isListening ? 0.25 : 0.08,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Inner wave circle
                                AnimatedBuilder(
                                  animation: _innerWaveController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: isListening
                                          ? 1.0 +
                                                (_innerWaveController.value *
                                                    0.2)
                                          : 1.0,
                                      child: Container(
                                        width: micSize * 0.38,
                                        height: micSize * 0.38,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Color.lerp(
                                                Colors.white,
                                                scaffoldColors[selectedIndex],
                                                isListening
                                                    ? _colorIntensity
                                                    : 0,
                                              )!.withOpacity(
                                                isListening
                                                    ? 0.4 *
                                                          (1 -
                                                              _innerWaveController
                                                                      .value *
                                                                  0.2)
                                                    : 0.2,
                                              ),
                                              Color.lerp(
                                                Colors.white,
                                                scaffoldColors[selectedIndex],
                                                isListening
                                                    ? _colorIntensity * 0.8
                                                    : 0,
                                              )!.withOpacity(
                                                isListening ? 0.2 : 0.12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Center white circle with pulsing effect
                                AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: isListening
                                          ? 1.0 +
                                                (_pulseController.value * 0.08)
                                          : 1.0,
                                      child: Container(
                                        width: micSize * 0.31,
                                        height: micSize * 0.31,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.15,
                                              ),
                                              blurRadius: isListening
                                                  ? 20 +
                                                        (_pulseController
                                                                .value *
                                                            10)
                                                  : 20,
                                              offset: const Offset(0, 8),
                                              spreadRadius: isListening
                                                  ? _pulseController.value * 2
                                                  : 0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Personality selector
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                              final isPremiumTab = index >= 1;
                              return GestureDetector(
                                onTap: () async {
                                  if (isPremiumTab && !isPremiumUser) {
                                    context.push(AppPath.purchaseScreen);
                                    return;
                                  }

                                  if (selectedIndex != index) {
                                    try {
                                      await api.endActiveConversation(
                                        personalityId: _personalityId,
                                      );
                                    } catch (e) {
                                      print('❌ Failed to end conversation: $e');
                                    }
                                  }

                                  setState(() {
                                    selectedIndex = index;
                                    selectedPersonality = tabs[index]
                                        .replaceAll('\n', ' ');
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
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
