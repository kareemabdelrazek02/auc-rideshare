part of 'ride_request_list_bloc.dart';

class RideRequestListState extends Equatable {
  final RideRequestListModel? rideRequestListModelObj;
  final RideRequestItemModel? acceptedRequest;
  final RideRequestItemModel? declinedRequest;
  final bool showAcceptSuccessMessage;
  final bool showDeclineSuccessMessage;

  const RideRequestListState({
    this.rideRequestListModelObj,
    this.acceptedRequest,
    this.declinedRequest,
    this.showAcceptSuccessMessage = false,
    this.showDeclineSuccessMessage = false,
  });

  @override
  List<Object?> get props => [
    rideRequestListModelObj,
    acceptedRequest,
    declinedRequest,
    showAcceptSuccessMessage,
    showDeclineSuccessMessage,
  ];

  RideRequestListState copyWith({
    RideRequestListModel? rideRequestListModelObj,
    RideRequestItemModel? acceptedRequest,
    RideRequestItemModel? declinedRequest,
    bool? showAcceptSuccessMessage,
    bool? showDeclineSuccessMessage,
  }) {
    return RideRequestListState(
      rideRequestListModelObj:
          rideRequestListModelObj ?? this.rideRequestListModelObj,
      acceptedRequest: acceptedRequest ?? this.acceptedRequest,
      declinedRequest: declinedRequest ?? this.declinedRequest,
      showAcceptSuccessMessage:
          showAcceptSuccessMessage ?? this.showAcceptSuccessMessage,
      showDeclineSuccessMessage:
          showDeclineSuccessMessage ?? this.showDeclineSuccessMessage,
    );
  }
}
