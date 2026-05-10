import 'package:dusto/utils/core_export.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String? buttonText;
  final bool? transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final IconData? icon;
  final String? assetIcon;
  final Color? backgroundColor;
  final bool showBorder;
  final bool isLoading;
  final Color? textColor;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.transparent = false,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.radius = 5,
    this.icon,
    this.assetIcon,
    this.backgroundColor,
    this.isLoading = false,
    this.textColor,
    this.showBorder = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Theme & Logic checks
    final theme = Theme.of(context);
    final bool isDisabled = onPressed == null;
    final bool isTransparent = transparent ?? false;

    // Expressive Design: Determine Decoration (Gradient vs Solid)
    Gradient? buttonGradient;
    Color? buttonColor;

    if (isDisabled) {
      buttonColor = theme.disabledColor;
    } else if (isTransparent) {
      buttonColor = Colors.transparent;
    } else if (backgroundColor != null) {
      buttonColor = backgroundColor;
    } else {
      // ===== 🟡 Dusto Car Wash Gradient (Yellow/Gold) =====
      buttonGradient = const LinearGradient(
        colors: [
          Color.fromARGB(255, 255, 255, 0),
          Color.fromRGBO(255, 224, 48, 1), // Dusto Bright Yellow
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return Center(
      child: SizedBox(
        width: width ?? Dimensions.webMaxWidth,
        child: Padding(
          padding: margin == null ? const EdgeInsets.all(0) : margin!,
          child: Container(
            height: height ?? (ResponsiveHelper.isDesktop(context) ? 50 : 45),
            decoration: BoxDecoration(
              gradient: buttonGradient,
              color: buttonColor,
              borderRadius: BorderRadius.circular(radius!),
              border: showBorder
                  ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                  : null,
              boxShadow: (isTransparent || isDisabled)
                  ? null
                  : [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: TextButton(
              onPressed: isLoading ? null : onPressed,
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius!),
                ),
                // ===== ⚫ Ripple Color (Black for Yellow bg) =====
                overlayColor: Colors.black.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Section
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall,
                      ),
                      child: Icon(
                        icon,
                        // ===== ⚫ Changed to Black for visibility =====
                        color:
                            textColor ??
                            (isTransparent
                                ? theme.colorScheme.primary
                                : Colors.black),
                        size: 18,
                      ),
                    )
                  else if (assetIcon != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                      ),
                      child: Image.asset(
                        assetIcon!,
                        height: 16,
                        width: 16,
                        // ===== ⚫ Changed to Black for visibility =====
                        color: isTransparent
                            ? theme.primaryColor
                            : textColor ?? Colors.black,
                      ),
                    ),

                  // Loading Indicator
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        height: fontSize ?? Dimensions.fontSizeDefault,
                        width: fontSize ?? Dimensions.fontSizeDefault,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          // ===== ⚫ Changed to Black for visibility =====
                          color: isTransparent
                              ? theme.colorScheme.primary
                              : Colors.black,
                        ),
                      ),
                    ),

                  // Text
                  Text(
                    isLoading ? "loading".tr : buttonText ?? '',
                    textAlign: TextAlign.center,
                    style:
                        textStyle ??
                        robotoMedium.copyWith(
                          // ===== ⚫ Changed to Black for visibility =====
                          color:
                              textColor ??
                              (isTransparent
                                  ? theme.colorScheme.primary
                                  : Colors.black),

                          fontSize: fontSize ?? Dimensions.fontSizeDefault,
                          letterSpacing: 0.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
