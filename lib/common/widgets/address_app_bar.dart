import 'dart:ui'; // Required for ImageFilter
import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class AddressAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? backButton;
  const AddressAppBar({super.key, this.backButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      // ===== 🟡 Dusto Car Wash Theme Background =====
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 240, 152), // Dusto Bright Yellow
            Color.fromARGB(255, 247, 227, 2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Row(
            children: [
              // ===== ⚫ Back Button =====
              if (backButton!)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.black, // Changed to Black
                    tooltip: 'Back',
                    style: IconButton.styleFrom(
                      // Dark transparent background
                      backgroundColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                )
              else
                const SizedBox(width: 0),

              // ===== ⚫ Address Selector (Glass Pill - Dark Mode Style) =====
              Expanded(
                child: InkWell(
                  onTap: () => Get.toNamed(
                    RouteHelper.getAccessLocationRoute('address'),
                  ),
                  borderRadius: BorderRadius.circular(50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          // Darker tint for glass effect on yellow
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // "Services in" Label
                            Row(
                              children: [
                                Text(
                                  'services_in'.tr.toUpperCase(),
                                  style: robotoMedium.copyWith(
                                    // Dark text with opacity
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),

                            // Address Row
                            GetBuilder<LocationController>(
                              builder: (locationController) {
                                return Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.black, // Changed to Black
                                      size: 14,
                                    ),
                                    const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall,
                                    ),
                                    if (locationController.getUserAddress() !=
                                        null)
                                      Flexible(
                                        child: Text(
                                          locationController
                                                  .getUserAddress()
                                                  ?.address ??
                                              '',
                                          style: robotoBold.copyWith(
                                            color: Colors
                                                .black, // Changed to Black
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    const SizedBox(
                                      width: Dimensions.paddingSizeSmall,
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      // Changed to Black opacity
                                      color: Colors.black.withOpacity(0.6),
                                      size: 16,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              InkWell(
                onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
                borderRadius: BorderRadius.circular(30),
                child: const Icon(
                  Icons.notifications_rounded,
                  size: 24,
                  color: Colors.black, // Changed to Black
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 120 : 110);
}
