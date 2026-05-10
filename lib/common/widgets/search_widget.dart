import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Access Theme
    final theme = Theme.of(context);

    return GetBuilder<AllSearchController>(
      builder: (searchController) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(
              right: Dimensions.paddingSizeDefault,
              left: Dimensions.paddingSizeSmall,
            ),
            child: Container(
              height: Dimensions.searchbarSize,
              // ===== 🔵 Modern Floating Pill Design =====
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(
                  50,
                ), // Fully rounded (Stadium)
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController.searchController,
                style: theme.textTheme.displayMedium!.copyWith(
                  color: theme.textTheme.bodyLarge!.color,
                  fontSize: Dimensions.fontSizeLarge,
                ),
                cursorColor: theme.colorScheme.primary,
                autofocus: false,
                focusNode: searchController.searchFocus,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                  // Remove internal borders to use Container's decoration
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,

                  isDense: true,
                  hintText: 'search_services'.tr,
                  hintStyle: theme.textTheme.displayMedium!.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: theme.hintColor.withOpacity(0.7),
                  ),
                  filled: false,

                  // ===== 🔵 Added Prefix Search Icon =====
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: theme.hintColor.withOpacity(0.7),
                    size: 24,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 45,
                    maxHeight: 24,
                  ),

                  suffixIcon: searchController.isActiveSuffixIcon
                      ? IconButton(
                          color: theme.colorScheme.primary,
                          // M3 Rounded Icon
                          icon: const Icon(Icons.cancel_rounded, size: 20),
                          onPressed: () async {
                            if (searchController.searchController.text
                                .trim()
                                .isNotEmpty) {
                              Get.dialog(
                                const CustomLoader(),
                                barrierDismissible: false,
                              );
                              searchController.removeSortedItem(
                                removeItem: AllFilterType.query,
                                shouldUpdate: false,
                              );
                              await searchController.searchData(
                                query: "",
                                offset: 1,
                                shouldUpdate: false,
                                reload: false,
                              );
                              Get.back();
                            }
                            searchController.searchFocus.unfocus();
                          },
                        )
                      : const SizedBox(),
                ),
                onChanged: (text) {
                  if (text.isEmpty) {
                    searchController.searchFocus.unfocus();
                  }
                  searchController.showSuffixIcon(context, text);
                },
                onSubmitted: (text) {
                  if (text.isNotEmpty) {
                    if (text.length > 255) {
                      customSnackBar(
                        'search_text_length_message'.tr,
                        type: ToasterMessageType.info,
                      );
                    } else {
                      searchController.searchData(query: text, offset: 1);
                    }
                  } else {
                    customSnackBar(
                      'search_text_empty_message'.tr,
                      type: ToasterMessageType.info,
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
