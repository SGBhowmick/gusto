import 'dart:async';
import 'package:dusto/common/widgets/custom_pop_widget.dart';
import 'package:dusto/utils/core_export.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BottomNavScreen extends StatefulWidget {
  final AddressModel? previousAddress;
  final bool showServiceNotAvailableDialog;
  final int pageIndex;

  const BottomNavScreen({
    super.key,
    required this.pageIndex,
    this.previousAddress,
    required this.showServiceNotAvailableDialog,
  });

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _pageIndex = 0;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;
    if (_pageIndex == 1) {
      Get.find<BottomNavController>().changePage(
        BnbItem.bookings,
        shouldUpdate: false,
      );
    } else if (_pageIndex == 2) {
      Get.find<BottomNavController>().changePage(
        BnbItem.cart,
        shouldUpdate: false,
      );
    } else if (_pageIndex == 3) {
      Get.find<BottomNavController>().changePage(
        BnbItem.offers,
        shouldUpdate: false,
      );
    } else {
      Get.find<BottomNavController>().changePage(
        BnbItem.homePage,
        shouldUpdate: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isUserLoggedIn = Get.find<AuthController>().isLoggedIn();
    final colorScheme = Theme.of(context).colorScheme;

    return CustomPopWidget(
      isExit: ResponsiveHelper.isWeb(),
      onPopInvoked: () {
        if (Get.find<BottomNavController>().currentPage != BnbItem.homePage) {
          Get.find<BottomNavController>().changePage(BnbItem.homePage);
        } else {
          if (_canExit) {
            if (!GetPlatform.isWeb) {
              SystemNavigator.pop();
            }
          } else {
            customSnackBar(
              'back_press_again_to_exit'.tr,
              type: ToasterMessageType.info,
            );
            _canExit = true;
            Timer(const Duration(seconds: 2), () => _canExit = false);
          }
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,

        // ===== FLOATING ACTION BUTTON WITH CART BADGE =====
        floatingActionButton:
            (ResponsiveHelper.isDesktop(context) ||
                MediaQuery.of(context).viewInsets.bottom != 0)
            ? null
            : Container(
                margin: const EdgeInsets.only(top: 30),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.3),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Get.toNamed(RouteHelper.getCartRoute()),
                    child: Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // Green to Yellow Gradient
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00cf97),
                            Color(0xFF00cf97),
                            Color(0xFF21AC81),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      // CartWidget adds the notification badge count
                      child: Center(
                        child: CartWidget(color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                ),
              ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // ===== BOTTOM NAVIGATION BAR =====
        bottomNavigationBar: ResponsiveHelper.isDesktop(context)
            ? const SizedBox()
            : Container(
                height: 100 + MediaQuery.of(context).padding.bottom,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _genericNavItem(
                        context: context,
                        icon: Images.home,
                        label: "home".tr,
                        item: BnbItem.homePage,
                        onTap: () => Get.find<BottomNavController>().changePage(
                          BnbItem.homePage,
                        ),
                      ),

                      _genericNavItem(
                        context: context,
                        icon: Images.bookings,
                        label: "bookings".tr,
                        item: BnbItem.bookings,
                        onTap: () {
                          if (!isUserLoggedIn &&
                              Get.find<SplashController>()
                                      .configModel
                                      .content
                                      ?.guestCheckout ==
                                  1) {
                            Get.toNamed(RouteHelper.getTrackBookingRoute());
                          } else if (!isUserLoggedIn) {
                            Get.toNamed(
                              RouteHelper.getBookingScreenRoute(true),
                            );
                          } else {
                            Get.find<BottomNavController>().changePage(
                              BnbItem.bookings,
                            );
                          }
                        },
                      ),

                      const SizedBox(width: 70), // Gap for FAB

                      _genericNavItem(
                        context: context,
                        icon: Images.offerMenu,
                        label: "offers".tr,
                        item: BnbItem.offers,
                        onTap: () => Get.find<BottomNavController>().changePage(
                          BnbItem.offers,
                        ),
                      ),

                      _genericNavItem(
                        context: context,
                        icon: Images.menu,
                        label: "more".tr,
                        item: BnbItem.more,
                        onTap: () => Get.bottomSheet(
                          const MenuScreen(),
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

        body: GetBuilder<BottomNavController>(
          builder: (navController) {
            return _bottomNavigationView(
              widget.previousAddress,
              widget.showServiceNotAvailableDialog,
            );
          },
        ),
      ),
    );
  }

  /// ===== GENERIC NAVIGATION ITEM (No Pill) =====
  Widget _genericNavItem({
    required BuildContext context,
    required String icon,
    required String label,
    required BnbItem item,
    required GestureTapCallback onTap,
  }) {
    return GetBuilder<BottomNavController>(
      builder: (controller) {
        final bool selected = controller.currentPage == item;

        // Define colors
        // Active: Green (0xFF009944)
        // Inactive: Grey
        final Color activeColor = const Color(0xFF21AC81);
        final Color inactiveColor = Colors.grey.shade900;

        return Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  icon,
                  width: 24,
                  height: 24,
                  color: selected ? activeColor : inactiveColor,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? activeColor : inactiveColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  dynamic _bottomNavigationView(
    AddressModel? previousAddress,
    bool showServiceNotAvailableDialog,
  ) {
    PriceConverter.getCurrency();
    switch (Get.find<BottomNavController>().currentPage) {
      case BnbItem.homePage:
        return HomeScreen(
          addressModel: previousAddress,
          showServiceNotAvailableDialog: showServiceNotAvailableDialog,
        );
      case BnbItem.bookings:
        if (!Get.find<AuthController>().isLoggedIn()) break;
        return const BookingListScreen();

      case BnbItem.cart:
        if (!Get.find<AuthController>().isLoggedIn()) break;
        return Get.toNamed(RouteHelper.getCartRoute());

      case BnbItem.offers:
        return const OfferScreen();

      case BnbItem.more:
        break;
    }
  }
}
