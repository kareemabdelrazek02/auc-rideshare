import '../../../core/app_export.dart';
import '../../../core/utils/image_constant.dart';

/// This class is used in the [ride_profile_menu_screen] screen.

// ignore_for_file: must_be_immutable
class RideProfileMenuModel extends Equatable {
  RideProfileMenuModel({this.profileImage, this.userName, this.userEmail}) {
    profileImage = profileImage ?? ImageConstant.imgEllipse43;
    userName = userName ?? "Nate Samson";
    userEmail = userEmail ?? "nate@email.con";
  }

  String? profileImage;
  String? userName;
  String? userEmail;

  RideProfileMenuModel copyWith({
    String? profileImage,
    String? userName,
    String? userEmail,
  }) {
    return RideProfileMenuModel(
      profileImage: profileImage ?? this.profileImage,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  @override
  List<Object?> get props => [profileImage, userName, userEmail];
}
