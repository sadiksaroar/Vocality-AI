import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/core/network/api_service.dart';
import 'package:vocality_ai/core/storage_helper.dart';
import 'package:vocality_ai/widget/text/text.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool isTimePackagesSelected = true;
  final api = ApiService();

  List<Map<String, dynamic>> timePackages = [];
  List<Map<String, dynamic>> personalities = [];
  List<Map<String, dynamic>> subscriptionPlans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final timePkgs = await api.getAvailableTimePackages();
      final pers = await api.getAvailablePersonalities();
      final plans = await api.getAvailablePlans();

      setState(() {
        timePackages = timePkgs;
        personalities = pers;
        subscriptionPlans = plans;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading purchase data: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade600,
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade600,
        elevation: 0,
        leading: IconButton(
          icon: Assets.icons.backIcon.image(width: 44, height: 44),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                              () =>
                                  setState(() => isTimePackagesSelected = true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildTabButton(
                              'Subscriptions',
                              !isTimePackagesSelected,
                              () => setState(
                                () => isTimePackagesSelected = false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: isTimePackagesSelected
                          ? _buildTimePackagesContent()
                          : SubscriptionPlansScreen(plans: subscriptionPlans),
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
              final pkg = timePackages[index];
              return _buildTimePackageCard(
                pkg['time_value'] ?? '',
                '\$${pkg['converted_price']}',
                pkg['id'],
                pkg,
              );
            },
          ),
          const SizedBox(height: 32),
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
              final pers = personalities[index];
              return _buildPersonalityCard(pers);
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

  Widget _buildTimePackageCard(
    String duration,
    String price,
    int packageId,
    Map<String, dynamic> pkg,
  ) {
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
              onPressed: () async {
                // TODO: Integrate payment gateway here
                try {
                  final mockPaymentId =
                      'dev_${DateTime.now().millisecondsSinceEpoch}';
                  await api.purchaseTimePackage(
                    packageId,
                    paymentId: mockPaymentId,
                    amountPaid: pkg['converted_price'].toString(),
                    currency: 'USD',
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Purchase successful! (Payment gateway coming soon)',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
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
    final personalityId = personality['id'];
    final isOwned = personality['is_owned'] ?? false;
    final isFree = personality['is_free'] ?? false;

    final assetMap = {
      1: Assets.icons.a,
      2: Assets.icons.b,
      3: Assets.icons.c,
      4: Assets.icons.d,
    };

    final colorMap = {
      1: Colors.green,
      2: Colors.pink,
      3: Colors.pink.shade700,
      4: Colors.blue.shade800,
    };

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
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          assetMap[personalityId]?.image(fit: BoxFit.cover) ??
                          Container(),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(64 + (personalityId as int)),
                          style: GoogleFonts.roboto(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            personality['name'],
            style: GoogleFonts.roboto(
              color: const Color(0xFF0A0A0A),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            isFree ? 'Free' : '\$${personality['converted_price']}',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isOwned || isFree ? Colors.green : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          if (!isFree) ...[
            const SizedBox(height: 1),
            Text(
              'One-Time Unlock',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: const Color(0xFF45556C),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 26,
            child: ElevatedButton.icon(
              onPressed: isOwned || isFree
                  ? null
                  : () async {
                      // TODO: Integrate payment gateway here
                      try {
                        final mockPaymentId =
                            'dev_${DateTime.now().millisecondsSinceEpoch}';
                        await api.purchasePersonality(
                          personalityId,
                          paymentId: mockPaymentId,
                          amountPaid: personality['converted_price'].toString(),
                          currency: 'USD',
                        );

                        // Update local storage
                        final currentOwned =
                            await StorageHelper.getOwnedPersonalities();
                        if (!currentOwned.contains(personalityId)) {
                          currentOwned.add(personalityId);
                          await StorageHelper.saveOwnedPersonalities(
                            currentOwned,
                          );
                        }

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Purchase successful! (Payment gateway coming soon)',
                              ),
                            ),
                          );
                          Navigator.of(context).pop(
                            true,
                          ); // Return true to indicate purchase success
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isOwned || isFree
                    ? Colors.green
                    : colorMap[personalityId] ?? Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              icon: Icon(
                isOwned || isFree ? Icons.check : Icons.lock,
                size: 11,
              ),
              label: Text(
                isOwned || isFree ? 'Active' : 'Unlock',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
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
  final List<Map<String, dynamic>> plans;

  const SubscriptionPlansScreen({Key? key, required this.plans})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: plans.map((plan) {
          final iconMap = {
            'Basic': Assets.icons.basic,
            'Premium': Assets.icons.premium,
            'Ultimate': Assets.icons.ultimate,
          };

          final colorMap = {
            'Basic': Colors.grey[200]!,
            'Premium': Colors.yellow[700]!,
            'Ultimate': Colors.grey[200]!,
          };

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PlanCard(
              icon: Image.asset(
                iconMap[plan['name']]?.path ?? '',
                width: 28,
                height: 28,
              ),
              planName: plan['name'],
              price: '\$${plan['converted_price']}',
              period: '/${plan['time_value']}',
              features: _getFeatures(plan['name']),
              buttonColor: colorMap[plan['name']] ?? Colors.grey[200]!,
              buttonTextColor: plan['name'] == 'Premium'
                  ? Colors.white
                  : Colors.grey[700]!,
              isPremium: plan['name'] == 'Premium',
              isActive: plan['is_active'] ?? false,
              planId: plan['id'],
              convertedPrice: double.parse(plan['converted_price'].toString()),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<String> _getFeatures(String planName) {
    switch (planName) {
      case 'Basic':
        return [
          '20 minutes per day',
          'American A mode',
          'Basic voice quality',
          'Email support',
        ];
      case 'Premium':
        return [
          '60 minutes per day',
          'All American personalities',
          'HD voice quality',
          'Priority support',
        ];
      case 'Ultimate':
        return [
          'Unlimited minutes per day',
          'All American personalities',
          'Premium HD voice',
          '24/7 Priority support',
        ];
      default:
        return [];
    }
  }
}

class PlanCard extends StatelessWidget {
  final Widget icon;
  final String planName;
  final String price;
  final String period;
  final List<String> features;
  final Color buttonColor;
  final Color buttonTextColor;
  final bool isPremium;
  final bool isActive;
  final int planId;
  final double convertedPrice;

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
    this.isActive = false,
    required this.planId,
    required this.convertedPrice,
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
          Row(
            children: [
              Container(padding: const EdgeInsets.all(10), child: icon),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isActive
                  ? null
                  : () async {
                      // TODO: Integrate payment gateway here
                      try {
                        final api = ApiService();
                        final mockPaymentId =
                            'dev_${DateTime.now().millisecondsSinceEpoch}';
                        await api.subscribeToPlan(
                          planId,
                          paymentId: mockPaymentId,
                          amountPaid: convertedPrice.toString(),
                          currency: 'USD',
                        );

                        // Update local storage
                        await StorageHelper.saveActiveSubscription(planId);
                        await StorageHelper.setPremiumStatus(true);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Subscription successful! (Payment gateway coming soon)',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? Colors.green : buttonColor,
                foregroundColor: buttonTextColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                isActive ? 'Active Plan' : 'Subscribe Now',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/core/network/api_service.dart';
import 'package:vocality_ai/core/storage_helper.dart';
import 'package:vocality_ai/widget/text/text.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool isTimePackagesSelected = true;
  final api = ApiService();
  InAppPurchase? _inAppPurchase;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  List<Map<String, dynamic>> timePackages = [];
  List<Map<String, dynamic>> personalities = [];
  List<Map<String, dynamic>> subscriptionPlans = [];
  bool isLoading = true;
  bool _isPurchaseAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initializePurchaseListener();
  }

  Future<void> _initializePurchaseListener() async {
    // In-app purchases are not supported on web
    if (kIsWeb) {
      print('⚠️ In-app purchases are not supported on web platform');
      return;
    }

    try {
      _inAppPurchase = InAppPurchase.instance;
      final available = await _inAppPurchase!.isAvailable();
      if (!available) {
        print('⚠️ In-app purchases are not available on this device');
        return;
      }

      setState(() {
        _isPurchaseAvailable = true;
      });

      final Stream<List<PurchaseDetails>> purchaseUpdated =
          _inAppPurchase!.purchaseStream;
      _subscription = purchaseUpdated.listen(
        (purchaseDetailsList) {
          _handlePurchaseUpdates(purchaseDetailsList);
        },
        onDone: () {
          _subscription?.cancel();
        },
        onError: (error) {
          print('❌ Purchase stream error: $error');
        },
      );
    } catch (e) {
      print('⚠️ Error initializing purchase listener: $e');
    }
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    if (_inAppPurchase == null) return;

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final productId = purchaseDetails.productID;
        await _processPurchase(purchaseDetails, productId);

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase!.completePurchase(purchaseDetails);
        }
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Purchase failed: ${purchaseDetails.error?.message ?? "Unknown error"}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchase canceled'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  Future<void> _processPurchase(
    PurchaseDetails purchaseDetails,
    String productId,
  ) async {
    try {
      if (productId.startsWith('time_')) {
        final id = int.parse(productId.split('_')[1]);
        await _completeTimePackagePurchase(id, purchaseDetails);
      } else if (productId.startsWith('personality_')) {
        final id = int.parse(productId.split('_')[1]);
        await _completePersonalityPurchase(id, purchaseDetails);
      } else if (productId.startsWith('plan_')) {
        final id = int.parse(productId.split('_')[1]);
        await _completePlanPurchase(id, purchaseDetails);
      }
    } catch (e) {
      print('❌ Error processing purchase: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing purchase: $e')),
        );
      }
    }
  }

  Future<void> _completeTimePackagePurchase(
    int packageId,
    PurchaseDetails details,
  ) async {
    try {
      final pkg = timePackages.firstWhere((p) => p['id'] == packageId);
      await api.purchaseTimePackage(
        packageId,
        paymentId: details.purchaseID ?? '',
        amountPaid: pkg['converted_price'].toString(),
        currency: 'USD',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Time package purchased successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadData();
      }
    } catch (e) {
      print('❌ Error completing time package purchase: $e');
      rethrow;
    }
  }

  Future<void> _completePersonalityPurchase(
    int personalityId,
    PurchaseDetails details,
  ) async {
    try {
      final pers = personalities.firstWhere((p) => p['id'] == personalityId);
      await api.purchasePersonality(
        personalityId,
        paymentId: details.purchaseID ?? '',
        amountPaid: pers['converted_price'].toString(),
        currency: 'USD',
      );

      final currentOwned = await StorageHelper.getOwnedPersonalities();
      if (!currentOwned.contains(personalityId)) {
        currentOwned.add(personalityId);
        await StorageHelper.saveOwnedPersonalities(currentOwned);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Personality unlocked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('❌ Error completing personality purchase: $e');
      rethrow;
    }
  }

  Future<void> _completePlanPurchase(
    int planId,
    PurchaseDetails details,
  ) async {
    try {
      final plan = subscriptionPlans.firstWhere((p) => p['id'] == planId);
      await api.subscribeToPlan(
        planId,
        paymentId: details.purchaseID ?? '',
        amountPaid: plan['converted_price'].toString(),
        currency: 'USD',
      );

      await StorageHelper.saveActiveSubscription(planId);
      await StorageHelper.setPremiumStatus(true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription activated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadData();
      }
    } catch (e) {
      print('❌ Error completing plan purchase: $e');
      rethrow;
    }
  }

  Future<void> _initiatePurchase(String productId) async {
    // Check if purchases are available for this platform
    if (kIsWeb || !_isPurchaseAvailable || _inAppPurchase == null) {
      // Fallback to direct purchase for web or when IAP is not available
      await _directPurchase(productId);
      return;
    }

    try {
      final available = await _inAppPurchase!.isAvailable();
      if (!available) {
        // Fallback to direct purchase
        await _directPurchase(productId);
        return;
      }

      final ProductDetailsResponse response = await _inAppPurchase!
          .queryProductDetails({productId});

      if (response.error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.error!.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (response.productDetails.isEmpty) {
        // Product not configured in store - fallback to direct purchase
        print(
          '⚠️ Product $productId not found in store, using direct purchase',
        );
        await _directPurchase(productId);
        return;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      if (productId.startsWith('plan_')) {
        await _inAppPurchase!.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _inAppPurchase!.buyConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      print('❌ Error initiating purchase: $e');
      // Fallback to direct purchase on error
      await _directPurchase(productId);
    }
  }

  // Direct purchase fallback when IAP is not available
  Future<void> _directPurchase(String productId) async {
    if (!mounted) return;

    // Process the purchase
    try {
      if (productId.startsWith('time_')) {
        final id = int.parse(productId.split('_')[1]);
        await _processDirectTimePackagePurchase(id);
      } else if (productId.startsWith('personality_')) {
        final id = int.parse(productId.split('_')[1]);
        await _processDirectPersonalityPurchase(id);
      } else if (productId.startsWith('plan_')) {
        final id = int.parse(productId.split('_')[1]);
        await _processDirectPlanPurchase(id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Process direct time package purchase
  Future<void> _processDirectTimePackagePurchase(int packageId) async {
    try {
      final pkg = timePackages.firstWhere((p) => p['id'] == packageId);

      // Generate mock payment ID for development
      final mockPaymentId = 'dev_${DateTime.now().millisecondsSinceEpoch}';

      await api.purchaseTimePackage(
        packageId,
        paymentId: mockPaymentId,
        amountPaid: pkg['converted_price'].toString(),
        currency: 'USD',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Time package purchased successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadData();
      }
    } catch (e) {
      print('❌ Error processing time package purchase: $e');
      rethrow;
    }
  }

  // Process direct personality purchase
  Future<void> _processDirectPersonalityPurchase(int personalityId) async {
    try {
      final pers = personalities.firstWhere((p) => p['id'] == personalityId);

      // Generate mock payment ID for development
      final mockPaymentId = 'dev_${DateTime.now().millisecondsSinceEpoch}';

      await api.purchasePersonality(
        personalityId,
        paymentId: mockPaymentId,
        amountPaid: pers['converted_price'].toString(),
        currency: 'USD',
      );

      final currentOwned = await StorageHelper.getOwnedPersonalities();
      if (!currentOwned.contains(personalityId)) {
        currentOwned.add(personalityId);
        await StorageHelper.saveOwnedPersonalities(currentOwned);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Personality unlocked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('❌ Error processing personality purchase: $e');
      rethrow;
    }
  }

  // Process direct plan purchase
  Future<void> _processDirectPlanPurchase(int planId) async {
    try {
      final plan = subscriptionPlans.firstWhere((p) => p['id'] == planId);

      // Generate mock payment ID for development
      final mockPaymentId = 'dev_${DateTime.now().millisecondsSinceEpoch}';

      await api.subscribeToPlan(
        planId,
        paymentId: mockPaymentId,
        amountPaid: plan['converted_price'].toString(),
        currency: 'USD',
      );

      await StorageHelper.saveActiveSubscription(planId);
      await StorageHelper.setPremiumStatus(true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription activated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadData();
      }
    } catch (e) {
      print('❌ Error processing plan purchase: $e');
      rethrow;
    }
  }

  Future<void> _loadData() async {
    try {
      final timePkgs = await api.getAvailableTimePackages();
      final pers = await api.getAvailablePersonalities();
      final plans = await api.getAvailablePlans();

      setState(() {
        timePackages = timePkgs;
        personalities = pers;
        subscriptionPlans = plans;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading purchase data: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade600,
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade600,
        elevation: 0,
        leading: IconButton(
          icon: Assets.icons.backIcon.image(width: 44, height: 44),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                              () =>
                                  setState(() => isTimePackagesSelected = true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildTabButton(
                              'Subscriptions',
                              !isTimePackagesSelected,
                              () => setState(
                                () => isTimePackagesSelected = false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: isTimePackagesSelected
                          ? _buildTimePackagesContent()
                          : SubscriptionPlansScreen(
                              plans: subscriptionPlans,
                              onPurchase: _initiatePurchase,
                            ),
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
              final pkg = timePackages[index];
              return _buildTimePackageCard(
                pkg['time_value'] ?? '',
                '\$${pkg['converted_price']}',
                pkg['id'],
              );
            },
          ),
          const SizedBox(height: 32),
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
              final pers = personalities[index];
              return _buildPersonalityCard(pers);
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

  Widget _buildTimePackageCard(String duration, String price, int packageId) {
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
              onPressed: () => _initiatePurchase('time_$packageId'),
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
    final personalityId = personality['id'];
    final isOwned = personality['is_owned'] ?? false;
    final isFree = personality['is_free'] ?? false;

    final assetMap = {
      1: Assets.icons.a,
      2: Assets.icons.b,
      3: Assets.icons.c,
      4: Assets.icons.d,
    };

    final colorMap = {
      1: Colors.green,
      2: Colors.pink,
      3: Colors.pink.shade700,
      4: Colors.blue.shade800,
    };

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
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          assetMap[personalityId]?.image(fit: BoxFit.cover) ??
                          Container(),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(64 + (personalityId as int)),
                          style: GoogleFonts.roboto(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            personality['name'],
            style: GoogleFonts.roboto(
              color: const Color(0xFF0A0A0A),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            isFree ? 'Free' : '\$${personality['converted_price']}',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isOwned || isFree ? Colors.green : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          if (!isFree) ...[
            const SizedBox(height: 1),
            Text(
              'One-Time Unlock',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: const Color(0xFF45556C),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 26,
            child: ElevatedButton.icon(
              onPressed: isOwned || isFree
                  ? null
                  : () => _initiatePurchase('personality_$personalityId'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOwned || isFree
                    ? Colors.green
                    : colorMap[personalityId] ?? Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              icon: Icon(
                isOwned || isFree ? Icons.check : Icons.lock,
                size: 11,
              ),
              label: Text(
                isOwned || isFree ? 'Active' : 'Unlock',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
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
  final List<Map<String, dynamic>> plans;
  final Function(String) onPurchase;

  const SubscriptionPlansScreen({
    Key? key,
    required this.plans,
    required this.onPurchase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: plans.map((plan) {
          final iconMap = {
            'Basic': Assets.icons.basic,
            'Premium': Assets.icons.premium,
            'Ultimate': Assets.icons.ultimate,
          };

          final colorMap = {
            'Basic': Colors.grey[200]!,
            'Premium': Colors.yellow[700]!,
            'Ultimate': Colors.grey[200]!,
          };

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PlanCard(
              icon: Image.asset(
                iconMap[plan['name']]?.path ?? '',
                width: 28,
                height: 28,
              ),
              planName: plan['name'],
              price: '\$${plan['converted_price']}',
              period: '/${plan['time_value']}',
              features: _getFeatures(plan['name']),
              buttonColor: colorMap[plan['name']] ?? Colors.grey[200]!,
              buttonTextColor: plan['name'] == 'Premium'
                  ? Colors.white
                  : Colors.grey[700]!,
              isPremium: plan['name'] == 'Premium',
              isActive: plan['is_active'] ?? false,
              planId: plan['id'],
              onSubscribe: () => onPurchase('plan_${plan['id']}'),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<String> _getFeatures(String planName) {
    switch (planName) {
      case 'Basic':
        return [
          '20 minutes per day',
          'American A mode',
          'Basic voice quality',
          'Email support',
        ];
      case 'Premium':
        return [
          '60 minutes per day',
          'All American personalities',
          'HD voice quality',
          'Priority support',
        ];
      case 'Ultimate':
        return [
          'Unlimited minutes per day',
          'All American personalities',
          'Premium HD voice',
          '24/7 Priority support',
        ];
      default:
        return [];
    }
  }
}

class PlanCard extends StatelessWidget {
  final Widget icon;
  final String planName;
  final String price;
  final String period;
  final List<String> features;
  final Color buttonColor;
  final Color buttonTextColor;
  final bool isPremium;
  final bool isActive;
  final int planId;
  final VoidCallback? onSubscribe;

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
    this.isActive = false,
    required this.planId,
    this.onSubscribe,
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
          Row(
            children: [
              Container(padding: const EdgeInsets.all(10), child: icon),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isActive ? null : onSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? Colors.green : buttonColor,
                foregroundColor: buttonTextColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                isActive ? 'Active Plan' : 'Subscribe Now',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
