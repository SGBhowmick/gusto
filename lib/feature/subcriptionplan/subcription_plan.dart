import 'dart:async';
import 'package:dusto/feature/subcriptionplan/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dusto/utils/core_export.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'subscription_bottom_sheet.dart';
import 'subscription_plan_model.dart';

// --- Logic Fix: Using UserInfoModel ID ---
String _getCurrentUserId() {
  try {
    final userController = Get.find<UserController>();
    return userController.userInfoModel?.id?.toString() ?? "guest";
  } catch (e) {
    return "guest";
  }
}

class SubscriptionTriggerWidget extends StatefulWidget {
  const SubscriptionTriggerWidget({super.key});

  @override
  State<SubscriptionTriggerWidget> createState() =>
      _SubscriptionTriggerWidgetState();
}

class _SubscriptionTriggerWidgetState extends State<SubscriptionTriggerWidget>
    with WidgetsBindingObserver {
  bool _isSubscribed = false;
  bool _isExpired = false;
  DateTime? _expiryDate;
  Timer? _timer;
  String _countdownText = "";
  String _lastCheckedId = ""; // Track the ID to detect user swaps

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSubscriptionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadSubscriptionStatus();
    }
  }

  void _resetState() {
    if (mounted) {
      setState(() {
        _isSubscribed = false;
        _isExpired = false;
        _expiryDate = null;
        _countdownText = "";
        _timer?.cancel();
      });
    }
  }

  Future<void> _loadSubscriptionStatus() async {
    final authController = Get.find<AuthController>();
    String userId = _getCurrentUserId();

    _lastCheckedId = userId; // Update the last checked ID

    if (!authController.isLoggedIn() || userId == "guest") {
      _resetState();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String key = 'sub_expiry_$userId';
    final String? expiryStr = prefs.getString(key);

    if (expiryStr != null) {
      final expiry = DateTime.parse(expiryStr);
      final now = DateTime.now();

      if (expiry.isAfter(now)) {
        if (mounted) {
          setState(() {
            _isSubscribed = true;
            _isExpired = false;
            _expiryDate = expiry;
          });
        }
        _startTimer();
      } else {
        if (mounted) {
          setState(() {
            _isSubscribed = false;
            _isExpired = true;
            _timer?.cancel();
          });
        }
      }
    } else {
      _resetState();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _updateCountdown();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _updateCountdown(),
    );
  }

  void _updateCountdown() {
    if (_expiryDate == null) return;
    final diff = _expiryDate!.difference(DateTime.now());

    if (diff.isNegative) {
      _timer?.cancel();
      if (mounted)
        setState(() {
          _isSubscribed = false;
          _isExpired = true;
        });
      return;
    }

    if (mounted) {
      setState(() {
        _countdownText =
            "${diff.inDays}d ${diff.inHours % 24}h ${diff.inMinutes % 60}m ${diff.inSeconds % 60}s";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Using GetBuilder to listen for user data changes
    return GetBuilder<UserController>(
      builder: (userController) {
        String currentId =
            userController.userInfoModel?.id?.toString() ?? "guest";

        // If the User ID has changed (login/logout/refresh), re-load the sub status
        if (currentId != _lastCheckedId) {
          _loadSubscriptionStatus();
        }

        if (!Get.find<AuthController>().isLoggedIn() || currentId == "guest") {
          return _buildTriggerBanner(theme);
        }

        if (_isSubscribed) return _buildActiveSubscriptionBanner(theme);
        if (_isExpired) return _buildExpiredBanner(theme);
        return _buildTriggerBanner(theme);
      },
    );
  }

  // --- UI BANNERS (Banners code remains the same as before) ---
  Widget _buildActiveSubscriptionBanner(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF009944), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.green.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF009944),
            size: 40,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pro Plan Active",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ends in: $_countdownText",
                  style: const TextStyle(
                    color: Color(0xFFDAA520),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Badge(
            label: Text("PRO"),
            backgroundColor: Color(0xFFFFD700),
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredBanner(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.red.withOpacity(0.1), blurRadius: 15),
        ],
      ),
      child: Material(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _showSubscriptionSheet(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.redAccent, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.history_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Plan Expired",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const Text(
                        "Renew now to stay Premium",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "RENEW",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTriggerBanner(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDAA520).withOpacity(0.2),
            blurRadius: 15,
          ),
        ],
      ),
      child: Material(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => Get.find<AuthController>().isLoggedIn()
              ? _showSubscriptionSheet(context)
              : Get.toNamed(RouteHelper.getSignInRoute()),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFDAA520), width: 1),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFDAA520),
                  size: 28,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "Upgrade My Subscription",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Color(0xFFDAA520),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSubscriptionSheet(BuildContext context) {
    Get.bottomSheet(
      const SubscriptionBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
// --- PROFILE BADGE ---

class ProfileSubscriptionBadge extends StatefulWidget {
  const ProfileSubscriptionBadge({super.key});

  @override
  State<ProfileSubscriptionBadge> createState() =>
      _ProfileSubscriptionBadgeState();
}

class _ProfileSubscriptionBadgeState extends State<ProfileSubscriptionBadge> {
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final authController = Get.find<AuthController>();
    final userId = _getCurrentUserId();

    if (!authController.isLoggedIn() || userId == "guest") {
      if (mounted) setState(() => _isSubscribed = false);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? expiryStr = prefs.getString('sub_expiry_$userId');

    if (expiryStr != null) {
      final expiry = DateTime.parse(expiryStr);
      if (expiry.isAfter(DateTime.now())) {
        if (mounted) setState(() => _isSubscribed = true);
        return;
      }
    }
    if (mounted) setState(() => _isSubscribed = false);
  }

  @override
  Widget build(BuildContext context) {
    // Re-check status on every build to handle logouts instantly
    _checkStatus();

    if (!_isSubscribed) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.verified_user_rounded, color: Color(0xFF009944), size: 16),
          SizedBox(width: 6),
          Text(
            "Premium Member",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 3. PAYMENT OPTIONS PAGE ---

class PaymentOptionsPage extends StatefulWidget {
  final SubscriptionPlan selectedPlan;
  final VoidCallback onPaymentSuccess;
  const PaymentOptionsPage({
    super.key,
    required this.selectedPlan,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentOptionsPage> createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  bool _isLoading = false;
  int _selectedMethod = 0; // Default to online payment

  void _confirmPayment() async {
    setState(() => _isLoading = true);

    if (_selectedMethod == 0) {
      // Online Payment via API
      final subController = Get.find<SubscriptionController>();
      String? url = await subController.checkoutSubscription(
        widget.selectedPlan.id ?? '',
      );

      setState(() => _isLoading = false);

      if (url != null && url.isNotEmpty) {
        final result = await Get.to(() => SubscriptionPaymentWebView(url: url));
        if (result == true) {
          widget.onPaymentSuccess();
          if (mounted) Navigator.pop(context);
          _showSuccessDialog();
        } else {
          _showFailureDialog();
        }
      } else {
        customSnackBar('Failed to generate payment url');
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
      widget.onPaymentSuccess();
      if (mounted) Navigator.pop(context);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF009944),
                size: 80,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              Text(
                "Subscription Successful!",
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(
                "You have successfully subscribed to the ${widget.selectedPlan.name} plan. You can now enjoy premium benefits.",
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009944),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusDefault,
                      ),
                    ),
                  ),
                  child: Text(
                    "Awesome",
                    style: robotoBold.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFailureDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 80,
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              Text(
                "Payment Failed",
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(
                "Your payment could not be processed or was cancelled. Please try again.",
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusDefault,
                      ),
                    ),
                  ),
                  child: Text(
                    "Try Again",
                    style: robotoBold.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"), centerTitle: true),
      bottomNavigationBar: _isLoading
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _confirmPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009944),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Confirm Payment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF009944)),
                  const SizedBox(height: 20),
                  Text(
                    "Confirming Subscription...",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.selectedPlan.name ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "\$${widget.selectedPlan.price}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF009944),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        ...(widget.selectedPlan.benefits ?? [])
                            .take(3)
                            .map(
                              (f) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        f,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Payment Method",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _paymentTile(
                    0,
                    "Online Payment",
                    "Pay via Nomad",
                    Icons.credit_card,
                    true,
                    () => setState(() => _selectedMethod = 0),
                  ),
                  const SizedBox(height: 12),
                  _paymentTile(
                    1,
                    "Cash on Delivery",
                    "Pay at doorstep",
                    Icons.payments,
                    true,
                    () => setState(() => _selectedMethod = 1),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _paymentTile(
    int index,
    String title,
    String sub,
    IconData icon,
    bool available,
    VoidCallback onTap,
  ) {
    bool isSelected = _selectedMethod == index;
    return InkWell(
      onTap: available
          ? onTap
          : () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Unavailable"))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected && available
                ? const Color(0xFF009944)
                : Colors.grey[300]!,
          ),
          color: isSelected && available
              ? const Color(0xFF009944).withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: available ? const Color(0xFF009944) : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: available ? Colors.black : Colors.grey,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 12,
                      color: available ? Colors.black54 : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected && available
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: available ? const Color(0xFF009944) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionPaymentWebView extends StatefulWidget {
  final String url;
  const SubscriptionPaymentWebView({super.key, required this.url});

  @override
  State<SubscriptionPaymentWebView> createState() =>
      _SubscriptionPaymentWebViewState();
}

class _SubscriptionPaymentWebViewState
    extends State<SubscriptionPaymentWebView> {
  bool _isLoading = true;
  bool _isPopped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            _isPopped = true;
            Get.back(result: false);
          },
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            onLoadStart: (controller, url) {
              _checkUrl(url.toString());
            },
            onLoadStop: (controller, url) {
              setState(() => _isLoading = false);
              _checkUrl(url.toString());
            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
                setState(() => _isLoading = false);
              }
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF009944)),
            ),
        ],
      ),
    );
  }

  void _checkUrl(String url) {
    if (_isPopped) return;

    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('success') || lowerUrl.contains('successful')) {
      _isPopped = true;
      Get.back(result: true);
    } else if (lowerUrl.contains('fail') || lowerUrl.contains('cancel')) {
      _isPopped = true;
      Get.back(result: false);
    }
  }
}
