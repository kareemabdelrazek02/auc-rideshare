import 'package:equatable/equatable.dart';

import '../../../core/app_export.dart';
import './ride_request_item_model.dart';
import 'ride_request_item_model.dart';

/// This class is used in the [ride_request_list_screen] screen.

// ignore_for_file: must_be_immutable
class RideRequestListModel extends Equatable {
  RideRequestListModel({this.rideRequests}) {
    rideRequests =
        rideRequests ??
        [
          RideRequestItemModel(
            rating: '4.5/5',
            pickUp: 'Banafseg 1',
            dropOff: 'AUC gate 5',
            name: 'Ahmed',
            tripCost: '70 EGP',
          ),
          RideRequestItemModel(
            rating: '4.9/5',
            pickUp: 'AUC gate 4',
            dropOff: 'nasr city',
            name: 'Yehia Ali',
            tripCost: '100 EGP',
          ),
          RideRequestItemModel(
            rating: '4.5/5',
            pickUp: 'AUC off campus residence',
            dropOff: 'Concord Plaza',
            name: 'Mohamed',
            tripCost: '40 EGP',
          ),
          RideRequestItemModel(
            rating: '4.5/5',
            pickUp: 'Water way 1',
            dropOff: 'AUC gate 2',
            name: 'Marwan',
            tripCost: '90 EGP',
          ),
        ];
  }

  List<RideRequestItemModel>? rideRequests;

  RideRequestListModel copyWith({List<RideRequestItemModel>? rideRequests}) {
    return RideRequestListModel(
      rideRequests: rideRequests ?? this.rideRequests,
    );
  }

  @override
  List<Object?> get props => [rideRequests];
}
