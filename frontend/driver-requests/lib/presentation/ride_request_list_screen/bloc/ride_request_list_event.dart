part of 'ride_request_list_bloc.dart';

abstract class RideRequestListEvent extends Equatable {
  const RideRequestListEvent();

  @override
  List<Object?> get props => [];
}

class RideRequestListInitialEvent extends RideRequestListEvent {}

class AcceptRideRequestEvent extends RideRequestListEvent {
  final RideRequestItemModel request;

  const AcceptRideRequestEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class DeclineRideRequestEvent extends RideRequestListEvent {
  final RideRequestItemModel request;

  const DeclineRideRequestEvent(this.request);

  @override
  List<Object?> get props => [request];
}
