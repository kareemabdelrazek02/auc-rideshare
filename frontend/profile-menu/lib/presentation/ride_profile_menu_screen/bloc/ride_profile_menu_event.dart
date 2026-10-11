part of 'ride_profile_menu_bloc.dart';

abstract class RideProfileMenuEvent extends Equatable {
  const RideProfileMenuEvent();

  @override
  List<Object?> get props => [];
}

class RideProfileMenuInitialEvent extends RideProfileMenuEvent {}

class ToggleMenuEvent extends RideProfileMenuEvent {}

class SelectTabEvent extends RideProfileMenuEvent {
  final int index;

  const SelectTabEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleTransportDeliveryEvent extends RideProfileMenuEvent {
  final bool isTransport;

  const ToggleTransportDeliveryEvent(this.isTransport);

  @override
  List<Object?> get props => [isTransport];
}
