import 'package:dusto/common/widgets/custom_pop_widget.dart';
import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String? serviceID;
  final String? fromPage;
  const ServiceDetailsScreen({
    super.key,
    this.serviceID,
    this.fromPage = "others",
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.serviceID != null) {
      Get.find<ServiceDetailsController>().getServiceDetails(
        widget.serviceID!,
        fromPage: widget.fromPage == "search_page" ? "search_page" : "",
      );
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<ServiceController>().getRecentlyViewedServiceList(1, true);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Material 3 Theme Access
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomPopWidget(
      child: Scaffold(
        key: scaffoldState,
        backgroundColor: colorScheme.surface, // M3 Surface
        endDrawer: ResponsiveHelper.isDesktop(context)
            ? const MenuDrawer()
            : null,
        appBar: CustomAppBar(
          centerTitle: false,
          title: 'service_details'.tr,
          showCart: true,
        ),
        body: GetBuilder<ServiceDetailsController>(
          builder: (serviceController) {
            if (serviceController.service != null || widget.serviceID == null) {
              if (serviceController.service != null &&
                  serviceController.service!.id != null &&
                  widget.serviceID != null) {
                Service? service = serviceController.service;
                Discount discount = PriceConverter.discountCalculation(
                  service!,
                );
                double lowestPrice = 0.0;
                if (service.variationsAppFormat!.zoneWiseVariations != null) {
                  lowestPrice = service
                      .variationsAppFormat!
                      .zoneWiseVariations![0]
                      .price!
                      .toDouble();
                  for (
                    var i = 0;
                    i < service.variationsAppFormat!.zoneWiseVariations!.length;
                    i++
                  ) {
                    if (service
                            .variationsAppFormat!
                            .zoneWiseVariations![i]
                            .price! <
                        lowestPrice) {
                      lowestPrice = service
                          .variationsAppFormat!
                          .zoneWiseVariations![i]
                          .price!
                          .toDouble();
                    }
                  }
                }
                return FooterBaseView(
                  isScrollView: ResponsiveHelper.isMobile(context)
                      ? false
                      : true,
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: DefaultTabController(
                      length:
                          Get.find<ServiceDetailsController>()
                              .service!
                              .faqs!
                              .isNotEmpty
                          ? 3
                          : 2,
                      child: Column(
                        children: [
                          if (!ResponsiveHelper.isMobile(context) &&
                              !ResponsiveHelper.isTab(context))
                            const SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),

                          Stack(
                            children: [
                              Column(
                                children: [
                                  // ===== 1. M3 Header Image Styling =====
                                  Container(
                                    margin:
                                        (!ResponsiveHelper.isMobile(context) &&
                                            !ResponsiveHelper.isTab(context))
                                        ? const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeDefault,
                                          )
                                        : EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        (!ResponsiveHelper.isMobile(context) &&
                                                !ResponsiveHelper.isTab(
                                                  context,
                                                ))
                                            ? const Radius.circular(32)
                                            : const Radius.elliptical(0, 32),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        (!ResponsiveHelper.isMobile(context) &&
                                                !ResponsiveHelper.isTab(
                                                  context,
                                                ))
                                            ? const Radius.circular(32)
                                            : const Radius.elliptical(0, 32),
                                      ),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              width: Dimensions.webMaxWidth,
                                              height:
                                                  ResponsiveHelper.isDesktop(
                                                    context,
                                                  )
                                                  ? 280
                                                  : 200,
                                              child: CustomImage(
                                                image:
                                                    service
                                                        .coverImageFullPath ??
                                                    "",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          // Gradient Overlay
                                          Center(
                                            child: Container(
                                              width: Dimensions.webMaxWidth,
                                              height:
                                                  ResponsiveHelper.isDesktop(
                                                    context,
                                                  )
                                                  ? 280
                                                  : 200,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.black.withOpacity(
                                                      0.1,
                                                    ), // Lighter top
                                                    Colors.black.withOpacity(
                                                      0.6,
                                                    ), // Darker bottom
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // FIXED: Centered Service Name
                                          Container(
                                            width: Dimensions.webMaxWidth,
                                            height:
                                                ResponsiveHelper.isDesktop(
                                                  context,
                                                )
                                                ? 280
                                                : 200,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeLarge,
                                            ),
                                            alignment: Alignment
                                                .center, // Changed to Center
                                            child: Text(
                                              service.name ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign
                                                  .center, // Centered Text
                                              style: robotoBold.copyWith(
                                                fontSize:
                                                    24, // Expressive Headline Size
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 120),
                                ],
                              ),

                              // ===== 2. Floating Service Info Card =====
                              Positioned(
                                bottom: -2,
                                left: Dimensions.paddingSizeDefault,
                                right: Dimensions.paddingSizeDefault,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.shadowColor.withOpacity(
                                          0.1,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ServiceInformationCard(
                                    discount: discount,
                                    service: service,
                                    lowestPrice: lowestPrice,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          // ===== 3. M3 Pill-Shaped Tab Bar =====
                          GetBuilder<ServiceTabController>(
                            init: Get.find<ServiceTabController>(),
                            builder: (serviceTabController) {
                              return Center(
                                child: Container(
                                  width: ResponsiveHelper.isMobile(context)
                                      ? null
                                      : Get.width / 3,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: TabBar(
                                    padding: EdgeInsets.zero,
                                    controller: serviceTabController.controller,
                                    dividerColor: Colors.transparent,
                                    indicator: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.primary
                                              .withOpacity(0.3),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    labelColor: Colors.black,
                                    unselectedLabelColor:
                                        theme.textTheme.bodyMedium?.color,
                                    labelStyle: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                    ),

                                    indicatorSize: TabBarIndicatorSize.tab,
                                    onTap: (int? index) {
                                      switch (index) {
                                        case 0:
                                          serviceTabController
                                              .updateServicePageCurrentState(
                                                ServiceTabControllerState
                                                    .serviceOverview,
                                              );
                                          break;
                                        case 1:
                                          serviceTabController
                                                      .serviceDetailsTabs(
                                                        serviceController
                                                            .service,
                                                      )
                                                      .length >
                                                  2
                                              ? serviceTabController
                                                    .updateServicePageCurrentState(
                                                      ServiceTabControllerState
                                                          .faq,
                                                    )
                                              : serviceTabController
                                                    .updateServicePageCurrentState(
                                                      ServiceTabControllerState
                                                          .review,
                                                    );
                                          break;
                                        case 2:
                                          serviceTabController
                                              .updateServicePageCurrentState(
                                                ServiceTabControllerState
                                                    .review,
                                              );
                                          break;
                                      }
                                    },
                                    tabs: serviceTabController
                                        .serviceDetailsTabs(
                                          serviceController.service,
                                        ),
                                  ),
                                ),
                              );
                            },
                          ),

                          //Tab Bar View (Logic Unchanged)
                          GetBuilder<ServiceTabController>(
                            initState: (state) {
                              Get.find<ServiceTabController>().getServiceReview(
                                serviceController.service!.id!,
                                1,
                              );
                            },
                            builder: (controller) {
                              Widget tabBarView = TabBarView(
                                controller: controller.controller,
                                children: [
                                  SingleChildScrollView(
                                    padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeDefault,
                                    ),
                                    child: ServiceOverview(
                                      description: service.description!,
                                    ),
                                  ),
                                  if (Get.find<ServiceDetailsController>()
                                      .service!
                                      .faqs!
                                      .isNotEmpty)
                                    const SingleChildScrollView(
                                      child: ServiceDetailsFaqSection(),
                                    ),
                                  if (controller.reviewList != null)
                                    SingleChildScrollView(
                                      child: ServiceDetailsReview(
                                        serviceID:
                                            serviceController.service!.id!,
                                      ),
                                    )
                                  else
                                    const EmptyReviewWidget(),
                                ],
                              );

                              if (ResponsiveHelper.isMobile(context)) {
                                return Expanded(child: tabBarView);
                              } else {
                                return SizedBox(height: 500, child: tabBarView);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return NoDataScreen(
                  text: 'no_service_available'.tr,
                  type: NoDataType.service,
                );
              }
            } else {
              return const ServiceDetailsShimmerWidget();
            }
          },
        ),
      ),
    );
  }
}
