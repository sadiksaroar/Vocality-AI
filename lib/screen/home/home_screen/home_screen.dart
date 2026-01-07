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
import 'package:vocality_ai/core/voice/speech_service.dart';
import 'package:vocality_ai/core/voice/recorder_service.dart';
import 'package:vocality_ai/widget/brand_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
  final speech = SpeechService();
  final recorder = RecorderService();

  bool isRecording = false;
  bool isPremiumUser = false;
  bool _isConversationActive = false;

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
  int _wordCount = 0;

  int get _personalityId => selectedIndex + 1;

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
          'http://10.10.7.74:8000/subscription/subscription/report_usage/',
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
    speech.stop();
    super.dispose();
  }

  Future<void> _onMicTap() async {
    if (!isListening) {
      _isConversationActive = true;
      setState(() {
        isListening = true;
        _colorIntensity = 0.0;
        _wordCount = 0;
        _speakingSeconds = 0;
      });

      _outerWaveController.repeat();
      _middleWaveController.repeat();
      _innerWaveController.repeat();
      _pulseController.repeat(reverse: true);

      await _startContinuousConversation();
    } else {
      _isConversationActive = false;
      _speakingTimer?.cancel();
      setState(() {
        isListening = false;
        _colorIntensity = 0.0;
        _wordCount = 0;
      });

      _outerWaveController.stop();
      _middleWaveController.stop();
      _innerWaveController.stop();
      _pulseController.stop();
      _pulseController.reset();

      await speech.stop();
      await audio.stop();

      try {
        await api.endActiveConversation(personalityId: _personalityId);
        await _reportUsageToBackend();
      } catch (e) {
        print('❌ Failed to end conversation: $e');
      }
    }
  }

  Future<void> _startContinuousConversation() async {
    while (_isConversationActive && mounted) {
      // Start timer when speech recognition begins
      _speakingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isConversationActive) {
          setState(() {
            _speakingSeconds++;
          });
        }
      });

      final ok = await speech.start((t) {
        final words = t.trim().split(RegExp(r'\s+'));
        setState(() {
          _wordCount = words.where((w) => w.isNotEmpty).length;
          _colorIntensity = (_wordCount / 20).clamp(0.0, 1.0);
        });
      });

      if (!ok) {
        _speakingTimer?.cancel();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Speech not available')));
        }
        _isConversationActive = false;
        setState(() {
          isListening = false;
          _colorIntensity = 0.0;
          _wordCount = 0;
        });

        _outerWaveController.stop();
        _middleWaveController.stop();
        _innerWaveController.stop();
        _pulseController.stop();
        _pulseController.reset();

        return;
      }

      await Future.delayed(const Duration(seconds: 5));

      if (!_isConversationActive) break;

      // Stop timer when speech recognition ends
      _speakingTimer?.cancel();
      final text = await speech.stop();

      if (!_isConversationActive) break;

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

            await Future.delayed(const Duration(seconds: 2));
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

      setState(() {
        _colorIntensity = 0.0;
        _wordCount = 0;
      });

      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (mounted) {
      setState(() {
        isListening = false;
        _colorIntensity = 0.0;
        _wordCount = 0;
      });

      _outerWaveController.stop();
      _middleWaveController.stop();
      _innerWaveController.stop();
      _pulseController.stop();
      _pulseController.reset();
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
            const Spacer(flex: 1),
            // Brand logo
            BrandWidget(
              fontSize: 38,
              color: selectedIndex >= 1 ? Colors.white : Colors.black,
            ),
            const Spacer(flex: 2),
            // Mic with animated waves
            GestureDetector(
              onTap: _onMicTap,
              child: SizedBox(
                width: 260,
                height: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer wave circle
                    AnimatedBuilder(
                      animation: _outerWaveController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isListening
                              ? 1.0 + (_outerWaveController.value * 0.1)
                              : 1.0,
                          child: Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color.lerp(
                                    Colors.white,
                                    scaffoldColors[selectedIndex],
                                    isListening ? _colorIntensity * 0.8 : 0,
                                  )!.withOpacity(
                                    isListening
                                        ? 0.7 *
                                              (1 -
                                                  _outerWaveController.value *
                                                      0.4)
                                        : 0.1,
                                  ),
                                  Color.lerp(
                                    Colors.white,
                                    scaffoldColors[selectedIndex],
                                    isListening ? _colorIntensity * 0.6 : 0,
                                  )!.withOpacity(isListening ? 0.3 : 0.05),
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
                              ? 1.0 + (_middleWaveController.value * 0.15)
                              : 1.0,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color.lerp(
                                    Colors.white,
                                    scaffoldColors[selectedIndex],
                                    isListening ? _colorIntensity * 0.9 : 0,
                                  )!.withOpacity(
                                    isListening
                                        ? 0.5 *
                                              (1 -
                                                  _middleWaveController.value *
                                                      0.5)
                                        : 0.15,
                                  ),
                                  Color.lerp(
                                    Colors.white,
                                    scaffoldColors[selectedIndex],
                                    isListening ? _colorIntensity * 0.7 : 0,
                                  )!.withOpacity(isListening ? 0.25 : 0.08),
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
                              ? 1.0 + (_innerWaveController.value * 0.2)
                              : 1.0,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color.lerp(
                                    Colors.white,
                                    scaffoldColors[selectedIndex],
                                    isListening ? _colorIntensity : 0,
                                  )!.withOpacity(
                                    isListening
                                        ? 0.4 *
                                              (1 -
                                                  _innerWaveController.value *
                                                      0.2)
                                        : 0.2,
                                  ),
                                  Color.lerp(
                                    Colors.white,
                                    scaffoldColors[selectedIndex],
                                    isListening ? _colorIntensity * 0.8 : 0,
                                  )!.withOpacity(isListening ? 0.2 : 0.12),
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
                              ? 1.0 + (_pulseController.value * 0.08)
                              : 1.0,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: isListening
                                      ? 20 + (_pulseController.value * 10)
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
            const Spacer(flex: 3),
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
