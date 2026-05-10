import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class ServiceCenterDialog extends StatefulWidget {
  final Service? service;
  final CartModel? cart;
  final int? cartIndex;
  final bool? isFromDetails;
  final ProviderData? providerData;

  const ServiceCenterDialog({
    super.key,
    required this.service,
    this.cart,
    this.cartIndex,
    this.isFromDetails = false,
    this.providerData,
  });

  @override
  State<ServiceCenterDialog> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ServiceCenterDialog> {
  @override
  void initState() {
    Get.find<CartController>().setInitialCartList(widget.service!);
    Get.find<CartController>().updatePreselectedProvider(
      null,
      shouldUpdate: false,
    );
    Get.find<AllSearchController>().searchFocus.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return Dialog(
        // ===== 🔵 M3: Large Radius for Dialogs =====
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }

  Padding pointerInterceptor() {
    return Padding(
      padding: EdgeInsets.only(
        top: ResponsiveHelper.isWeb() ? 0 : Dimensions.cartDialogPadding,
      ),
      child: PointerInterceptor(
        child: Container(
          width: ResponsiveHelper.isDesktop(context)
              ? Dimensions.webMaxWidth / 2
              : Dimensions.webMaxWidth,
          padding: const EdgeInsets.all(
            24,
          ), // ===== 🔵 M3: Increased Padding =====
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(
                28,
              ), // ===== 🔵 M3: Extra Large Top Radius =====
            ),
          ),
          child: GetBuilder<CartController>(
            builder: (cartControllerInit) {
              return GetBuilder<ServiceController>(
                builder: (serviceController) {
                  if (widget.service!.variationsAppFormat!.zoneWiseVariations !=
                      null) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ===== 🔵 M3: Handle for Mobile Sheets (Visual Only) =====
                        if (!ResponsiveHelper.isDesktop(context))
                          Container(
                            height: 4,
                            width: 32,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).disabledColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                        // ===== 🔵 M3: Header Layout (Row instead of Column) =====
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // Squircle
                              child: CustomImage(
                                image: '${widget.service!.thumbnailFullPath}',
                                height: 60,
                                width: 60,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.service!.name!,
                                    style: robotoMedium.copyWith(
                                      fontSize: 18, // Title Medium
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).hoverColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      widget
                                                  .service!
                                                  .variationsAppFormat!
                                                  .zoneWiseVariations!
                                                  .length >
                                              1
                                          ? "${widget.service!.variationsAppFormat!.zoneWiseVariations!.length} ${'variations_available'.tr}"
                                          : "${widget.service!.variationsAppFormat!.zoneWiseVariations!.length} ${'variation_available'.tr}",
                                      style: robotoRegular.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withOpacity(.6),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Close Button
                            InkWell(
                              onTap: () => Get.back(),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 36,
                                width: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).disabledColor.withOpacity(0.1),
                                  ),
                                ),
                                child: const Icon(Icons.close, size: 20),
                              ),
                            ),
                          ],
                        ),

                        // ===== 🔵 M3: Variation List =====
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: Get.height * 0.1,
                                maxHeight: Get.height * 0.4,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    cartControllerInit.initialCartList.length,
                                itemBuilder: (context, index) {
                                  // variation item
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        // Subtle fill instead of hover color
                                        color: Theme.of(context).cardColor,
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).disabledColor.withOpacity(0.1),
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: GetBuilder<CartController>(
                                        builder: (cartController) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      cartControllerInit
                                                          .initialCartList[index]
                                                          .variantKey
                                                          .replaceAll('-', ' '),
                                                      style: robotoMedium
                                                          .copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeDefault,
                                                          ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      child: Text(
                                                        PriceConverter.convertPrice(
                                                          double.parse(
                                                            cartControllerInit
                                                                .initialCartList[index]
                                                                .price
                                                                .toString(),
                                                          ),
                                                          isShowLongPrice: true,
                                                        ),
                                                        style: robotoBold
                                                            .copyWith(
                                                              color: Theme.of(
                                                                context,
                                                              ).primaryColor,
                                                              fontSize: 16,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // ===== 🔵 M3: Quantity Controls =====
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  if (cartControllerInit
                                                          .initialCartList[index]
                                                          .quantity >
                                                      0)
                                                    InkWell(
                                                      onTap: () {
                                                        cartController
                                                            .updateQuantity(
                                                              index,
                                                              false,
                                                            );
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      child: Container(
                                                        height: 32,
                                                        width: 32,
                                                        decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Theme.of(context)
                                                                  .disabledColor
                                                                  .withOpacity(
                                                                    0.1,
                                                                  ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 18,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    const SizedBox(),

                                                  if (cartControllerInit
                                                          .initialCartList[index]
                                                          .quantity >
                                                      0)
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                            minWidth: 30,
                                                          ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        cartControllerInit
                                                            .initialCartList[index]
                                                            .quantity
                                                            .toString(),
                                                        style: robotoBold
                                                            .copyWith(
                                                              fontSize: 16,
                                                            ),
                                                      ),
                                                    )
                                                  else
                                                    const SizedBox(),

                                                  GestureDetector(
                                                    onTap: () {
                                                      cartController
                                                          .updateQuantity(
                                                            index,
                                                            true,
                                                          );
                                                    },
                                                    child: Container(
                                                      height: 32,
                                                      width: 32,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Theme.of(
                                                          context,
                                                        ).primaryColor, // Dusto Yellow
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Icon(
                                                        Icons.add,
                                                        size: 18,
                                                        color: Colors
                                                            .black, // Black icon on Yellow
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),

                        // ===== 🔵 Bottom Buttons Section =====
                        GetBuilder<CartController>(
                          builder: (cartController) {
                            bool addToCart = true;
                            return cartController.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Row(
                                    children: [
                                      if (Get.find<SplashController>()
                                                  .configModel
                                                  .content
                                                  ?.directProviderBooking ==
                                              1 &&
                                          (widget.providerData != null ||
                                              cartController.selectedProvider !=
                                                  null))
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              // Existing empty onTap logic preserved
                                            },
                                            child: SelectedProductWidget(
                                              providerData:
                                                  widget.providerData ??
                                                  cartController
                                                      .selectedProvider,
                                            ),
                                          ),
                                        ),

                                      if (Get.find<SplashController>()
                                              .configModel
                                              .content
                                              ?.biddingStatus ==
                                          1)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                context: Get.context!,
                                                builder: (BuildContext context) {
                                                  return const BottomCreatePostDialog();
                                                },
                                              );
                                              if (widget.service != null) {
                                                Get.find<CreatePostController>()
                                                    .resetCreatePostValue(
                                                      removeService: false,
                                                    );
                                                Get.find<CreatePostController>()
                                                    .updateSelectedService(
                                                      widget.service!,
                                                    );
                                              }
                                            },
                                            child: Container(
                                              height:
                                                  ResponsiveHelper.isDesktop(
                                                    context,
                                                  )
                                                  ? 55
                                                  : 50, // Match button height
                                              width:
                                                  ResponsiveHelper.isDesktop(
                                                    context,
                                                  )
                                                  ? 55
                                                  : 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.5),
                                                  width: 1,
                                                ),
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor.withOpacity(0.1),
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: Center(
                                                child: Hero(
                                                  tag: 'provide_image',
                                                  child: Image.asset(
                                                    Images.customPostIcon,
                                                    color: Theme.of(
                                                      context,
                                                    ).primaryColorDark,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      Expanded(
                                        child: CustomButton(
                                          height:
                                              ResponsiveHelper.isDesktop(
                                                context,
                                              )
                                              ? 55
                                              : 50,
                                          radius: 12,
                                          onPressed: cartControllerInit.isButton
                                              ? () async {
                                                  if (addToCart) {
                                                    addToCart = false;
                                                    await cartController
                                                        .addMultipleCartToServer(
                                                          providerId:
                                                              cartController
                                                                  .selectedProvider
                                                                  ?.id ??
                                                              widget
                                                                  .providerData
                                                                  ?.id ??
                                                              "",
                                                        );
                                                    await cartController
                                                        .getCartListFromServer(
                                                          shouldUpdate: true,
                                                        );
                                                  }
                                                }
                                              : null,
                                          buttonText:
                                              (cartController
                                                      .cartList
                                                      .isNotEmpty &&
                                                  cartController.cartList
                                                          .elementAt(0)
                                                          .serviceId ==
                                                      widget.service!.id)
                                              ? 'update_cart'.tr
                                              : 'add_to_cart'.tr,
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ],
                    );
                  }

                  // ===== 🔵 Empty State (Preserved) =====
                  return Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0, // Adjusted padding
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.close),
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 7,
                        child: Center(
                          child: Text(
                            'no_variation_is_available'.tr,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
