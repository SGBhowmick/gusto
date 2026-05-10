import 'package:dusto/utils/core_export.dart';
import 'package:get/get.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? backButton;
  const SearchAppBar({super.key, this.backButton = true});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? const WebMenuBar()
        : Container(
            // ===== 🟡 Dusto Car Wash Themed Background =====
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 240, 152), // Dusto Bright Yellow
                  Color.fromARGB(255, 247, 227, 2), // Dusto Darker Yellow/Amber
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, // Subtle shadow
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    // ===== ⚫ Modern Back Button (Black for contrast) =====
                    if (backButton!)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: Colors
                                .black, // Changed to Black for visibility on Yellow
                          ),
                          tooltip: 'Back',
                          style: IconButton.styleFrom(
                            // Dark semi-transparent background for the button circle
                            backgroundColor: Colors.black.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(40, 40),
                          ),
                          onPressed: () {
                            Get.find<AllSearchController>()
                                .clearSearchController(shouldUpdate: false);
                            Navigator.pop(context);
                          },
                        ),
                      ),

                    // ===== 🔎 Search Widget (Expanded) =====
                    const Expanded(child: SearchWidget()),
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
        : 80,
  );
}
