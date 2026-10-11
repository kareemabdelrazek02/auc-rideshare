import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/text_style_helper.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/menu_item_model.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItemModel menuItem;
  final VoidCallback? onTap;

  const MenuItemWidget({Key? key, required this.menuItem, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.h, vertical: 12.h),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: menuItem.icon,
                  height: 16.h,
                  width: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    menuItem.title ?? '',
                    style: TextStyleHelper.instance.body12Medium.copyWith(
                      color: appTheme.colorFF4141,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.h, color: appTheme.colorFFE8E8),
        ],
      ),
    );
  }
}
