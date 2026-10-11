import '../models/ride_request_list_model.dart';
import '../models/ride_request_item_model.dart';
import '../../../core/app_export.dart';

part 'ride_request_list_event.dart';
part 'ride_request_list_state.dart';

class RideRequestListBloc
    extends Bloc<RideRequestListEvent, RideRequestListState> {
  RideRequestListBloc(RideRequestListState initialState) : super(initialState) {
    on<RideRequestListInitialEvent>(_onInitialize);
    on<AcceptRideRequestEvent>(_onAcceptRideRequest);
    on<DeclineRideRequestEvent>(_onDeclineRideRequest);
  }

  _onInitialize(
    RideRequestListInitialEvent event,
    Emitter<RideRequestListState> emit,
  ) {
    emit(state.copyWith(rideRequestListModelObj: RideRequestListModel()));
  }

  _onAcceptRideRequest(
    AcceptRideRequestEvent event,
    Emitter<RideRequestListState> emit,
  ) {
    final updatedRequests =
        state.rideRequestListModelObj?.rideRequests?.map((request) {
          if (request == event.request) {
            // Here you would typically handle the acceptance logic
            // For now, we'll just mark it as selected
            return request.copyWith(isSelected: true);
          }
          return request;
        }).toList();

    final updatedModel = state.rideRequestListModelObj?.copyWith(
      rideRequests: updatedRequests,
    );

    emit(
      state.copyWith(
        rideRequestListModelObj: updatedModel,
        acceptedRequest: event.request,
        showAcceptSuccessMessage: true,
      ),
    );
  }

  _onDeclineRideRequest(
    DeclineRideRequestEvent event,
    Emitter<RideRequestListState> emit,
  ) {
    // Remove the declined request from the list
    final updatedRequests =
        state.rideRequestListModelObj?.rideRequests
            ?.where((request) => request != event.request)
            .toList();

    final updatedModel = state.rideRequestListModelObj?.copyWith(
      rideRequests: updatedRequests,
    );

    emit(
      state.copyWith(
        rideRequestListModelObj: updatedModel,
        declinedRequest: event.request,
        showDeclineSuccessMessage: true,
      ),
    );
  }
}
