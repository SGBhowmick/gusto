import 'dart:ui'; // For ImageFilter
import 'package:dusto/common/widgets/custom_pop_widget.dart';
import 'package:get/get.dart';
import 'package:dusto/utils/core_export.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final String? redirectRoute;
  const SignInScreen({
    super.key,
    required this.exitFromApp,
    this.redirectRoute,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var signInPhoneController = TextEditingController();
  var signInPasswordController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _phoneFocus = FocusNode();

  final GlobalKey<FormState> customerSignInKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initializeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        // ===== 🔵 1. M3 Expressive Background =====
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            Positioned(
              top: -100,
              left: -50,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(
                    255,
                    255,
                    219,
                    156,
                  ).withOpacity(0.15), // Cyan tint
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(
                    255,
                    253,
                    243,
                    190,
                  ), // Dusto Bright Yellow/ Blue tint
                ),
              ),
            ),

            // Main Content
            SafeArea(
              child: Column(
                children: [
                  // Custom App Bar (Only if not desktop and exitFromApp is false)
                  if (!ResponsiveHelper.isDesktop(context) &&
                      !widget.exitFromApp)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),

                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: FooterBaseView(
                          isCenter: true,
                          child: WebShadowWrap(
                            child: GetBuilder<SplashController>(
                              builder: (splashController) {
                                return GetBuilder<AuthController>(
                                  builder: (authController) {
                                    var config =
                                        splashController.configModel.content;
                                    var otpLogin = config
                                        ?.customerLogin
                                        ?.loginOption
                                        ?.otpLogin;
                                    var manualLogin =
                                        config
                                            ?.customerLogin
                                            ?.loginOption
                                            ?.manualLogin ??
                                        1;
                                    var socialLogin = config
                                        ?.customerLogin
                                        ?.loginOption
                                        ?.socialMediaLogin;

                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            ResponsiveHelper.isDesktop(context)
                                            ? Dimensions.webMaxWidth / 3.5
                                            : ResponsiveHelper.isTab(context)
                                            ? Dimensions.webMaxWidth / 5.5
                                            : Dimensions.paddingSizeLarge,
                                      ),
                                      child: Container(
                                        // ===== 🔵 2. Login Card Container =====
                                        padding: const EdgeInsets.all(26),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                            43,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.15,
                                              ),
                                              blurRadius: 30,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer
                                                .withOpacity(0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Form(
                                          autovalidateMode:
                                              ResponsiveHelper.isDesktop(
                                                context,
                                              )
                                              ? AutovalidateMode
                                                    .onUserInteraction
                                              : AutovalidateMode.disabled,
                                          key: customerSignInKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 36), //
                                              // Logo & Header
                                              Hero(
                                                tag: Images.logo,
                                                child: Image.asset(
                                                  Images.logo,
                                                  width: Dimensions.logoSize2,
                                                ),
                                              ),
                                              const SizedBox(height: 16),

                                              const SizedBox(height: 8),
                                              Text(
                                                "sign_in".tr,
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault,
                                                  color: Theme.of(
                                                    context,
                                                  ).textTheme.titleLarge!.color,
                                                ),
                                              ),

                                              SizedBox(
                                                height:
                                                    manualLogin == 1 ||
                                                        otpLogin == 1
                                                    ? 32
                                                    : Dimensions
                                                          .paddingSizeDefault,
                                              ),

                                              // Input Fields
                                              manualLogin == 1 || otpLogin == 1
                                                  ? CustomTextField(
                                                      onCountryChanged:
                                                          (countryCode) =>
                                                              authController
                                                                      .countryDialCode =
                                                                  countryCode
                                                                      .dialCode!,
                                                      countryDialCode:
                                                          authController
                                                                  .isNumberLogin ||
                                                              (manualLogin ==
                                                                      0 &&
                                                                  otpLogin == 1)
                                                          ? authController
                                                                .countryDialCode
                                                          : null,
                                                      title: 'email_phone'.tr,
                                                      hintText:
                                                          authController
                                                                      .selectedLoginMedium ==
                                                                  LoginMedium
                                                                      .otp ||
                                                              (manualLogin ==
                                                                      0 &&
                                                                  otpLogin == 1)
                                                          ? "please_enter_phone_number"
                                                                .tr
                                                          : 'enter_email_or_phone'
                                                                .tr,
                                                      controller:
                                                          signInPhoneController,
                                                      focusNode: _phoneFocus,
                                                      nextFocus: _passwordFocus,
                                                      capitalization:
                                                          TextCapitalization
                                                              .words,
                                                      onChanged: (String text) {
                                                        // Logic remains unchanged
                                                        if (authController
                                                                .selectedLoginMedium !=
                                                            LoginMedium.otp) {
                                                          final numberRegExp =
                                                              RegExp(
                                                                r'^[+]?[0-9]+$',
                                                              );
                                                          if (text.isEmpty &&
                                                              authController
                                                                  .isNumberLogin) {
                                                            authController
                                                                .toggleIsNumberLogin();
                                                          }
                                                          if (text.startsWith(
                                                                numberRegExp,
                                                              ) &&
                                                              !authController
                                                                  .isNumberLogin &&
                                                              manualLogin ==
                                                                  1) {
                                                            authController
                                                                .toggleIsNumberLogin();
                                                            final cursorPosition =
                                                                signInPhoneController
                                                                    .selection
                                                                    .baseOffset;
                                                            signInPhoneController
                                                                .text = text
                                                                .replaceAll(
                                                                  "+",
                                                                  "",
                                                                );
                                                            signInPhoneController
                                                                    .selection =
                                                                TextSelection.fromPosition(
                                                                  TextPosition(
                                                                    offset:
                                                                        cursorPosition,
                                                                  ),
                                                                );
                                                          }
                                                          final emailRegExp =
                                                              RegExp(r'@');
                                                          if (text.contains(
                                                                emailRegExp,
                                                              ) &&
                                                              authController
                                                                  .isNumberLogin &&
                                                              manualLogin ==
                                                                  1) {
                                                            authController
                                                                .toggleIsNumberLogin();
                                                          }
                                                          _phoneFocus
                                                              .requestFocus();
                                                        }
                                                      },
                                                      onValidate: (String? value) {
                                                        // Logic remains unchanged
                                                        if (otpLogin == 1 &&
                                                            manualLogin == 0 &&
                                                            PhoneVerificationHelper.getValidPhoneNumber(
                                                                  authController
                                                                          .countryDialCode +
                                                                      signInPhoneController
                                                                          .text
                                                                          .trim(),
                                                                  withCountryCode:
                                                                      true,
                                                                ) ==
                                                                "") {
                                                          return "enter_valid_phone_number"
                                                              .tr;
                                                        }
                                                        if (authController
                                                                .isNumberLogin &&
                                                            PhoneVerificationHelper.getValidPhoneNumber(
                                                                  authController
                                                                          .countryDialCode +
                                                                      signInPhoneController
                                                                          .text
                                                                          .trim(),
                                                                  withCountryCode:
                                                                      true,
                                                                ) ==
                                                                "") {
                                                          return "enter_valid_phone_number"
                                                              .tr;
                                                        }
                                                        return (PhoneVerificationHelper.getValidPhoneNumber(
                                                                      authController
                                                                              .countryDialCode +
                                                                          signInPhoneController
                                                                              .text
                                                                              .trim(),
                                                                      withCountryCode:
                                                                          true,
                                                                    ) !=
                                                                    "" ||
                                                                GetUtils.isEmail(
                                                                  value ?? "",
                                                                ))
                                                            ? null
                                                            : 'enter_email_or_phone'
                                                                  .tr;
                                                      },
                                                    )
                                                  : const SizedBox.shrink(),

                                              SizedBox(
                                                height:
                                                    manualLogin == 1 &&
                                                        authController
                                                                .selectedLoginMedium ==
                                                            LoginMedium.manual
                                                    ? Dimensions
                                                          .paddingSizeTextFieldGap
                                                    : 0,
                                              ),

                                              manualLogin == 1 &&
                                                      authController
                                                              .selectedLoginMedium ==
                                                          LoginMedium.manual
                                                  ? CustomTextField(
                                                      title: 'password'.tr,
                                                      hintText:
                                                          '************'.tr,
                                                      controller:
                                                          signInPasswordController,
                                                      focusNode: _passwordFocus,
                                                      inputType: TextInputType
                                                          .visiblePassword,
                                                      isPassword: true,
                                                      inputAction:
                                                          TextInputAction.done,
                                                      onValidate: (String? value) {
                                                        return FormValidation()
                                                            .isValidPassword(
                                                              value!.tr,
                                                            );
                                                      },
                                                    )
                                                  : const SizedBox.shrink(),

                                              SizedBox(
                                                height:
                                                    authController
                                                            .selectedLoginMedium ==
                                                        LoginMedium.manual
                                                    ? Dimensions
                                                          .paddingSizeDefault
                                                    : 0,
                                              ),

                                              // Remember Me & Forgot Password
                                              manualLogin == 1 || otpLogin == 1
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () =>
                                                              authController
                                                                  .toggleRememberMe(),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 20.0,
                                                                child: Checkbox(
                                                                  activeColor:
                                                                      Theme.of(
                                                                        context,
                                                                      ).colorScheme.primary,
                                                                  value: authController
                                                                      .isActiveRememberMe,
                                                                  onChanged:
                                                                      (
                                                                        bool?
                                                                        isChecked,
                                                                      ) => authController
                                                                          .toggleRememberMe(),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          4,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: Dimensions
                                                                    .paddingSizeExtraSmall,
                                                              ),
                                                              Text(
                                                                'remember_me'
                                                                    .tr,
                                                                style: robotoRegular
                                                                    .copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeSmall,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        manualLogin == 1 &&
                                                                authController
                                                                        .selectedLoginMedium ==
                                                                    LoginMedium
                                                                        .manual
                                                            ? TextButton(
                                                                onPressed: () {
                                                                  Get.toNamed(
                                                                    RouteHelper.getSendOtpScreen(
                                                                      redirectUrl:
                                                                          widget
                                                                              .redirectRoute,
                                                                    ),
                                                                  );
                                                                },
                                                                child: Text(
                                                                  'forgot_password'
                                                                      .tr,
                                                                  style: robotoMedium.copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall,
                                                                    color: Theme.of(
                                                                      context,
                                                                    ).colorScheme.error,
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox.shrink(),
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),

                                              SizedBox(
                                                height:
                                                    manualLogin == 1 ||
                                                        otpLogin == 1
                                                    ? 24
                                                    : 0,
                                              ),

                                              // Main Button
                                              manualLogin == 1 || otpLogin == 1
                                                  ? CustomButton(
                                                      buttonText:
                                                          (authController
                                                                      .selectedLoginMedium ==
                                                                  LoginMedium
                                                                      .otp) ||
                                                              (manualLogin ==
                                                                      0 &&
                                                                  otpLogin == 1)
                                                          ? "get_otp".tr
                                                          : 'sign_in'.tr,
                                                      onPressed: () {
                                                        if (customerSignInKey
                                                            .currentState!
                                                            .validate()) {
                                                          _login(
                                                            authController,
                                                            manualLogin,
                                                            otpLogin,
                                                          );
                                                        }
                                                      },
                                                      radius:
                                                          12, // More rounded
                                                      isLoading: authController
                                                          .isLoading,
                                                    )
                                                  : const SizedBox.shrink(),

                                              SizedBox(
                                                height:
                                                    manualLogin == 1 ||
                                                        otpLogin == 1
                                                    ? Dimensions
                                                          .paddingSizeDefault
                                                    : 0,
                                              ),

                                              // OR Divider
                                              (manualLogin == 1 ||
                                                          otpLogin == 1) &&
                                                      socialLogin == 1
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Divider(
                                                              color: Theme.of(
                                                                context,
                                                              ).dividerColor,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      10,
                                                                ),
                                                            child: Text(
                                                              'or'.tr,
                                                              style: robotoRegular.copyWith(
                                                                color: Theme.of(
                                                                  context,
                                                                ).hintColor,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Divider(
                                                              color: Theme.of(
                                                                context,
                                                              ).dividerColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),

                                              // ===== 🔵 3. Switch Login Method (Pill Style) =====
                                              manualLogin == 1 &&
                                                      (otpLogin == 1 ||
                                                          socialLogin == 1)
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 16,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surfaceContainerHighest
                                                            .withOpacity(0.3),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              50,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'sign_in_with'.tr,
                                                            style: robotoRegular.copyWith(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .color,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          otpLogin == 1 &&
                                                                  manualLogin ==
                                                                      1
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    // Switcher Logic
                                                                    String
                                                                    phoneWithoutCountryCode = PhoneVerificationHelper.getValidPhoneNumber(
                                                                      Get.find<
                                                                            AuthController
                                                                          >()
                                                                          .getUserNumber(),
                                                                    );
                                                                    String
                                                                    countryCode = PhoneVerificationHelper.getCountryCode(
                                                                      Get.find<
                                                                            AuthController
                                                                          >()
                                                                          .getUserNumber(),
                                                                    );

                                                                    if (authController
                                                                            .selectedLoginMedium ==
                                                                        LoginMedium
                                                                            .otp) {
                                                                      authController.toggleSelectedLoginMedium(
                                                                        loginMedium:
                                                                            LoginMedium.manual,
                                                                      );
                                                                      signInPhoneController
                                                                              .text =
                                                                          phoneWithoutCountryCode !=
                                                                              ""
                                                                          ? phoneWithoutCountryCode
                                                                          : authController.getUserNumber();
                                                                      if (countryCode !=
                                                                          "") {
                                                                        authController.toggleIsNumberLogin(
                                                                          value:
                                                                              true,
                                                                        );
                                                                      } else {
                                                                        authController.toggleIsNumberLogin(
                                                                          value:
                                                                              false,
                                                                        );
                                                                      }
                                                                      authController.initCountryCode(
                                                                        countryCode:
                                                                            countryCode !=
                                                                                ""
                                                                            ? countryCode
                                                                            : null,
                                                                      );
                                                                      signInPasswordController
                                                                          .text = authController
                                                                          .getUserPassword();

                                                                      if (signInPasswordController
                                                                          .text
                                                                          .isEmpty) {
                                                                        signInPhoneController.text =
                                                                            "";
                                                                        authController.toggleIsNumberLogin(
                                                                          value:
                                                                              false,
                                                                        );
                                                                      }
                                                                    } else {
                                                                      authController.toggleSelectedLoginMedium(
                                                                        loginMedium:
                                                                            LoginMedium.otp,
                                                                      );
                                                                      authController.toggleIsNumberLogin(
                                                                        value:
                                                                            true,
                                                                      );
                                                                      signInPasswordController
                                                                          .clear();

                                                                      signInPhoneController
                                                                              .text =
                                                                          phoneWithoutCountryCode;
                                                                      authController.initCountryCode(
                                                                        countryCode:
                                                                            countryCode !=
                                                                                ""
                                                                            ? countryCode
                                                                            : null,
                                                                      );
                                                                    }
                                                                  },
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        20,
                                                                      ),
                                                                  child: Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          6,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color: Theme.of(context)
                                                                          .colorScheme
                                                                          .primary
                                                                          .withOpacity(0.1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            20,
                                                                          ),
                                                                      border: Border.all(
                                                                        color: Theme.of(
                                                                          context,
                                                                        ).colorScheme.primary.withOpacity(0.2),
                                                                      ),
                                                                    ),
                                                                    child: Text(
                                                                      authController.selectedLoginMedium ==
                                                                              LoginMedium.manual
                                                                          ? 'OTP'.tr
                                                                          : "email_phone".tr,
                                                                      style: robotoBold.copyWith(
                                                                        color: Theme.of(
                                                                          context,
                                                                        ).colorScheme.primary,
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),

                                              socialLogin == 1
                                                  ? SocialLoginWidget(
                                                      redirectUrl:
                                                          widget.redirectRoute,
                                                    )
                                                  : const SizedBox(),
                                              const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeDefault,
                                              ),

                                              // Sign Up Row
                                              manualLogin == 1
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${'do_not_have_an_account'.tr} ',
                                                          style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .color,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            signInPhoneController
                                                                .clear();
                                                            signInPasswordController
                                                                .clear();
                                                            Get.toNamed(
                                                              RouteHelper.getSignUpRoute(
                                                                redirectUrl: widget
                                                                    .redirectRoute,
                                                              ),
                                                            );
                                                          },
                                                          style: TextButton.styleFrom(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            minimumSize:
                                                                const Size(
                                                                  50,
                                                                  30,
                                                                ),
                                                            tapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                          ),
                                                          child: Text(
                                                            'sign_up_here'.tr,
                                                            style: robotoBold.copyWith(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .primary,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),
                                              const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeExtraSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initializeController() {
    var authController = Get.find<AuthController>();
    String phoneWithoutCountryCode =
        PhoneVerificationHelper.getValidPhoneNumber(
          Get.find<AuthController>().getUserNumber(),
        );
    String countryCode = PhoneVerificationHelper.getCountryCode(
      Get.find<AuthController>().getUserNumber(),
    );

    var config = Get.find<SplashController>().configModel.content;
    var manualLogin = config?.customerLogin?.loginOption?.manualLogin ?? 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (countryCode != "" && phoneWithoutCountryCode != "") {
        authController.toggleIsNumberLogin(value: true);
      } else {
        authController.toggleIsNumberLogin(value: false);
      }
      authController.toggleSelectedLoginMedium(loginMedium: LoginMedium.manual);
      authController.initCountryCode(
        countryCode: countryCode != "" ? countryCode : null,
      );

      signInPhoneController.text = phoneWithoutCountryCode != ""
          ? phoneWithoutCountryCode
          : authController.isNumberLogin
          ? ""
          : Get.find<AuthController>().getUserNumber();
      signInPasswordController.text = Get.find<AuthController>()
          .getUserPassword();

      if (manualLogin == 1 && signInPasswordController.text.isEmpty) {
        signInPhoneController.text = "";
        authController.initCountryCode();
        authController.toggleIsNumberLogin(value: false);
      }
    });
    authController.toggleRememberMe(value: false, shouldUpdate: false);
  }

  void _login(
    AuthController authController,
    var manualLogin,
    var otpLogin,
  ) async {
    if (customerSignInKey.currentState!.validate()) {
      var config = Get.find<SplashController>().configModel.content;

      SendOtpType type = config?.firebaseOtpVerification == 1
          ? SendOtpType.firebase
          : SendOtpType.verification;

      String phone = PhoneVerificationHelper.getValidPhoneNumber(
        authController.countryDialCode + signInPhoneController.text.trim(),
        withCountryCode: true,
      );

      if ((authController.selectedLoginMedium == LoginMedium.otp) ||
          (manualLogin == 0 && otpLogin == 1)) {
        authController
            .sendVerificationCode(
              identity: phone,
              identityType: "phone",
              type: type,
              checkUser: 0,
              redirectUrl: widget.redirectRoute,
            )
            .then((status) {
              if (status != null) {
                if (status.isSuccess!) {
                  Get.toNamed(
                    RouteHelper.getVerificationRoute(
                      identity: phone,
                      identityType: "phone",
                      fromPage: config?.firebaseOtpVerification == 1
                          ? "firebase-otp"
                          : "otp-login",
                      firebaseSession: type == SendOtpType.firebase
                          ? status.message
                          : null,
                      redirectUrl: widget.redirectRoute,
                    ),
                  );
                } else {
                  customSnackBar(status.message.toString().capitalizeFirst);
                }
              }
            });
      } else {
        authController.login(
          redirectRoute: widget.redirectRoute,
          emailPhone: phone != "" ? phone : signInPhoneController.text.trim(),
          password: signInPasswordController.text.trim(),
          type: phone != "" ? "phone" : "email",
        );
      }
    }
  }
}
