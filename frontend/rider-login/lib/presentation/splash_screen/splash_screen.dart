import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../theme/text_style_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import './bloc/splash_bloc.dart';
import './models/splash_model.dart';
import 'bloc/splash_bloc.dart';
import 'models/splash_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create:
          (context) =>
              SplashBloc(SplashState(splashModel: SplashModel()))
                ..add(SplashInitialEvent()),
      child: SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: appTheme.colorFFDCE4,
            body: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogoSection(context),
                  SizedBox(height: 20.h),
                  _buildAppNameSection(context),
                  SizedBox(height: 20.h),
                  _buildButtonsSection(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the logo section of the splash screen
  Widget _buildLogoSection(BuildContext context) {
    return CustomImageView(
      imagePath: ImageConstant.imgScreenshot20250408at22536pmremovebgpreview1,
      height: 220.h,
      width: 220.h,
    );
  }

  /// Builds the app name section of the splash screen
  Widget _buildAppNameSection(BuildContext context) {
    return CustomImageView(
      imagePath: ImageConstant.imgScreenshot20250408at22908pmremovebgpreview1,
      height: 60.h,
      width: 346.h,
    );
  }

  /// Builds the login and signup buttons section
  Widget _buildButtonsSection(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          height: 43.h,
          width: 156.h,
          text: 'Login',
          backgroundColor: appTheme.colorFF95A1,
          borderRadius: 21.h,
          buttonTextStyle: TextStyleHelper.instance.title16SemiBold,
          onPressed: () {
            onTapLogin(context);
          },
        ),
        SizedBox(height: 16.h),
        CustomButton(
          height: 42.h,
          width: 156.h,
          text: 'Sign up',
          backgroundColor: appTheme.colorFF95A1,
          borderRadius: 21.h,
          buttonTextStyle: TextStyleHelper.instance.title16SemiBold,
          onPressed: () {
            onTapSignUp(context);
          },
        ),
      ],
    );
  }

  /// Navigates to the login screen when the login button is pressed
  void onTapLogin(BuildContext context) {
    context.read<SplashBloc>().add(OnLoginTapEvent());
  }

  /// Navigates to the sign up screen when the sign up button is pressed
  void onTapSignUp(BuildContext context) {
    context.read<SplashBloc>().add(OnSignUpTapEvent());
  }
}
