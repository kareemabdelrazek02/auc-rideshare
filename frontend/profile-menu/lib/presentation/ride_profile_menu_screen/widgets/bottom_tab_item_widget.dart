import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/text_style_helper.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/bottom_tab_item_model.dart';

class BottomTabItemWidget extends StatelessWidget {
  final BottomTabItemModel tabItem;
  final VoidCallback? onTap;
  final bool hasFloatingIcon;

  const BottomTabItemWidget({
    Key? key,
    required this.tabItem,
    this.onTap,
    this.hasFloatingIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasFloatingIcon) SizedBox(height: 40.h),
          CustomImageView(
            imagePath: tabItem.icon,
            height:
                hasFloatingIcon
                    ? 0.h
                    : 24.h, // Hide the regular icon if using floating
            width: hasFloatingIcon ? 0.h : 24.h,
          ),
          SizedBox(height: hasFloatingIcon ? 8.h : 2.h),
          Text(
            tabItem.label ?? '',
            style: TextStyleHelper.instance.body12Medium.copyWith(
              color:
                  (tabItem.isSelected ?? false)
                      ? Color(0xFF08B783)
                      : appTheme.colorFF4141,
            ),
          ),
        ],
      ),
    );
  }
}
