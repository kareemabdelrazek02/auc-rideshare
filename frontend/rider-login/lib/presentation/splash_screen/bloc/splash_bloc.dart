import '../../../core/app_export.dart';
import '../../../core/utils/navigator_service.dart';
import '../../../routes/app_routes.dart';
import '../models/splash_model.dart';

part 'splash_event.dart';
part 'splash_state.dart';

/// A bloc that manages the state of a Splash according to the event that is dispatched to it.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(SplashState initialState) : super(initialState) {
    on<SplashInitialEvent>(_onInitialize);
    on<OnLoginTapEvent>(_onLoginTap);
    on<OnSignUpTapEvent>(_onSignUpTap);
  }

  _onInitialize(SplashInitialEvent event, Emitter<SplashState> emit) async {
    emit(state.copyWith(splashModel: SplashModel()));
  }

  _onLoginTap(OnLoginTapEvent event, Emitter<SplashState> emit) {
    // Navigate to Login Screen
    // This is a placeholder since the login screen route is not provided in the AppRoutes
    // Would implement with: NavigatorService.pushNamed(AppRoutes.loginScreen);
  }

  _onSignUpTap(OnSignUpTapEvent event, Emitter<SplashState> emit) {
    // Navigate to Sign Up Screen
    // This is a placeholder since the signup screen route is not provided in the AppRoutes
    // Would implement with: NavigatorService.pushNamed(AppRoutes.signupScreen);
  }
}
