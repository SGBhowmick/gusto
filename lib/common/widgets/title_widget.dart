import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final TextDecoration? textDecoration;
  final Function()? onTap;
  final Color? color;
  const TitleWidget({
    super.key,
    required this.title,
    this.onTap,
    this.textDecoration,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title!.tr,
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: title == 'recently_view_services'
                  ? Get.isDarkMode
                        ? Colors.black
                        : Theme.of(context).textTheme.bodyLarge!.color
                  : Theme.of(context).textTheme.bodyLarge!.color!,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        (onTap != null)
            ? InkWell(
                onTap: onTap,
                child: Text(
                  'see_all'.tr,
                  style: robotoRegular.copyWith(
                    decoration: textDecoration,
                    color: title == 'recently_view_services'
                        ? Get.isDarkMode
                              ? Colors.black
                              : Theme.of(context).textTheme.bodyLarge!.color
                        : Theme.of(context).textTheme.bodyLarge!.color,

                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
