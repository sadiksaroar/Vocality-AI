import 'dart:async';
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
  Set<int> ownedPersonalities = {};
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
      setState(() {
        _isPurchaseAvailable = false;
      });
      return;
    }

    try {
      _inAppPurchase = InAppPurchase.instance;
      final available = await _inAppPurchase!.isAvailable();

      setState(() {
        _isPurchaseAvailable = available;
      });

      if (!available) {
        print('⚠️ In-app purchases are not available on this device');
        return;
      }

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
      setState(() {
        _isPurchaseAvailable = false;
      });
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

      // Update local storage
      ownedPersonalities.add(personalityId);
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
        await _loadData();
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
        // product
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'In-app purchases are not available on this platform',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Show loading indicator
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    try {
      final available = await _inAppPurchase!.isAvailable();
      if (!available) {
        if (mounted) {
          Navigator.of(context).pop(); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Store is not available'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final ProductDetailsResponse response = await _inAppPurchase!
          .queryProductDetails({productId});

      if (mounted) Navigator.of(context).pop(); // Close loading

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
        // Product not configured in store
        print('⚠️ Product $productId not found in store');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Product not found in store. Please contact support.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      // This will trigger the native store UI (Google Play/App Store)
      bool purchaseInitiated = false;
      if (productId.startsWith('plan_')) {
        purchaseInitiated = await _inAppPurchase!.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      } else {
        purchaseInitiated = await _inAppPurchase!.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: true,
        );
      }

      if (!purchaseInitiated) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to initiate purchase'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Try to close loading if still open
        try {
          Navigator.of(context).pop();
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('❌ Error initiating purchase: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      final timePkgs = await api.getAvailableTimePackages();
      final pers = await api.getAvailablePersonalities();
      final plans = await api.getAvailablePlans();
      final owned = await StorageHelper.getOwnedPersonalities();

      setState(() {
        timePackages = timePkgs;
        personalities = pers;
        subscriptionPlans = plans;
        ownedPersonalities = owned.toSet();
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
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTabButton(
                                'Time Packages',
                                isTimePackagesSelected,
                                () => setState(
                                  () => isTimePackagesSelected = true,
                                ),
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
              childAspectRatio: 0.95,
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
              childAspectRatio: 0.72, // Increased from 0.68 for more height
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
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
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
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 42,
            height: 42,
            child: Assets.icons.min12.image(width: 22, height: 22),
          ),
          const SizedBox(height: 6),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            price,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: () => _initiatePurchase('time_$packageId'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
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
    final personalityId = personality['id'] as int;
    // Only ID 1 is free, all others need to be unlocked
    final isFree = personalityId == 1;
    final isOwned = isFree || ownedPersonalities.contains(personalityId);

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
            flex: 5,
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
                          String.fromCharCode(64 + personalityId),
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
          const SizedBox(height: 4),
          Text(
            personality['name'],
            style: GoogleFonts.roboto(
              color: const Color(0xFF0A0A0A),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            isFree ? 'Free' : '\$${personality['converted_price']}',
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isOwned ? Colors.green : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          if (!isFree) ...[
            Text(
              'One-Time Unlock',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: const Color(0xFF45556C),
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 24,
            child: ElevatedButton.icon(
              onPressed: isOwned
                  ? null
                  : () => _initiatePurchase('personality_$personalityId'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOwned
                    ? Colors.green
                    : colorMap[personalityId] ?? Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
                disabledBackgroundColor: Colors.green,
                disabledForegroundColor: Colors.white,
              ),
              icon: Icon(isOwned ? Icons.check : Icons.lock, size: 10),
              label: Text(
                isOwned ? 'Active' : 'Unlock',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 8,
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
              icon:
                  iconMap[plan['name']]?.image(width: 28, height: 28) ??
                  const SizedBox(width: 28, height: 28),
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
