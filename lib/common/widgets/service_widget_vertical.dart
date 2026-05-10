import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class ServiceWidgetVertical extends StatelessWidget {
  final Service service;
  final String fromType;
  final String fromPage;
  final ProviderData? providerData;
  final GlobalKey<CustomShakingWidgetState>? signInShakeKey;

  const ServiceWidgetVertical({
    super.key,
    required this.service,
    required this.fromType,
    this.fromPage = "",
    this.providerData,
    this.signInShakeKey,
  });

  @override
  Widget build(BuildContext context) {
    // Logic (Unchanged)
    num lowestPrice = 0.0;
    if (fromType == 'fromCampaign') {
      if ((service.variations?.isNotEmpty ?? false)) {
        lowestPrice = service.variations?[0].price ?? 0;
        for (var i = 0; i < service.variations!.length; i++) {
          if (service.variations![i].price! < lowestPrice) {
            lowestPrice = service.variations![i].price!;
          }
        }
      }
    } else {
      if (service.variationsAppFormat != null) {
        if (service.variationsAppFormat!.zoneWiseVariations != null) {
          lowestPrice =
              service.variationsAppFormat!.zoneWiseVariations![0].price!;
          for (
            var i = 0;
            i < service.variationsAppFormat!.zoneWiseVariations!.length;
            i++
          ) {
            if (service.variationsAppFormat!.zoneWiseVariations![i].price! <
                lowestPrice) {
              lowestPrice =
                  service.variationsAppFormat!.zoneWiseVariations![i].price!;
            }
          }
        }
      }
    }

    Discount discountModel = PriceConverter.discountCalculation(service);
    final theme = Theme.of(context);

    return OnHover(
      isItem: true,
      child: GetBuilder<ServiceController>(
        builder: (serviceController) {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              // ===== 🔵 1. Main Card =====
              Stack(
                children: [
                  Card(
                    color: theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        24,
                      ), // Expressive radius
                    ),
                    elevation: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                          Dimensions.paddingSizeSmall,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image Section
                            Expanded(
                              flex:
                                  ResponsiveHelper.isDesktop(context) &&
                                      !Get.find<LocalizationController>().isLtr
                                  ? 5
                                  : 8,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ), // Inner expressive radius
                                    child: CustomImage(
                                      image: '${service.thumbnailFullPath}',
                                      fit: BoxFit.cover,
                                      width: double.maxFinite,
                                      height: double.infinity,
                                    ),
                                  ),
                                  if (discountModel.discountAmount! > 0)
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DiscountTagWidget(
                                          discountAmount:
                                              discountModel.discountAmount,
                                          discountAmountType:
                                              discountModel.discountAmountType,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Title
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Dimensions.paddingSizeSmall,
                                bottom: 4,
                              ),
                              child: Text(
                                service.name ?? "",
                                style: robotoBold.copyWith(
                                  // Bold for hierarchy
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: theme.textTheme.titleMedium!.color,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                            ),

                            // Price Section
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'starts_from'.tr,
                                    style: robotoRegular.copyWith(
                                      fontSize: 12,
                                      color: theme.hintColor,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (discountModel.discountAmount! > 0)
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            PriceConverter.convertPrice(
                                              lowestPrice.toDouble(),
                                            ),
                                            maxLines: 1,
                                            style: robotoRegular.copyWith(
                                              fontSize: 12,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: theme.colorScheme.error
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                        ),

                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text(
                                          discountModel.discountAmount! > 0
                                              ? PriceConverter.convertPrice(
                                                  lowestPrice.toDouble(),
                                                  discount: discountModel
                                                      .discountAmount!
                                                      .toDouble(),
                                                  discountType: discountModel
                                                      .discountAmountType,
                                                )
                                              : PriceConverter.convertPrice(
                                                  lowestPrice.toDouble(),
                                                ),
                                          style: robotoBold.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Ripple Effect
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (fromPage == "search_page") {
                              Get.toNamed(
                                RouteHelper.getServiceRoute(
                                  service.id!,
                                  fromPage: "search_page",
                                ),
                              );
                            } else {
                              Get.toNamed(
                                RouteHelper.getServiceRoute(service.id!),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ===== 🔵 2. Add Button (Styled) =====
              if (fromType != 'fromCampaign')
                Align(
                  alignment: Get.find<LocalizationController>().isLtr
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      8.0,
                    ), // Floating slightly inside
                    child: Material(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16), // Rounded square
                      elevation: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          showModalBottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => ServiceCenterDialog(
                              service: service,
                              providerData: providerData,
                            ),
                          );
                        },
                        child: Container(
                          height: 36,
                          width: 36,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // ===== 🔵 3. Favorite Button =====
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: FavoriteIconWidget(
                      value: service.isFavorite,
                      serviceId: service.id!,
                      signInShakeKey: signInShakeKey,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
