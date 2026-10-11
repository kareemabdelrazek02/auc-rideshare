import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/text_style_helper.dart';
import '../../widgets/custom_image_view.dart';
import './bloc/ride_profile_menu_bloc.dart';
import './models/bottom_tab_item_model.dart';
import './models/ride_profile_menu_model.dart';
import './widgets/bottom_tab_item_widget.dart';
import './widgets/menu_item_widget.dart';
import 'bloc/ride_profile_menu_bloc.dart';
import 'models/bottom_tab_item_model.dart';
import 'models/ride_profile_menu_model.dart';
import 'widgets/bottom_tab_item_widget.dart';
import 'widgets/menu_item_widget.dart';

class RideProfileMenuScreen extends StatelessWidget {
  const RideProfileMenuScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<RideProfileMenuBloc>(
      create:
          (context) => RideProfileMenuBloc(
            RideProfileMenuState(rideProfileMenuModel: RideProfileMenuModel()),
          )..add(RideProfileMenuInitialEvent()),
      child: RideProfileMenuScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideProfileMenuBloc, RideProfileMenuState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: SizedBox(
              height: SizeUtils.height,
              width: SizeUtils.width,
              child: Stack(
                children: [
                  // Map Background
                  CustomImageView(
                    imagePath: ImageConstant.imgGroup,
                    width: SizeUtils.width,
                    height: SizeUtils.height,
                    fit: BoxFit.cover,
                  ),

                  // Map Center Indicator Circles
                  _buildMapCenterIndicator(),

                  // Status Bar
                  _buildStatusBar(),

                  // Menu Button, Notification Button, and Location Target Button
                  _buildFloatingButtons(context, state),

                  // Bottom Section (Search and Transport/Delivery toggle)
                  _buildBottomSection(context, state),

                  // Rental Button
                  Positioned(
                    bottom: 195.h,
                    left: 15.h,
                    child: GestureDetector(
                      onTap: () {
                        // Handle rental button tap
                      },
                      child: Container(
                        width: 172.h,
                        height: 54.h,
                        decoration: BoxDecoration(
                          color: appTheme.colorFF0089,
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Rental',
                          style: TextStyleHelper.instance.title16Medium
                              .copyWith(color: appTheme.whiteCustom),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Navigation Bar
                  _buildBottomNavigationBar(context, state),

                  // Profile Menu Panel (Drawer)
                  if (state.isMenuOpen ?? false)
                    _buildProfileMenuPanel(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomImageView(
              imagePath: ImageConstant.img941,
              width: 28.h,
              height: 11.h,
            ),
            Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgMobileSignal,
                  width: 10.h,
                  height: 17.h,
                ),
                SizedBox(width: 8.h),
                CustomImageView(
                  imagePath: ImageConstant.imgWifi,
                  width: 10.h,
                  height: 15.h,
                ),
                SizedBox(width: 8.h),
                CustomImageView(
                  imagePath: ImageConstant.imgBattery,
                  width: 11.h,
                  height: 24.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButtons(
    BuildContext context,
    RideProfileMenuState state,
  ) {
    return Stack(
      children: [
        // Menu Button
        Positioned(
          top: 60.h,
          left: 15.h,
          child: GestureDetector(
            onTap: () {
              context.read<RideProfileMenuBloc>().add(ToggleMenuEvent());
            },
            child: Container(
              width: 34.h,
              height: 34.h,
              decoration: BoxDecoration(
                color: appTheme.colorFF8AD4,
                borderRadius: BorderRadius.circular(4.h),
              ),
              alignment: Alignment.center,
              child: CustomImageView(
                imagePath: ImageConstant.imgBars,
                height: 14.h,
                width: 10.h,
              ),
            ),
          ),
        ),

        // Notification Button
        Positioned(
          top: 60.h,
          right: 27.h,
          child: Container(
            width: 34.h,
            height: 34.h,
            decoration: BoxDecoration(
              color: appTheme.whiteCustom,
              borderRadius: BorderRadius.circular(4.h),
            ),
            alignment: Alignment.center,
            child: CustomImageView(
              imagePath: ImageConstant.imgNotification,
              height: 24.h,
              width: 24.h,
            ),
          ),
        ),

        // Location Target Button
        Positioned(
          top: 497.h,
          right: 27.h,
          child: Container(
            width: 34.h,
            height: 34.h,
            decoration: BoxDecoration(
              color: appTheme.whiteCustom,
              borderRadius: BorderRadius.circular(4.h),
            ),
            alignment: Alignment.center,
            child: CustomImageView(
              imagePath: ImageConstant.imgLocationTarhget,
              height: 24.h,
              width: 24.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapCenterIndicator() {
    return Positioned(
      top: 207.h,
      left: 96.h,
      child: Container(
        width: 224.h,
        height: 224.h,
        decoration: BoxDecoration(
          color: appTheme.color1908B7,
          borderRadius: BorderRadius.circular(112.h),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 154.h,
          height: 154.h,
          decoration: BoxDecoration(
            color: appTheme.color2608B7,
            borderRadius: BorderRadius.circular(77.h),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 72.h,
            height: 72.h,
            decoration: BoxDecoration(
              color: appTheme.color3F08B7,
              borderRadius: BorderRadius.circular(36.h),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 28.h,
              height: 28.h,
              decoration: BoxDecoration(
                color: appTheme.color7F08B7,
                borderRadius: BorderRadius.circular(14.h),
              ),
              alignment: Alignment.center,
              child: CustomImageView(
                imagePath: ImageConstant.imgMap,
                height: 17.h,
                width: 17.h,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, RideProfileMenuState state) {
    return Positioned(
      bottom: 20.h,
      left: 14.h,
      child: Container(
        width: 364.h,
        height: 141.h,
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          color: appTheme.colorFFB9E5,
          border: Border.all(color: appTheme.colorFF08B7),
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Column(
          children: [
            // Search Bar
            Container(
              height: 54.h,
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              decoration: BoxDecoration(
                color: appTheme.colorFFE2F5,
                border: Border.all(color: appTheme.colorFF8AD4),
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgSearch,
                    height: 24.h,
                    width: 24.h,
                  ),
                  SizedBox(width: 10.h),
                  Text(
                    'Where would you go?',
                    style: TextStyleHelper.instance.title16Medium.copyWith(
                      color: appTheme.colorFFA0A0,
                    ),
                  ),
                  Spacer(),
                  CustomImageView(
                    imagePath: ImageConstant.imgHeart,
                    height: 24.h,
                    width: 24.h,
                  ),
                ],
              ),
            ),

            SizedBox(height: 15.h),

            // Transport/Delivery Toggle
            Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: appTheme.colorFFE2F5,
                border: Border.all(color: appTheme.colorFF8AD4),
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Row(
                children: [
                  // Transport Button
                  GestureDetector(
                    onTap: () {
                      context.read<RideProfileMenuBloc>().add(
                        ToggleTransportDeliveryEvent(true),
                      );
                    },
                    child: Container(
                      width: 168.h, // Half of container width (364-28)/2
                      height: 48.h,
                      decoration: BoxDecoration(
                        color:
                            (state.isTransportSelected ?? true)
                                ? Color(0xFF008955)
                                : appTheme.colorFFE2F5,
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Transport',
                        style: TextStyleHelper.instance.title16Medium.copyWith(
                          color:
                              (state.isTransportSelected ?? true)
                                  ? appTheme.whiteCustom
                                  : appTheme.colorFF4141,
                        ),
                      ),
                    ),
                  ),

                  // Delivery Button
                  GestureDetector(
                    onTap: () {
                      context.read<RideProfileMenuBloc>().add(
                        ToggleTransportDeliveryEvent(false),
                      );
                    },
                    child: Container(
                      width: 168.h, // Half of container width (364-28)/2
                      height: 48.h,
                      decoration: BoxDecoration(
                        color:
                            !(state.isTransportSelected ?? true)
                                ? Color(0xFF008955)
                                : appTheme.colorFFE2F5,
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Delivery',
                        style: TextStyleHelper.instance.title16Medium.copyWith(
                          color:
                              !(state.isTransportSelected ?? true)
                                  ? appTheme.whiteCustom
                                  : appTheme.colorFF4141,
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

  Widget _buildBottomNavigationBar(
    BuildContext context,
    RideProfileMenuState state,
  ) {
    List<BottomTabItemModel> tabs = [
      BottomTabItemModel(
        icon: ImageConstant.imgHouse,
        label: 'Home',
        isSelected: (state.selectedTabIndex == 0),
      ),
      BottomTabItemModel(
        icon: ImageConstant.imgHeart,
        label: 'Favourite',
        isSelected: (state.selectedTabIndex == 1),
      ),
      BottomTabItemModel(
        icon: ImageConstant.imgWallet,
        label: 'Wallet',
        isSelected: (state.selectedTabIndex == 2),
      ),
      BottomTabItemModel(
        icon: ImageConstant.imgDiscount,
        label: 'Offer',
        isSelected: (state.selectedTabIndex == 3),
      ),
      BottomTabItemModel(
        icon: ImageConstant.imgUser,
        label: 'Profile',
        isSelected: (state.selectedTabIndex == 4),
      ),
    ];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 140.h,
        padding: EdgeInsets.only(top: 80.h, bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(tabs.length, (index) {
            // Special case for the wallet tab with floating icon
            if (index == 2) {
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -53.h,
                    child: Container(
                      width: 40.h,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: appTheme.whiteCustom,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomImageView(
                          imagePath: tabs[index].icon,
                          height: 40.h,
                          width: 40.h,
                        ),
                      ),
                    ),
                  ),
                  BottomTabItemWidget(
                    tabItem: tabs[index],
                    hasFloatingIcon: true,
                    onTap: () {
                      context.read<RideProfileMenuBloc>().add(
                        SelectTabEvent(index),
                      );
                    },
                  ),
                ],
              );
            }

            return BottomTabItemWidget(
              tabItem: tabs[index],
              onTap: () {
                context.read<RideProfileMenuBloc>().add(SelectTabEvent(index));
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildProfileMenuPanel(
    BuildContext context,
    RideProfileMenuState state,
  ) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 249.h,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(80.h),
            bottomRight: Radius.circular(80.h),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 10,
              offset: Offset(5, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            GestureDetector(
              onTap: () {
                context.read<RideProfileMenuBloc>().add(ToggleMenuEvent());
              },
              child: Padding(
                padding: EdgeInsets.only(left: 16.h, top: 28.h),
                child: Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgTriangle,
                      height: 7.h,
                      width: 14.h,
                      alignment: Alignment.center,
                    ),
                    SizedBox(width: 16.h),
                    Text('Back', style: TextStyleHelper.instance.title16),
                  ],
                ),
              ),
            ),

            // Profile Section
            Padding(
              padding: EdgeInsets.only(left: 16.h, top: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImageView(
                    imagePath: state.rideProfileMenuModel?.profileImage ?? '',
                    height: 70.h,
                    width: 70.h,
                    radius: BorderRadius.circular(35.h),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.rideProfileMenuModel?.userName ?? '',
                    style: TextStyleHelper.instance.title18Medium,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    state.rideProfileMenuModel?.userEmail ?? '',
                    style: TextStyleHelper.instance.body12Medium.copyWith(
                      color: appTheme.colorFF4141,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Options
            SizedBox(height: 32.h),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: state.menuItems?.length ?? 0,
              itemBuilder: (context, index) {
                return MenuItemWidget(
                  menuItem: state.menuItems![index],
                  onTap: () {
                    // Handle menu item tap
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
