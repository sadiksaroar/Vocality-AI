import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/screen/home/drawer/drawer_screen.dart';
import 'package:vocality_ai/screen/routing/app_path.dart';

import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/core/network/api_service.dart';
import 'package:vocality_ai/screen/home/home_screen/audio/audio_service.dart';
import 'package:vocality_ai/core/voice/speech_service.dart';
import 'package:vocality_ai/core/voice/recorder_service.dart';
import 'package:vocality_ai/widget/brand_widget.dart';

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
  bool _isConversationActive = false;

  int get _personalityId => selectedIndex + 1; // A=1, B=2, C=3, D=4

  @override
  void dispose() {
    _isConversationActive = false;
    audio.stop();
    speech.stop();
    super.dispose();
  }

  Future<void> _onMicTap() async {
    if (!isListening) {
      // Start continuous conversation mode
      _isConversationActive = true;
      setState(() => isListening = true);
      await _startContinuousConversation();
    } else {
      // Stop conversation mode
      _isConversationActive = false;
      setState(() => isListening = false);
      await speech.stop();
      await audio.stop();

      // End active conversation on server
      try {
        await api.endActiveConversation(personalityId: _personalityId);
      } catch (e) {
        print('❌ Failed to end conversation: $e');
      }
    }
  }

  Future<void> _startContinuousConversation() async {
    while (_isConversationActive && mounted) {
      // Start listening
      final ok = await speech.start((t) {
        setState(() {});
      });

      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Speech not available')));
        }
        _isConversationActive = false;
        setState(() => isListening = false);
        return;
      }

      // Wait for speech to complete (with timeout)
      await Future.delayed(
        const Duration(seconds: 5),
      ); // Adjust timeout as needed

      if (!_isConversationActive) break;

      // Get the transcribed text
      final text = await speech.stop();

      if (!_isConversationActive) break;

      // If we got some text, send it and play response
      if (text.isNotEmpty) {
        try {
          final data = await api.sendMessage(
            personalityId: _personalityId,
            message: text,
          );

          if (!_isConversationActive) break;

          final audioUrl = data['audio_url'] as String?;
          print('🎵 Received audio_url from API: $audioUrl');

          if (audioUrl != null && audioUrl.isNotEmpty) {
            final resolvedUrl = AppConfig.resolveAudioUrl(audioUrl);
            print('🎵 Resolved audio URL: $resolvedUrl');
            await audio.playUrl(resolvedUrl);

            // Wait for audio to finish playing before listening again
            await Future.delayed(const Duration(seconds: 2)); // Add buffer time
          } else {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('No audio_url')));
            }
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $e')));
          }
        }
      }

      // Small delay before next listening cycle
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Ensure state is updated when loop exits
    if (mounted) {
      setState(() => isListening = false);
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
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
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
                            color: selectedIndex >= 2
                                ? Colors.white
                                : Colors.black,
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
                SizedBox(height: 40),

                // Big letter/logo
                BrandWidget(
                  fontSize: 38,
                  color: selectedIndex >= 1 ? Colors.white : Colors.black,
                ),

                // Mic ripple + STT + POST + audio_url playback
                SizedBox(height: 40),

                GestureDetector(
                  onTap: _onMicTap,
                  child: SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer wave circle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                          width: isListening ? 280 : 280,
                          height: isListening ? 280 : 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                        // Middle wave circle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          width: isListening ? 150 : 120,
                          height: isListening ? 150 : 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0.08),
                              ],
                            ),
                          ),
                        ),
                        // Inner wave circle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          width: isListening ? 120 : 100,
                          height: isListening ? 120 : 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.12),
                              ],
                            ),
                          ),
                        ),
                        // Center white circle with shadow
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.mic,
                            color: scaffoldColors[selectedIndex],
                            size: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 90),

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
                          onTap: () async {
                            if (isPremiumTab && !isPremiumUser) {
                              // Redirect to purchase screen for premium personalities
                              context.push(AppPath.purchaseScreen);
                              return;
                            }

                            // If switching personality, end current conversation
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
                SizedBox(height: 20),
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
        ),
      ),
    );
  }
}
