import 'package:dusto/utils/core_export.dart';
import 'package:get/get.dart';

class SearchInputBoxApp extends StatefulWidget {
  const SearchInputBoxApp({super.key});

  @override
  State<SearchInputBoxApp> createState() => _SearchInputBoxAppState();
}

class _SearchInputBoxAppState extends State<SearchInputBoxApp> {
  @override
  void initState() {
    super.initState();
    requestFocus();
  }

  Future<void> requestFocus() async {
    Timer(const Duration(milliseconds: 200), () {
      if (!ResponsiveHelper.isWeb()) {
        Get.find<AllSearchController>().searchFocus.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<AllSearchController>(
      builder: (searchController) {
        return Center(
          child: Container(
            // ===== 🔵 Modern Floating Pill Design =====
            margin: const EdgeInsets.symmetric(
              horizontal: 5,
            ), // Slight margin to show shadow
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(50), // Full Pill Shape
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: searchController.searchController,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
              cursorColor: theme.colorScheme.primary,
              autofocus: false,
              focusNode: searchController.searchFocus,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.search,

              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                // Remove default borders to use Container's decoration
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,

                isDense: true,
                hintText: 'search_services'.tr,
                hintStyle: robotoRegular.copyWith(
                  color: theme.hintColor.withOpacity(0.6),
                  fontSize: Dimensions.fontSizeDefault,
                ),
                filled: false,

                // ===== 🔵 Added Prefix Icon =====
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.hintColor.withOpacity(0.6),
                  size: 22,
                ),

                // ===== 🔵 Styled Suffix Action Button =====
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4.0), // Padding inside the pill
                  child: InkWell(
                    onTap: () {
                      if (searchController.searchController.text.isNotEmpty &&
                          searchController.searchController.text.length > 255) {
                        customSnackBar(
                          'search_text_length_message'.tr,
                          showDefaultSnackBar: false,
                          type: ToasterMessageType.info,
                        );
                      } else if (searchController
                          .searchController
                          .text
                          .isEmpty) {
                        customSnackBar(
                          'search_text_empty_message'.tr,
                          showDefaultSnackBar: false,
                          type: ToasterMessageType.info,
                        );
                      } else {
                        Get.back();
                        FocusScope.of(context).unfocus();
                        Get.toNamed(
                          RouteHelper.getSearchResultRoute(
                            queryText: searchController.searchController.text,
                          ),
                        );
                        FocusScope.of(context).unfocus();
                      }
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(
                        10,
                      ), // Adjust padding for icon size
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      // Using colorFilter to ensure the icon is white/visible on primary color
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          Images.searchIcon,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              onChanged: (text) {
                searchController.showSuffixIcon(context, text);
                if (text.trim().isNotEmpty) {
                  searchController.getSearchSuggestion(text);
                }
              },
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  if (text.length > 255) {
                    customSnackBar(
                      'search_text_length_message'.tr,
                      type: ToasterMessageType.info,
                    );
                  } else {
                    Get.back();
                    FocusScope.of(context).unfocus();
                    Get.toNamed(
                      RouteHelper.getSearchResultRoute(queryText: text),
                    );
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
        );
      },
    );
  }
}
