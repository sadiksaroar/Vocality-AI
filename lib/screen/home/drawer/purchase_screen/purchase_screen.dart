import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/widget/text/text.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool isTimePackagesSelected = true;

  final List<Map<String, String>> timePackages = List.generate(
    6,
    (index) => {'duration': '12 min', 'price': '\$4.99'},
  );

  final List<Map<String, dynamic>> personalities = [
    {
      'id': 'A',
      'name': 'Personality A',
      'time': 'One free unlock',
      'price': 'Free',
      'imageAsset': Assets.icons.a,
      'buttonColor': Colors.green,
      'unlocked': true,
    },
    {
      'id': 'B',
      'name': 'Personality B',
      'time': 'One free unlock',
      'price': '\$29.99',
      'imageAsset': Assets.icons.b,
      'buttonColor': Colors.pink,
      'unlocked': false,
    },
    {
      'id': 'C',
      'name': 'Personality C',
      'time': 'One free unlock',
      'price': '\$39.99',
      'imageAsset': Assets.icons.c,
      'buttonColor': Colors.pink.shade700,
      'unlocked': false,
    },
    {
      'id': 'D',
      'name': 'Personality D',
      'time': 'One free unlock',
      'price': '\$49.99',
      'imageAsset': Assets.icons.d,
      'buttonColor': Colors.blue.shade800,
      'unlocked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade600,
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade600,
        elevation: 0,
        leading: IconButton(
          icon: Assets.icons.backIcon.image(width: 24, height: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tab Buttons
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        'Time Packages',
                        isTimePackagesSelected,
                        () => setState(() => isTimePackagesSelected = true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTabButton(
                        'Subscriptions',
                        !isTimePackagesSelected,
                        () => setState(() => isTimePackagesSelected = false),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Scrollable Content - Show based on selected tab
              Expanded(
                child: isTimePackagesSelected
                    ? _buildTimePackagesContent()
                    : const SubscriptionPlansScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePackagesContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Packages Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: timePackages.length,
            itemBuilder: (context, index) {
              return _buildTimePackageCard(
                timePackages[index]['duration']!,
                timePackages[index]['price']!,
              );
            },
          ),

          const SizedBox(height: 32),

          // Unlock Personalities Section
          Text(
            'Unlock Personalities',
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            'Choose the AI personality that suits you best',
            style: MyTextStyles.subHeading,
          ),
          const SizedBox(height: 24),

          // Personalities Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemCount: personalities.length,
            itemBuilder: (context, index) {
              return _buildPersonalityCard(personalities[index]);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePackageCard(String duration, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Assets.icons.min12.image(width: 24, height: 24),
          ),
          const SizedBox(height: 8),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 47,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: Text('Purchase', style: MyTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityCard(Map<String, dynamic> personality) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Personality Icon Box with Background Text
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Background ID Text
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        personality['id'],
                        style: TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                  ),
                ),
                // Image Overlay
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: personality['imageAsset'].image(fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            personality['name'],
            style: GoogleFonts.roboto(
              color: const Color(0xFF0A0A0A),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            personality['time'],
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              color: const Color(0xFF45556C),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            personality['price'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: personality['unlocked'] ? Colors.green : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: personality['unlocked']
                    ? Colors.green
                    : personality['buttonColor'],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.lock, size: 14),
              label: Text(
                personality['unlocked'] ? 'Active' : 'Unlock',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlanCard(
            icon: Image.asset(Assets.icons.basic.path, width: 28, height: 28),
            // iconColor: Colors.grey[600]!,
            // iconBgColor: Colors.grey[100]!,
            planName: 'Basic',
            price: '\$14.99',
            period: '/month',
            features: const [
              '20 minutes per day',
              'American A mode',
              'Basic voice quality',
              'Email support',
            ],
            buttonColor: Colors.grey[200]!,
            buttonTextColor: Colors.grey[700]!,
          ),
          const SizedBox(height: 16),
          PlanCard(
            icon: Image.asset(Assets.icons.premium.path, width: 28, height: 28),
            // iconColor: Colors.yellow[700]!,
            // iconBgColor: Colors.yellow[100]!,
            planName: 'Premium',
            price: '\$29.99',
            period: '/2 months',
            features: const [
              '60 minutes per day',
              'All American personalities',
              'HD voice quality',
              'Priority support',
            ],
            buttonColor: Colors.yellow[700]!,
            buttonTextColor: Colors.white,
            isPremium: true,
          ),
          const SizedBox(height: 16),
          PlanCard(
            icon: Image.asset(
              Assets.icons.ultimate.path,
              width: 28,
              height: 28,
            ),
            // iconColor: Colors.grey[600]!,
            // iconBgColor: Colors.grey[100]!,
            planName: 'Ultimate',
            price: '\$49.99',
            period: '/2 months',
            features: const [
              'Unlimited minutes per day',
              'All American personalities',
              'Premium HD voice',
              '24/7 Priority support',
            ],
            buttonColor: Colors.grey[200]!,
            buttonTextColor: Colors.grey[700]!,
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final Widget icon; // Changed from IconData to Widget

  final String planName;
  final String price;
  final String period;
  final List<String> features;
  final Color buttonColor;
  final Color buttonTextColor;
  final bool isPremium;

  const PlanCard({
    Key? key,
    required this.icon,

    required this.planName,
    required this.price,
    required this.period,
    required this.features,
    required this.buttonColor,
    required this.buttonTextColor,
    this.isPremium = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),

                child:
                    icon, // Changed from Icon widget to directly use the widget
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        period,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Features
          ...features
              .map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(Icons.check, color: Colors.grey[400], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),

          const SizedBox(height: 8),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Subscribe Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
