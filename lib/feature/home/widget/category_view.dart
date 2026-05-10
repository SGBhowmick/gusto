import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme Access
    final theme = Theme.of(context);

    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        // Responsive sizing (Logic Unchanged)
        final bool isDesktop = ResponsiveHelper.isDesktop(context);
        final double containerSize = isDesktop ? 100 : 95;
        final double imageSize = isDesktop ? 95 : 70;
        final double itemWidth = isDesktop ? 90 : 85;

        return categoryController.categoryList != null &&
                categoryController.categoryList!.isEmpty
            ? const SizedBox()
            : categoryController.categoryList != null
            ? Center(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleWidget(
                          textDecoration: TextDecoration.underline,
                          title: 'all_categories'.tr,
                          onTap: () =>
                              Get.toNamed(RouteHelper.getAllCategoriesScreen()),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        SizedBox(
                          height: ResponsiveHelper.isDesktop(context)
                              ? 150
                              : 120, // Slightly increased height for padding
                          child: ListView.builder(
                            itemCount:
                                categoryController.categoryList?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                            ), // Start padding
                            itemBuilder: (context, index) {
                              return TextHover(
                                builder: (hovered) {
                                  return InkWell(
                                    onTap: () => Get.toNamed(
                                      RouteHelper.getCategoryProductRoute(
                                        categoryController
                                            .categoryList![index]
                                            .id!,
                                        categoryController
                                                .categoryList?[index]
                                                .name ??
                                            '',
                                        index.toString(),
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ), // Match container radius
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.only(
                                        end: Dimensions.paddingSizeDefault,
                                      ), // Increased spacing
                                      child: Card(
                                        color: theme.cardColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ), // Match container radius
                                        ),

                                        elevation: 2,
                                        clipBehavior: Clip.antiAlias,
                                        child: Container(
                                          width:
                                              containerSize, // Removed as Card handles sizing
                                          // clipBehavior: Clip.antiAlias, // Removed as Card handles clipping
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme.shadowColor
                                                    .withOpacity(0.1),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
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
                                                      Colors.black.withOpacity(
                                                        0.9,
                                                      ),
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
                                                        ? Dimensions
                                                              .fontSizeDefault
                                                        : Dimensions
                                                              .fontSizeSmall,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const CategoryShimmer();
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  final bool? fromHomeScreen;

  const CategoryShimmer({super.key, this.fromHomeScreen = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(
          children: [
            if (fromHomeScreen!)
              const SizedBox(height: Dimensions.paddingSizeLarge),
            if (fromHomeScreen!)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title Shimmer
                  Container(
                    height: 25,
                    width: 120,
                    decoration: BoxDecoration(
                      color: theme.shadowColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // View All Shimmer
                  Container(
                    height: 25,
                    width: 80,
                    decoration: BoxDecoration(
                      color: theme.shadowColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            if (fromHomeScreen!)
              const SizedBox(height: Dimensions.paddingSizeSmall),

            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: !fromHomeScreen!
                  ? 8
                  : ResponsiveHelper.isDesktop(context)
                  ? 10
                  : ResponsiveHelper.isTab(context)
                  ? 12
                  : 8,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20), // Match new design
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withOpacity(0.1),
                    ),
                  ),
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: theme.shadowColor.withOpacity(0.3),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: theme.shadowColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                          ),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ],
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: !fromHomeScreen!
                    ? 8
                    : ResponsiveHelper.isDesktop(context)
                    ? 10
                    : ResponsiveHelper.isTab(context)
                    ? 6
                    : 4,
                crossAxisSpacing: Dimensions.paddingSizeSmall,
                mainAxisSpacing: Dimensions.paddingSizeSmall,
                childAspectRatio: 1,
              ),
            ),

            SizedBox(
              height: ResponsiveHelper.isDesktop(context)
                  ? 0
                  : Dimensions.paddingSizeLarge,
            ),
          ],
        ),
      ),
    );
  }
}
