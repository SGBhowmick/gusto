import 'package:dusto/common/widgets/custom_pop_widget.dart';
import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class CategorySubCategoryScreen extends StatefulWidget {
  final String categoryID;
  final String categoryIndex;
  const CategorySubCategoryScreen({
    super.key,
    required this.categoryID,
    required this.categoryIndex,
  });

  @override
  State<CategorySubCategoryScreen> createState() =>
      _CategorySubCategoryScreenState();
}

class _CategorySubCategoryScreenState extends State<CategorySubCategoryScreen> {
  AutoScrollController? scrollController;
  String? categoryIndex;
  int availableServiceCount = 0;

  @override
  void initState() {
    scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
    scrollController!.scrollToIndex(
      int.tryParse(widget.categoryIndex) ?? 0,
      preferPosition: AutoScrollPosition.middle,
    );
    scrollController!.highlight(int.tryParse(widget.categoryIndex) ?? 0);

    if (Get.find<LocationController>().getUserAddress() != null) {
      availableServiceCount = Get.find<LocationController>()
          .getUserAddress()!
          .availableServiceCountInZone!;
    }

    Get.find<CategoryController>().getCategoryList(false);
    categoryIndex = widget.categoryIndex;
    Get.find<CategoryController>().getSubCategoryList(
      widget.categoryID,
      shouldUpdate: false,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: GetBuilder<CategoryController>(
        builder: (categoryController) {
          return Scaffold(
            endDrawer: ResponsiveHelper.isDesktop(context)
                ? const MenuDrawer()
                : null,
            appBar: CustomAppBar(title: 'available_service'.tr),
            body: FooterBaseView(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: availableServiceCount > 0
                    ? CustomScrollView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.paddingSizeExtraLarge
                                  : Dimensions.paddingSizeExtraSmall,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child:
                                (categoryController.categoryList != null &&
                                    !categoryController.isSearching!)
                                ? Center(
                                    child: Container(
                                      height:
                                          ResponsiveHelper.isDesktop(context)
                                          ? 140
                                          : ResponsiveHelper.isTab(context)
                                          ? 140
                                          : 130,
                                      margin: EdgeInsets.only(
                                        left:
                                            ResponsiveHelper.isDesktop(context)
                                            ? 0
                                            : Dimensions.paddingSizeDefault,
                                      ),
                                      width: Dimensions.webMaxWidth,
                                      padding: const EdgeInsets.only(
                                        bottom:
                                            Dimensions.paddingSizeExtraSmall,
                                        top: Dimensions.paddingSizeDefault,
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        controller: scrollController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: categoryController
                                            .categoryList!
                                            .length,
                                        physics: const ClampingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          CategoryModel categoryModel =
                                              categoryController.categoryList!
                                                  .elementAt(index);
                                          return AutoScrollTag(
                                            controller: scrollController!,
                                            key: ValueKey(index),
                                            index: index,
                                            child: InkWell(
                                              onTap: () async {
                                                categoryIndex = index
                                                    .toString();
                                                Get.find<CategoryController>()
                                                    .getSubCategoryList(
                                                      categoryModel.id!,
                                                    );
                                                await scrollController!
                                                    .scrollToIndex(
                                                      index,
                                                      preferPosition:
                                                          AutoScrollPosition
                                                              .middle,
                                                      duration: const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                await scrollController!
                                                    .highlight(index);
                                              },
                                              hoverColor: Colors.transparent,
                                              child: Container(
                                                width:
                                                    ResponsiveHelper.isDesktop(
                                                      context,
                                                    )
                                                    ? 140
                                                    : ResponsiveHelper.isTab(
                                                        context,
                                                      )
                                                    ? 140
                                                    : 100,

                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeExtraSmall,
                                                    ),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  border:
                                                      index ==
                                                          int.parse(
                                                            categoryIndex!,
                                                          )
                                                      ? Border.all(
                                                          color: Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                          width: 2,
                                                        )
                                                      : null,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        Dimensions
                                                            .radiusExtraLarge,
                                                      ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .shadowColor
                                                          .withOpacity(0.1),
                                                      blurRadius: 10,
                                                      offset: const Offset(
                                                        0,
                                                        4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    CustomImage(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          '${categoryController.categoryList![index].imageFullPath}',
                                                    ),
                                                    DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                                .withOpacity(
                                                                  0.4,
                                                                ),
                                                            Colors.black
                                                                .withOpacity(
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
                                                            .categoryList![index]
                                                            .name!,
                                                        style: robotoMedium
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : ResponsiveHelper.isDesktop(context)
                                ? const CategoryShimmer(fromHomeScreen: false)
                                : const SizedBox(),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              width: Dimensions.webMaxWidth,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeLarge,
                                ),
                                child: Center(
                                  child: Text(
                                    'sub_categories'.tr,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SubCategoryView(
                            noDataText: "no_subcategory_found".tr,
                            isScrollable: true,
                          ),
                        ],
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * .6,
                        child: const ServiceNotAvailableScreen(),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
