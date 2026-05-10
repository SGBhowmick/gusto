import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<BottomNavController>().updateMenuPageIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    ConfigModel configModel = Get.find<SplashController>().configModel;
    // Keeping your exact ratio logic
    double ratio = ResponsiveHelper.isTab(context) ? 1.1 : 1.2;

    // --- LOGIC SECTION (UNTOUCHED) ---
    final List<MenuModel> menuList = [
      MenuModel(
        icon: Images.profileIcon,
        title: 'profile'.tr,
        route: RouteHelper.getProfileRoute(),
      ),
      MenuModel(
        icon: Images.chatImage,
        title: 'inbox'.tr,
        route: RouteHelper.getInboxScreenRoute(),
      ),
      MenuModel(
        icon: Images.translate,
        title: 'language'.tr,
        route: RouteHelper.getLanguageScreen('fromSettingsPage'),
      ),
      MenuModel(
        icon: Images.settings,
        title: 'settings'.tr,
        route: RouteHelper.getSettingRoute(),
      ),
      MenuModel(
        icon: Images.bookingsIcon,
        title: configModel.content?.guestCheckout == 0 || isLoggedIn
            ? 'bookings'.tr
            : "track_booking".tr,
        route: !isLoggedIn && configModel.content?.guestCheckout == 1
            ? RouteHelper.getTrackBookingRoute()
            : RouteHelper.getBookingScreenRoute(true),
      ),
      MenuModel(
        icon: Images.voucherIcon,
        title: 'vouchers'.tr,
        route: RouteHelper.getVoucherRoute(fromPage: 'menu'),
      ),
      MenuModel(
        icon: Images.myFavorite,
        title: 'my_favorite'.tr,
        route: RouteHelper.getMyFavoriteScreen(),
      ),
      if (configModel.content?.biddingStatus == 1)
        MenuModel(
          icon: Images.customPostIcon,
          title: 'my_posts'.tr,
          route: RouteHelper.getMyPostScreen(),
        ),
      if (configModel.content!.walletStatus != 0 && isLoggedIn)
        MenuModel(
          icon: Images.walletMenu,
          title: 'my_wallet'.tr,
          route: RouteHelper.getMyWalletScreen(),
        ),
      if (configModel.content!.loyaltyPointStatus != 0 && isLoggedIn)
        MenuModel(
          icon: Images.myPoint,
          title: 'loyalty_point'.tr,
          route: RouteHelper.getLoyaltyPointScreen(),
        ),
      if (Get.find<SplashController>().configModel.content?.referEarnStatus ==
          1)
        MenuModel(
          title: 'refer_and_earn'.tr,
          icon: Images.shareIcon,
          route: RouteHelper.getReferAndEarnScreen(),
        ),
      MenuModel(
        icon: Images.areaMenuIcon,
        title: 'service_area'.tr,
        route: RouteHelper.getServiceArea(),
      ),
      MenuModel(
        icon: Images.helpIcon,
        title: 'help_&_support'.tr,
        route: RouteHelper.getSupportRoute(),
      ),
      if (configModel.content?.providerSelfRegistration == 1)
        MenuModel(
          icon: Images.providerImage,
          title: 'become_a_provider'.tr,
          route: GetPlatform.isWeb
              ? '${AppConstants.baseUrl}/provider/auth/sign-up'
              : RouteHelper.getProviderWebView(),
        ),
      ...(configModel.content!.businessPages ?? []).map(
        (page) => MenuModel(
          icon: page.pageKey == HtmlType.aboutUs.value
              ? Images.aboutUs
              : page.pageKey == HtmlType.termsAndCondition.value
              ? Images.termsIcon
              : page.pageKey == HtmlType.privacyPolicy.value
              ? Images.privacyPolicyIcon
              : page.pageKey == HtmlType.cancellationPolicy.value
              ? Images.cancellationPolicy
              : page.pageKey == HtmlType.refundPolicy.value
              ? Images.refundPolicy
              : Images.othersPageIcon,
          title: _getPageTitle(page),
          route: RouteHelper.getHtmlRoute(
            page.pageKey!,
            title: _getPageTitle(page),
          ),
        ),
      ),
    ];
    menuList.add(
      MenuModel(
        icon: Images.logout,
        title: isLoggedIn ? 'logout'.tr : 'sign_in'.tr,
        route: '',
        isLogout: true,
      ),
    );

    int menuCountInSinglePage =
        ResponsiveHelper.isTab(context) && menuList.length > 17
        ? 18
        : ResponsiveHelper.isTab(context) && menuList.length < 18
        ? menuList.length
        : ResponsiveHelper.isMobile(context) && menuList.length > 11
        ? 12
        : menuList.length;

    int totalPageSize = (menuList.length / menuCountInSinglePage).ceil();
    // --- END LOGIC SECTION ---

    return PointerInterceptor(
      child: GetBuilder<BottomNavController>(
        builder: (bottomNavController) {
          return Container(
            width: Dimensions.webMaxWidth,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
            ), // Increased padding slightly
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ), // More rounded corners
              color: Get.isDarkMode
                  ? Colors.black87
                  : Colors.white, // Changed to pure white for better contrast
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // DESIGN CHANGE: Replaced Arrow Icon with a Modern Drag Handle
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  // DESIGN CHANGE: Added a Header Title for better UI context
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "menu".tr,
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      ),
                      // Optional: Close button on the right if you want, otherwise leave empty
                      const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: Get.height * 0.15,
                      maxHeight: Get.height * 0.4,
                    ),
                    child: PageView.builder(
                      onPageChanged: (value) {
                        bottomNavController.updateMenuPageIndex(
                          value,
                          shouldUpdate: true,
                        );
                      },
                      itemCount: totalPageSize,
                      itemBuilder: (context, index) => GridView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isMobile(context)
                              ? 4
                              : 6,
                          childAspectRatio: (1 / ratio),
                          crossAxisSpacing: Dimensions
                              .paddingSizeSmall, // Increased spacing slightly
                          mainAxisSpacing: Dimensions.paddingSizeSmall,
                        ),
                        itemCount:
                            totalPageSize == 1 ||
                                (bottomNavController.currentMenuPageIndex + 1 <
                                    totalPageSize)
                            ? menuCountInSinglePage
                            : (menuList.length -
                                  (menuCountInSinglePage *
                                      (totalPageSize - 1))),
                        itemBuilder: (context, index) {
                          return MenuButton(
                            menu:
                                menuList[(menuCountInSinglePage *
                                        bottomNavController
                                            .currentMenuPageIndex) +
                                    index],
                          );
                        },
                      ),
                    ),
                  ),

                  if (totalPageSize > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall,
                      ),
                      child: SizedBox(
                        height: 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            totalPageSize,
                            (index) => PagerDot(
                              index: index,
                              currentIndex:
                                  bottomNavController.currentMenuPageIndex,
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // DESIGN CHANGE: Made version text more subtle
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "${'app_version'.tr} ${AppConstants.appVersion}",
                      style: robotoMedium.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.isMobile(context)
                        ? Dimensions.paddingSizeDefault
                        : 0,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // LOGIC UNTOUCHED
  String _getPageTitle(BusinessPage page) {
    return page.pageKey == HtmlType.aboutUs.value
        ? 'about_us'.tr
        : page.pageKey == HtmlType.termsAndCondition.value
        ? 'terms_and_conditions'.tr
        : page.pageKey == HtmlType.privacyPolicy.value
        ? 'privacy_policy'.tr
        : page.pageKey == HtmlType.cancellationPolicy.value
        ? 'cancellation_policy'.tr
        : page.pageKey == HtmlType.refundPolicy.value
        ? 'refund_policy'.tr
        : page.title ?? '';
  }
}
