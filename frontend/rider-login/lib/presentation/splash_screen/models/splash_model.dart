import '../../../core/app_export.dart';
import '../../../core/utils/image_constant.dart';

/// This class defines the variables used in the [splash_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class SplashModel extends Equatable {
  SplashModel({this.logoPath, this.appNamePath}) {
    logoPath =
        logoPath ??
        ImageConstant.imgScreenshot20250408at22536pmremovebgpreview1;
    appNamePath =
        appNamePath ??
        ImageConstant.imgScreenshot20250408at22908pmremovebgpreview1;
  }

  String? logoPath;
  String? appNamePath;

  SplashModel copyWith({String? logoPath, String? appNamePath}) {
    return SplashModel(
      logoPath: logoPath ?? this.logoPath,
      appNamePath: appNamePath ?? this.appNamePath,
    );
  }

  @override
  List<Object?> get props => [logoPath, appNamePath];
}
