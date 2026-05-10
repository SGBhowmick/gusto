import 'package:dusto/common/widgets/time_picker_snipper.dart';
import 'package:dusto/utils/core_export.dart';
import 'package:get/get.dart';

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    color: Get.isDarkMode
                        ? Theme.of(context).primaryColorLight
                        : Theme.of(context).primaryColorDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Text(
                  'time'.tr,
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            GetBuilder<ScheduleController>(
              builder: (createPostController) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hoverColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(
                      Dimensions.radiusDefault,
                    ),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TimePickerSpinner(
                    is24HourMode:
                        Get.find<SplashController>()
                            .configModel
                            .content
                            ?.timeFormat ==
                        '24',
                    normalTextStyle: robotoRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                    highlightedTextStyle: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: Get.isDarkMode
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Theme.of(
                              context,
                            ).textTheme.bodyLarge!.color?.withAlpha(200),
                    ),
                    spacing: Dimensions.paddingSizeSmall,
                    itemHeight: Dimensions.fontSizeLarge + 10,
                    itemWidth: 45,
                    alignment: Alignment.center,
                    isForce2Digits: true,
                    onTimeChange: (time) {
                      createPostController.selectedTime =
                          "${time.hour}:${time.minute}:${time.second}";
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
