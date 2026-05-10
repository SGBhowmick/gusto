import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subTitle;
  final bool? isBackButtonExist;
  final Function()? onBackPressed;
  final bool? showCart;
  final bool? centerTitle;
  final Color? bgColor;
  final Widget? actionWidget;
  final GlobalKey<CustomShakingWidgetState>? shakeKey;
  final bool isBackgroundTransparent;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isBackButtonExist = true,
    this.onBackPressed,
    this.showCart = false,
    this.centerTitle = true,
    this.bgColor,
    this.actionWidget,
    this.subTitle,
    this.shakeKey,
    this.isBackgroundTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? WebMenuBar(searchbarShakeKey: shakeKey)
        : Container(
            // ===== 🟡 Dusto Car Wash Theme =====
            decoration: isBackgroundTransparent
                ? null
                : const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(
                          255,
                          255,
                          225,
                          54,
                        ), // Dusto Bright Yellow
                        Color.fromARGB(
                          255,
                          255,
                          234,
                          0,
                        ), // Dusto Darker Yellow/Amber
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ===== 🔵 2. Back Button (Leading) =====
                    if (isBackButtonExist!)
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          // Changed White to Black for Yellow background
                          color: isBackgroundTransparent
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                        tooltip: 'Back',
                        style: IconButton.styleFrom(
                          // Changed White opacity to Black opacity
                          backgroundColor: isBackgroundTransparent
                              ? Theme.of(context).cardColor
                              : Colors.black.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(40, 40),
                        ),
                        onPressed: () => onBackPressed != null
                            ? onBackPressed!()
                            : Navigator.of(context).canPop()
                            ? Navigator.pop(context)
                            : Get.offAllNamed(RouteHelper.getInitialRoute()),
                      )
                    else
                      const SizedBox(width: 40),

                    // ===== 🔵 3. Title & Subtitle (Expanded Middle) =====
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: centerTitle!
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title!,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                // Changed White to Black
                                color: isBackgroundTransparent
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: centerTitle!
                                  ? TextAlign.center
                                  : TextAlign.start,
                            ),
                            if (subTitle != null)
                              Text(
                                subTitle!,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  // Changed White to Black (slight opacity)
                                  color: isBackgroundTransparent
                                      ? Theme.of(context).primaryColor
                                      : Colors.black.withOpacity(0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: centerTitle!
                                    ? TextAlign.center
                                    : TextAlign.start,
                              ),
                          ],
                        ),
                      ),
                    ),

                    // ===== 🔵 4. Actions / Cart (Right Side) =====
                    if (showCart!)
                      InkWell(
                        onTap: () => Get.toNamed(RouteHelper.getCartRoute()),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // Changed White opacity to Black opacity
                            color: isBackgroundTransparent
                                ? Theme.of(context).cardColor.withOpacity(0.5)
                                : Colors.black.withOpacity(0.1),
                            border: Border.all(
                              // Changed White opacity to Black opacity
                              color: isBackgroundTransparent
                                  ? Theme.of(context).primaryColor
                                  : Colors.black.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: CartWidget(
                              // Changed White to Black
                              color: isBackgroundTransparent
                                  ? Theme.of(context).primaryColor
                                  : Colors.black,
                              size: Dimensions.cartWidgetSize,
                            ),
                          ),
                        ),
                      )
                    else if (actionWidget != null)
                      actionWidget!
                    else
                      SizedBox(width: isBackButtonExist! ? 40 : 0),
                  ],
                ),
              ),
            ),
          );
  }

  @override
  Size get preferredSize => Size(
    Dimensions.webMaxWidth,
    ResponsiveHelper.isDesktop(Get.context)
        ? Dimensions.preferredSizeWhenDesktop
        : 74,
  );
}
