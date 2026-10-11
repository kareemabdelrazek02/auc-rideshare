import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../theme/text_style_helper.dart';
import './bloc/ride_request_list_bloc.dart';
import './models/ride_request_list_model.dart';
import './widgets/ride_request_card_widget.dart';
import 'bloc/ride_request_list_bloc.dart';
import 'models/ride_request_list_model.dart';
import 'widgets/ride_request_card_widget.dart';

class RideRequestListScreen extends StatelessWidget {
  const RideRequestListScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<RideRequestListBloc>(
      create:
          (context) => RideRequestListBloc(
            RideRequestListState(
              rideRequestListModelObj: RideRequestListModel(),
            ),
          )..add(RideRequestListInitialEvent()),
      child: RideRequestListScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteCustom,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
          child: BlocConsumer<RideRequestListBloc, RideRequestListState>(
            listener: (context, state) {
              _handleRideRequestActions(context, state);
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  _buildHeader(),
                  SizedBox(height: 16.h),
                  Expanded(child: _buildRideRequestsList(context, state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'ride requests',
      style: TextStyleHelper.instance.headline24SemiBold,
    );
  }

  Widget _buildRideRequestsList(
    BuildContext context,
    RideRequestListState state,
  ) {
    final requests = state.rideRequestListModelObj?.rideRequests;

    if (requests == null || requests.isEmpty) {
      return Center(
        child: Text(
          'No ride requests available',
          style: TextStyleHelper.instance.title16,
        ),
      );
    }

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return RideRequestCardWidget(
          rideRequestModel: request,
          onAccept: () {
            context.read<RideRequestListBloc>().add(
              AcceptRideRequestEvent(request),
            );
          },
          onDecline: () {
            context.read<RideRequestListBloc>().add(
              DeclineRideRequestEvent(request),
            );
          },
        );
      },
    );
  }

  void _handleRideRequestActions(
    BuildContext context,
    RideRequestListState state,
  ) {
    if (state.showAcceptSuccessMessage && state.acceptedRequest != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You accepted ${state.acceptedRequest?.name}\'s ride request',
            style: TextStyleHelper.instance.textStyle4,
          ),
          backgroundColor: appTheme.greenCustom,
          duration: Duration(seconds: 2),
        ),
      );
    }

    if (state.showDeclineSuccessMessage && state.declinedRequest != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You declined ${state.declinedRequest?.name}\'s ride request',
            style: TextStyleHelper.instance.textStyle4,
          ),
          backgroundColor: appTheme.redCustom,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
