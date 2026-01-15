import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/widget/text/text.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  static const String _lastUpdated = 'Dec 28, 2025';
  static const String _version = 'v1.2';

  static const List<_PolicySection> _sections = [
    _PolicySection(
      title: 'Information we collect',
      intro:
          'We only collect the details needed to run core voice and account features.',
      bullets: [
        'Account basics: name, email, and subscription status.',
        'Usage insights: device type, app version, crash reports, and feature interactions to keep things reliable.',
        'Voice data: audio you intentionally record; processed securely and not used to train public models.',
      ],
    ),
    _PolicySection(
      title: 'How we use your data',
      intro: 'Data powers the product and helps us keep improving it.',
      bullets: [
        'Deliver voice transcription, synthesis, and responses tuned to your preferences.',
        'Maintain conversation context, prevent abuse, and ensure service uptime.',
        'Research aggregate trends to improve quality without identifying you.',
      ],
    ),
    _PolicySection(
      title: 'Storage and retention',
      intro: 'We minimize how long we keep identifiable data.',
      bullets: [
        'Audio requests are processed transiently and discarded unless you save transcripts.',
        'Data is encrypted in transit and at rest; access is restricted to authorized staff.',
        'You can ask us to delete saved sessions or exports by reaching out to support.',
      ],
    ),
    _PolicySection(
      title: 'Sharing and third parties',
      intro:
          'Your information stays private and is never sold. Limited sharing happens only when needed to operate the service.',
      bullets: [
        'We work with vetted infrastructure and analytics providers under strict data-protection terms.',
        'We may share data to comply with legal obligations or to prevent fraud and misuse.',
        'If business ownership changes, we will continue to protect your data under this policy.',
      ],
    ),
    _PolicySection(
      title: 'Your choices and control',
      intro: 'You stay in control of how and when we use your data.',
      bullets: [
        'Manage microphone and notification permissions from your device settings.',
        'Request export or deletion of your information by contacting support.',
        'Opt out of marketing communications at any time; service emails may still be required.',
      ],
    ),
    _PolicySection(
      title: 'Childrens privacy',
      intro:
          'Vocality AI is not designed for children under 13. If you believe a child has provided data, let us know so we can remove it.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD500),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD500),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(Assets.icons.backIcon.path, width: 40, height: 40),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text('Privacy Policy', style: MyTextStyles.poppinsBold),
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(context),
              const SizedBox(height: 16),
              ..._sections.map(_buildSection).toList(),
              const SizedBox(height: 20),
              _buildSupportCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1F44).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFF0A1F44),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your data stays in your control',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'We are transparent about what we collect, why, and how to manage it.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF667085),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Color(0xFF475467),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Last updated: $_lastUpdated',
                    style: MyTextStyles.userName,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.tag_outlined,
                    size: 16,
                    color: Color(0xFF475467),
                  ),
                  const SizedBox(width: 8),
                  Text('Version $_version', style: MyTextStyles.userName),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(_PolicySection section) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            section.intro,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
          if (section.bullets.isNotEmpty) ...[
            const SizedBox(height: 12),
            Column(
              children: section.bullets
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6, right: 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0A1F44),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF111827),
                                height: 1.55,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF0A1F44), Color(0xFF132B5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need help or want something removed?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Email support@vocality.ai with your request and we will respond promptly.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white70),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // This can be wired to a mailto: link or in-app support flow.
            },
            icon: const Icon(Icons.mail_outline, size: 18),
            label: Text(
              'Contact support',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  final String title;
  final String intro;
  final List<String> bullets;

  const _PolicySection({
    required this.title,
    required this.intro,
    this.bullets = const [],
  });
}
