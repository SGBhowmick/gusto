import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';
import 'package:dusto/common/widgets/custom_expansion_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'subscription_controller.dart';
import 'subscription_plan_model.dart';

class SubscriptionBottomSheet extends StatefulWidget {
  const SubscriptionBottomSheet({super.key});

  @override
  State<SubscriptionBottomSheet> createState() =>
      _SubscriptionBottomSheetState();
}

class _SubscriptionBottomSheetState extends State<SubscriptionBottomSheet> {
  int _selectedCategoryIndex = 0;
  final List<Map<String, dynamic>> _categories = [
    {"name": "Car Wash", "icon": Icons.local_car_wash},
    {"name": "Battery", "icon": Icons.battery_charging_full},
    {"name": "Tyre", "icon": Icons.tire_repair},
    {"name": "Maid Service", "icon": Icons.cleaning_services},
    {"name": "Laundry", "icon": Icons.local_laundry_service},
    {"name": "Shop In", "icon": Icons.storefront},
  ];

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SubscriptionController>()) {
      Get.put(SubscriptionController(apiClient: Get.find()));
    }
    Get.find<SubscriptionController>().getSubscriptionPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.webMaxWidth,
      constraints: BoxConstraints(
        maxHeight:
            Get.height * 0.85, // Expanded height so UI elements are visible
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Header Title
          Text(
            "choose_subscription_plan".tr,
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(
            "unlock_premium_benefits".tr,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).hintColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // Categories Horizontal Tab Bar
          SizedBox(
            height: 85,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedCategoryIndex == index;
                final category = _categories[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 85,
                    margin: const EdgeInsets.only(
                      right: Dimensions.paddingSizeSmall,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusDefault,
                      ),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(
                                context,
                              ).hintColor.withValues(alpha: 0.2),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category["icon"],
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).hintColor,
                          size: 28,
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeExtraSmall,
                        ),
                        Text(
                          category["name"],
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // Content area
          Flexible(
            child: _selectedCategoryIndex == 0
                ? GetBuilder<SubscriptionController>(
                    builder: (subscriptionController) {
                      if (subscriptionController.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (subscriptionController.planList == null ||
                          subscriptionController.planList!.isEmpty) {
                        return Center(
                          child: Text(
                            "no_plans_available".tr,
                            style: robotoMedium.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: subscriptionController.planList!.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: Dimensions.paddingSizeDefault,
                        ),
                        itemBuilder: (context, index) {
                          return _buildPlanCard(
                            subscriptionController.planList![index],
                          );
                        },
                      );
                    },
                  )
                : _buildComingSoon(),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ],
      ),
    );
  }

  Widget _buildComingSoon() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            size: 60,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Text(
            "Coming Soon",
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(
            "We are working hard to bring this service to you.",
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    bool isPremium = plan.tierLabel?.toLowerCase() == 'premium';

    return Container(
      decoration: BoxDecoration(
        color: isPremium
            ? Theme.of(context).primaryColor.withValues(alpha: 0.05)
            : Theme.of(context).cardColor,
        border: Border.all(
          color: isPremium
              ? Theme.of(context).primaryColor
              : Theme.of(context).hintColor.withValues(alpha: 0.2),
          width: isPremium ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      child: CustomExpansionTile(
        tilePadding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    plan.name ?? '',
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                ),
                if (plan.tierLabel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isPremium
                          ? Theme.of(context).primaryColor
                          : Theme.of(
                              context,
                            ).disabledColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      plan.tierLabel!,
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: isPremium
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${plan.price} AED',
                  style: robotoBold.copyWith(
                    fontSize: 28,
                    color: isPremium
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    ' / ${'month'.tr}',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              plan.shortDescription ?? '',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: Dimensions.paddingSizeDefault,
              right: Dimensions.paddingSizeDefault,
              bottom: Dimensions.paddingSizeDefault,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                if (plan.description != null && plan.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeDefault,
                    ),
                    child: Text(
                      plan.description!,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                if (plan.washesPerWeek != null ||
                    plan.exteriorWashesPerMonth != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeDefault,
                    ),
                    child: Wrap(
                      spacing: Dimensions.paddingSizeSmall,
                      runSpacing: Dimensions.paddingSizeSmall,
                      children: [
                        if (plan.washesPerWeek != null)
                          _buildDetailChip(
                            context,
                            Icons.local_car_wash,
                            '${plan.washesPerWeek} Washes/Week',
                          ),
                        if (plan.exteriorWashesPerMonth != null)
                          _buildDetailChip(
                            context,
                            Icons.calendar_month,
                            '${plan.exteriorWashesPerMonth} Washes/Month',
                          ),
                        if (plan.freeVacuumPerWeek != null &&
                            plan.freeVacuumPerWeek! > 0)
                          _buildDetailChip(
                            context,
                            Icons.cleaning_services,
                            '${plan.freeVacuumPerWeek} Vacuum/Week',
                          ),
                        if (plan.tirePolishingIncluded == true)
                          _buildDetailChip(
                            context,
                            Icons.tire_repair,
                            'Tire Polishing',
                          ),
                        if (plan.includesInterior == true)
                          _buildDetailChip(
                            context,
                            Icons.airline_seat_recline_normal,
                            'Interior Included',
                          ),
                      ],
                    ),
                  ),
                Text(
                  "plan_benefits".tr,
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                if (plan.benefits != null)
                  ...plan.benefits!.map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 18,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(
                            child: Text(
                              benefit,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeDefault,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault,
                        ),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Get.back();
                      Get.to(
                        () => PaymentOptionsPage(
                          selectedPlan: plan,
                          onPaymentSuccess: () async {
                            final userController = Get.find<UserController>();
                            final userId =
                                userController.userInfoModel?.id?.toString() ??
                                "guest";
                            final prefs = await SharedPreferences.getInstance();
                            final expiry = DateTime.now().add(
                              const Duration(days: 30),
                            );
                            await prefs.setString(
                              'sub_expiry_$userId',
                              expiry.toIso8601String(),
                            );
                            userController.update();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'subscribe_now'.tr,
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
