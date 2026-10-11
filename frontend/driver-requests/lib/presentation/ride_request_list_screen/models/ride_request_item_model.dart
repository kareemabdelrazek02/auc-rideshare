import '../../../core/app_export.dart';
import '../../../core/utils/image_constant.dart';

/// This class is used in the [ride_request_list_screen] screen.

// ignore_for_file: must_be_immutable
class RideRequestItemModel extends Equatable {
  RideRequestItemModel({
    this.profileImage,
    this.onlineStatus,
    this.rating,
    this.pickUp,
    this.dropOff,
    this.name,
    this.tripCost,
    this.isSelected,
  }) {
    profileImage = profileImage ?? ImageConstant.imgEllipse213;
    onlineStatus = onlineStatus ?? ImageConstant.imgVector12x11;
    rating = rating ?? "";
    pickUp = pickUp ?? "";
    dropOff = dropOff ?? "";
    name = name ?? "";
    tripCost = tripCost ?? "";
    isSelected = isSelected ?? false;
  }

  String? profileImage;
  String? onlineStatus;
  String? rating;
  String? pickUp;
  String? dropOff;
  String? name;
  String? tripCost;
  bool? isSelected;

  RideRequestItemModel copyWith({
    String? profileImage,
    String? onlineStatus,
    String? rating,
    String? pickUp,
    String? dropOff,
    String? name,
    String? tripCost,
    bool? isSelected,
  }) {
    return RideRequestItemModel(
      profileImage: profileImage ?? this.profileImage,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      rating: rating ?? this.rating,
      pickUp: pickUp ?? this.pickUp,
      dropOff: dropOff ?? this.dropOff,
      name: name ?? this.name,
      tripCost: tripCost ?? this.tripCost,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [
    profileImage,
    onlineStatus,
    rating,
    pickUp,
    dropOff,
    name,
    tripCost,
    isSelected,
  ];
}
