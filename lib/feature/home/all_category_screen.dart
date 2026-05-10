import 'dart:ui'; // Required for ImageFilter
import 'package:dusto/common/widgets/custom_pop_widget.dart';
import 'package:dusto/helper/extension_helper.dart';
import 'package:dusto/utils/core_export.dart';
import 'package:get/get.dart';

class AllCategoryScreen extends StatelessWidget {
  const AllCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Logic: Responsive sizing (Unchanged)
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final double containerSize = isDesktop ? 100 : 100;
    final double imageSize = isDesktop ? 50 : 90;
    final double itemWidth = isDesktop ? 80 : 65;
    final double? pageSizeWidth = ResponsiveHelper.isDesktop(context)
        ? Dimensions.webMaxWidth * 0.6
        : null;

    // Access Theme
    final theme = Theme.of(context);

    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        endDrawer: ResponsiveHelper.isDesktop(context)
            ? const MenuDrawer()
            : null,
        appBar: CustomAppBar(title: 'all_categories'.tr),

        body: Stack(
          children: [
            // ===== 1. Ambient Background Blobs (Unchanged) =====
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -80,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.tertiary.withOpacity(0.08),
                ),
              ),
            ),

            // ===== 2. Glassmorphism Blur (Unchanged) =====
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
                child: Container(color: Colors.transparent),
              ),
            ),

            // ===== 3. Main Content (Logic Unchanged) =====
            FooterBaseView(
              child: SizedBox(
                width: pageSizeWidth,
                child: GetBuilder<CategoryController>(
                  builder: (categoryController) {
                    return Padding(
                      padding: const EdgeInsets.all(
                        Dimensions.paddingSizeDefault,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isMobile(context)
                              ? 3
                              : 4,
                          crossAxisSpacing: Dimensions.paddingSizeDefault,
                          mainAxisSpacing: Dimensions.paddingSizeDefault,
                          childAspectRatio:
                              MediaQuery.of(context).size.width < 400
                              ? 0.85
                              : 0.95,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoryController.categoryList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TextHover(
                            builder: (hovered) {
                              return InkWell(
                                onTap: () => Get.toNamed(
                                  RouteHelper.getCategoryProductRoute(
                                    categoryController.categoryList![index].id!,
                                    categoryController
                                            .categoryList?[index]
                                            .name ??
                                        '',
                                    index.toString(),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(24),
                                child: Card(
                                  color: theme.cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 2,
                                  clipBehavior: Clip.antiAlias,

                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CustomImage(
                                        image:
                                            categoryController
                                                .categoryList?[index]
                                                .imageFullPath ??
                                            "",
                                        fit: BoxFit.cover,
                                      ),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              theme.colorScheme.primary
                                                  .withOpacity(0.4),
                                              Colors.black.withOpacity(0.9),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 12,
                                        left: 8,
                                        right: 8,
                                        child: Text(
                                          categoryController
                                                  .categoryList?[index]
                                                  .name ??
                                              '',
                                          style: robotoMedium.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: isDesktop
                                                ? Dimensions.fontSizeDefault
                                                : Dimensions.fontSizeSmall,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
