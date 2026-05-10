import 'dart:ui'; // For ImageFilter
import 'package:dusto/common/widgets/custom_pop_widget.dart';
import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class CategoryScreen extends StatefulWidget {
  final String? fromPage;
  final String? campaignID;

  const CategoryScreen({super.key, this.fromPage, this.campaignID});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<CategoryModel>? categoryList;

  @override
  Widget build(BuildContext context) {
    // Access Theme Data
    final theme = Theme.of(context);

    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        endDrawer: ResponsiveHelper.isDesktop(context)
            ? const MenuDrawer()
            : null,
        appBar: CustomAppBar(title: 'categories'.tr),
        body: Stack(
          children: [
            // ===== 🔵 Background Ambient Blobs =====
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
            // Blur Effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
                child: Container(color: Colors.transparent),
              ),
            ),

            // ===== 📄 Main Content =====
            SafeArea(
              child: Scrollbar(
                child: widget.fromPage == 'fromCampaign'
                    ? GetBuilder<CategoryController>(
                        initState: (state) {
                          Get.find<CategoryController>()
                              .getCampaignBasedCategoryList(
                                widget.campaignID ?? "",
                                false,
                              );
                        },
                        builder: (categoryController) {
                          return _buildBody(
                            categoryController.campaignBasedCategoryList,
                          );
                        },
                      )
                    : GetBuilder<CategoryController>(
                        initState: (state) {
                          Get.find<CategoryController>().getCategoryList(false);
                        },
                        builder: (categoryController) {
                          return _buildBody(categoryController.categoryList);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<CategoryModel>? categoryList) {
    final theme = Theme.of(context);

    if (categoryList != null && categoryList.isEmpty) {
      return FooterBaseView(
        isCenter: true,
        child: NoDataScreen(
          type: NoDataType.categorySubcategory,
          text: 'no_category_found'.tr,
        ),
      );
    } else {
      if (categoryList != null) {
        return FooterBaseView(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isDesktop(context)
                          ? 6
                          : ResponsiveHelper.isTab(context)
                          ? 4
                          : 3,
                      childAspectRatio:
                          0.9, // Slightly taller for better text fit
                      mainAxisSpacing: Dimensions.paddingSizeDefault,
                      crossAxisSpacing: Dimensions.paddingSizeDefault,
                    ),
                    padding: const EdgeInsets.all(
                      Dimensions.paddingSizeDefault,
                    ),
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (widget.fromPage == 'fromCampaign') {
                            Get.find<CategoryController>().getSubCategoryList(
                              categoryList[index].id!,
                            );
                            Get.toNamed(
                              RouteHelper.subCategoryScreenRoute(
                                categoryList[index].name!,
                                categoryList[index].id!,
                                index,
                              ),
                            );
                          } else {
                            Get.toNamed(
                              RouteHelper.getCategoryProductRoute(
                                categoryList[index].id!,
                                categoryList[index].name!,
                                index.toString(),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(
                          24,
                        ), // Match container radius
                        child: Container(
                          // ===== 🔵 Expressive Card Design =====
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(
                              24,
                            ), // Expressive Roundness
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image with subtle background circle
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.05,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall,
                                  ),
                                  child: CustomImage(
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit.cover,
                                    image:
                                        '${categoryList[index].imageFullPath}',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: Dimensions.paddingSizeSmall,
                              ),

                              // Text styling
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  categoryList[index].name!,
                                  textAlign: TextAlign.center,
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: theme.textTheme.bodyLarge!.color,
                                    letterSpacing: 0.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    }
  }
}
