import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class ServiceWidgetHorizontal extends StatelessWidget {
  final List<Service> serviceList;
  final int index;
  final num? discountAmount;
  final String? discountAmountType;
  final bool showIsFavoriteButton;
  final GlobalKey<CustomShakingWidgetState>? signInShakeKey;

  const ServiceWidgetHorizontal({
    super.key,
    required this.serviceList,
    required this.index,
    required this.discountAmount,
    required this.discountAmountType,
    this.showIsFavoriteButton = true,
    this.signInShakeKey,
  });

  @override
  Widget build(BuildContext context) {
    // Logic (Unchanged)
    double lowestPrice = 0.0;
    if (serviceList[index].variationsAppFormat!.zoneWiseVariations != null) {
      lowestPrice = serviceList[index]
          .variationsAppFormat!
          .zoneWiseVariations![0]
          .price!
          .toDouble();
      for (
        var i = 0;
        i < serviceList[index].variationsAppFormat!.zoneWiseVariations!.length;
        i++
      ) {
        if (serviceList[index]
                .variationsAppFormat!
                .zoneWiseVariations![i]
                .price! <
            lowestPrice) {
          lowestPrice = serviceList[index]
              .variationsAppFormat!
              .zoneWiseVariations![i]
              .price!
              .toDouble();
        }
      }
    }
    Discount discountModel = PriceConverter.discountCalculation(
      serviceList[index],
    );

    // Theme Access
    final theme = Theme.of(context);
    final isLtr = Get.find<LocalizationController>().isLtr;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeEight,
        vertical: Dimensions.paddingSizeExtraSmall,
      ),
      child: GetBuilder<ServiceController>(
        builder: (serviceController) {
          return OnHover(
            isItem: true,
            child: Stack(
              children: [
                Card(
                  color: theme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20,
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
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== 1. Image Section =====
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CustomImage(
                                image:
                                    '${serviceList[index].thumbnailFullPath}',
                                height: 105,
                                width: 105,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (discountModel.discountAmount! > 0)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: DiscountTagWidget(
                                  discountAmount: discountModel.discountAmount,
                                  discountAmountType:
                                      discountModel.discountAmountType,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        // ===== 2. Content Section =====
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                height: 4,
                              ), // Top alignment correction
                              // Title
                              Text(
                                serviceList[index].name ?? "",
                                style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: theme.textTheme.titleLarge!.color,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                              ),

                              const SizedBox(height: 6),

                              // Rating
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: const Color(0xFFFFB800),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    serviceList[index].avgRating.toString(),
                                    style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: theme.textTheme.bodyMedium!.color,
                                    ),
                                  ),
                                  Text(
                                    " (${serviceList[index].ratingCount})",
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: theme.textTheme.bodySmall!.color,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // Description
                              Text(
                                serviceList[index].shortDescription ?? "",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: theme.textTheme.bodySmall!.color,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 12),

                              // Price Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "starts_from".tr,
                                    style: robotoRegular.copyWith(
                                      fontSize: 12,
                                      color: theme.hintColor,
                                    ),
                                  ),
                                  const Spacer(),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (discountAmount! > 0)
                                        Text(
                                          PriceConverter.convertPrice(
                                            lowestPrice,
                                          ),
                                          style: robotoRegular.copyWith(
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: theme.colorScheme.error
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      Text(
                                        PriceConverter.convertPrice(
                                          lowestPrice,
                                          discount: discountAmount!.toDouble(),
                                          discountType: discountAmountType,
                                        ),
                                        style: robotoBold.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
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

                // Ripple Effect
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Original Logic
                          Get.toNamed(
                            RouteHelper.getServiceRoute(
                              serviceController
                                  .recommendedServiceList![index]
                                  .id!,
                            ),
                            arguments: ServiceDetailsScreen(
                              serviceID: serviceController
                                  .recommendedServiceList![index]
                                  .id!,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Favorite Button
                if (showIsFavoriteButton)
                  Positioned(
                    top: 10,
                    right: isLtr ? 10 : null,
                    left: isLtr ? null : 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: FavoriteIconWidget(
                        value: serviceList[index].isFavorite,
                        serviceId: serviceList[index].id!,
                        signInShakeKey: signInShakeKey,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
