import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../theme/text_style_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_field.dart';
import './bloc/driver_authentication_bloc.dart';
import './models/driver_authentication_model.dart';
import 'bloc/driver_authentication_bloc.dart';
import 'models/driver_authentication_model.dart';

class DriverAuthenticationScreen extends StatelessWidget {
  const DriverAuthenticationScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<DriverAuthenticationBloc>(
      create:
          (context) => DriverAuthenticationBloc(
            DriverAuthenticationState(
              driverAuthenticationModel: DriverAuthenticationModel(),
            ),
          )..add(DriverAuthenticationInitialEvent()),
      child: DriverAuthenticationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.colorFFDCE4,
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<DriverAuthenticationBloc, DriverAuthenticationState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  _buildLogoSection(),
                  SizedBox(height: 5.h),
                  _buildLoginForm(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        SizedBox(height: 16.h),
        CustomImageView(
          imagePath:
              ImageConstant.imgScreenshot20250408at22536pmremovebgpreview1,
          height: 197.h,
          width: 152.h,
        ),
        SizedBox(height: 4.h),
        CustomImageView(
          imagePath:
              ImageConstant.imgScreenshot20250408at22908pmremovebgpreview1,
          height: 55.h,
          width: 346.h,
        ),
        SizedBox(height: 5.h),
        Text(
          "Driver's registration",
          style: TextStyleHelper.instance.headline26MonomaniacOne.copyWith(
            height: 1.46,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.only(left: 12.h),
            child: Text(
              "Login",
              style: TextStyleHelper.instance.headline24SemiBoldOutfit,
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Column(
              children: [
                BlocSelector<
                  DriverAuthenticationBloc,
                  DriverAuthenticationState,
                  TextEditingController?
                >(
                  selector: (state) => state.emailController,
                  builder: (context, emailController) {
                    return CustomTextField(
                      width: double.maxFinite,
                      hintText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      controller: emailController,
                      fillColor: appTheme.colorFFF6F6,
                      hintStyle: TextStyleHelper.instance.body14,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 14.h,
                      ),
                      borderDecoration: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.h),
                        borderSide: BorderSide.none,
                      ),
                      onChanged: (value) {
                        context.read<DriverAuthenticationBloc>().add(
                          ChangeEmailEvent(value),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 4.h),
                BlocSelector<
                  DriverAuthenticationBloc,
                  DriverAuthenticationState,
                  TextEditingController?
                >(
                  selector: (state) => state.passwordController,
                  builder: (context, passwordController) {
                    return CustomTextField(
                      width: double.maxFinite,
                      hintText: 'Password',
                      textInputType: TextInputType.visiblePassword,
                      controller: passwordController,
                      obscureText: true,
                      fillColor: appTheme.colorFFF6F6,
                      hintStyle: TextStyleHelper.instance.body14,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 14.h,
                      ),
                      borderDecoration: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.h),
                        borderSide: BorderSide.none,
                      ),
                      onChanged: (value) {
                        context.read<DriverAuthenticationBloc>().add(
                          ChangePasswordEvent(value),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 8.h),
                Text(
                  "Don't have an account? Sign up!",
                  style: TextStyleHelper.instance.headline24SemiBoldOutfit,
                ),
                SizedBox(height: 12.h),
                Column(
                  children: [
                    CustomButton(
                      text: "Login",
                      width: 156.h,
                      height: 43.h,
                      buttonColor: appTheme.colorFF95A1,
                      borderRadius: 21.h,
                      buttonTextStyle:
                          TextStyleHelper.instance.title16SemiBoldPoppins,
                      onTap: () {
                        context.read<DriverAuthenticationBloc>().add(
                          LoginButtonPressedEvent(),
                        );
                      },
                    ),
                    SizedBox(height: 4.h),
                    CustomButton(
                      text: "Sign up",
                      width: 156.h,
                      height: 42.h,
                      buttonColor: appTheme.colorFF95A1,
                      borderRadius: 21.h,
                      buttonTextStyle:
                          TextStyleHelper.instance.title16SemiBoldPoppins,
                      onTap: () {
                        context.read<DriverAuthenticationBloc>().add(
                          SignUpButtonPressedEvent(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
