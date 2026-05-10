import 'dart:convert';
import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

import 'subscription_plan_model.dart';

class SubscriptionController extends GetxController implements GetxService {
  final ApiClient apiClient;

  SubscriptionController({required this.apiClient});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCurrentSubLoading = false;
  bool get isCurrentSubLoading => _isCurrentSubLoading;

  List<SubscriptionPlan>? _planList;
  List<SubscriptionPlan>? get planList => _planList;

  Map<String, dynamic>? _currentSubscription;
  Map<String, dynamic>? get currentSubscription => _currentSubscription;

  Future<void> getSubscriptionPlans() async {
    _isLoading = true;
    update();

    try {
      Response response = await apiClient.getData(
        AppConstants.subscriptionPlansUri,
      );
      if (response.statusCode == 200 && response.body != null) {
        dynamic body = response.body;
        if (body is String) {
          body = jsonDecode(body);
        }
        SubscriptionPlanResponse subResponse =
            SubscriptionPlanResponse.fromJson(body);
        _planList = subResponse.content?.plans ?? [];
        _planList!.sort(
          (a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0),
        );
      } else {
        _planList = [];
      }
    } catch (e) {
      _planList = [];
      debugPrint('Error fetching plans: $e');
    }

    _isLoading = false;
    update();
  }

  Future<void> getCurrentSubscription() async {
    _isCurrentSubLoading = true;
    update();

    Response response = await apiClient.getData(
      AppConstants.currentSubscriptionUri,
    );
    if (response.statusCode == 200 && response.body != null) {
      CurrentSubscriptionResponse subResponse =
          CurrentSubscriptionResponse.fromJson(response.body);
      _currentSubscription = subResponse.content;
    } else {
      _currentSubscription = null;
    }

    _isCurrentSubLoading = false;
    update();
  }

  Future<String?> checkoutSubscription(String planId) async {
    _isLoading = true;
    update();

    String? paymentUrl;
    try {
      Response response = await apiClient
          .postData(AppConstants.subscriptionCheckoutUri, {
            "wash_subscription_plan_id": planId,
            "payment_method": "nomad",
            "payment_platform": "app",
          });

      if (response.statusCode == 200 && response.body != null) {
        dynamic body = response.body;
        if (body is String) body = jsonDecode(body);

        if (body['content'] != null) {
          if (body['content'] is String) {
            paymentUrl = body['content'];
          } else {
            paymentUrl =
                body['content']['payment_url'] ??
                body['content']['redirect_url'] ??
                body['content']['url'];
          }
        }
      }
    } catch (e) {
      debugPrint('Error during checkout: $e');
    }

    _isLoading = false;
    update();
    return paymentUrl;
  }
}
