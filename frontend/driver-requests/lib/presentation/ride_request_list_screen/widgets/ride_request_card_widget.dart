import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/text_style_helper.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/ride_request_item_model.dart';

class RideRequestCardWidget extends StatelessWidget {
  RideRequestCardWidget({
    Key? key,
    required this.rideRequestModel,
    this.onAccept,
    this.onDecline,
  }) : super(key: key);

  final RideRequestItemModel rideRequestModel;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(24.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 10.h,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildUserInfoSection(),
          SizedBox(height: 16.h),
          _buildNameAndCostSection(),
          Divider(
            height: 24.h,
            thickness: 1.h,
            color: appTheme.blackCustom.withAlpha(51),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            CustomImageView(
              imagePath: rideRequestModel.profileImage,
              height: 68.h,
              width: 68.h,
              radius: BorderRadius.circular(34.h),
            ),
            Positioned(
              top: 9.h,
              left: 2.h,
              child: CustomImageView(
                imagePath: rideRequestModel.onlineStatus,
                height: 12.h,
                width: 11.h,
              ),
            ),
          ],
        ),
        SizedBox(width: 12.h),
        Expanded(child: _buildRideDetailsGrid()),
      ],
    );
  }

  Widget _buildRideDetailsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('rating', rideRequestModel.rating ?? ''),
        SizedBox(height: 4.h),
        _buildDetailRow('pick up', rideRequestModel.pickUp ?? ''),
        SizedBox(height: 4.h),
        _buildDetailRow('drop off', rideRequestModel.dropOff ?? ''),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.h,
          child: Opacity(
            opacity: 0.85,
            child: Text(
              label,
              style: TextStyleHelper.instance.label9Medium.copyWith(
                height: 1.3,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyleHelper.instance.label9.copyWith(height: 1.3),
          ),
        ),
      ],
    );
  }

  Widget _buildNameAndCostSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          rideRequestModel.name ?? '',
          style: TextStyleHelper.instance.title16SemiBold,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Opacity(
              opacity: 0.85,
              child: Text(
                'Trip Cost',
                style: TextStyleHelper.instance.label10Medium,
              ),
            ),
            Text(
              rideRequestModel.tripCost ?? '',
              style: TextStyleHelper.instance.label10,
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            text: 'Accept',
            buttonTextStyle: TextStyleHelper.instance.body13Medium,
            onTap: onAccept,
          ),
          CustomButton(
            text: 'Decline',
            buttonTextStyle: TextStyleHelper.instance.body13Medium.copyWith(
              color: appTheme.colorFFFF30,
            ),
            onTap: onDecline,
          ),
        ],
      ),
    );
  }
}
