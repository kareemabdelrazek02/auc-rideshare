import '../../../core/app_export.dart';
import '../../../core/utils/image_constant.dart';
import '../models/menu_item_model.dart';
import '../models/ride_profile_menu_model.dart';

part 'ride_profile_menu_event.dart';
part 'ride_profile_menu_state.dart';

class RideProfileMenuBloc
    extends Bloc<RideProfileMenuEvent, RideProfileMenuState> {
  RideProfileMenuBloc(RideProfileMenuState initialState) : super(initialState) {
    on<RideProfileMenuInitialEvent>(_onInitialize);
    on<ToggleMenuEvent>(_onToggleMenu);
    on<SelectTabEvent>(_onSelectTab);
    on<ToggleTransportDeliveryEvent>(_onToggleTransportDelivery);
  }

  _onInitialize(
    RideProfileMenuInitialEvent event,
    Emitter<RideProfileMenuState> emit,
  ) {
    List<MenuItemModel> menuItems = [
      MenuItemModel(icon: ImageConstant.imgHistory, title: 'History'),
      MenuItemModel(icon: ImageConstant.imgComplain, title: 'Complain'),
      MenuItemModel(icon: ImageConstant.imgAboutUs, title: 'About Us'),
      MenuItemModel(icon: ImageConstant.imgSettings, title: 'Settings'),
      MenuItemModel(
        icon: ImageConstant.imgHelpAndSupport,
        title: 'Help and Support',
      ),
      MenuItemModel(icon: ImageConstant.imgLogout, title: 'Logout'),
    ];

    emit(
      state.copyWith(
        menuItems: menuItems,
        isMenuOpen: false,
        selectedTabIndex: 0,
        isTransportSelected: true,
      ),
    );
  }

  _onToggleMenu(ToggleMenuEvent event, Emitter<RideProfileMenuState> emit) {
    emit(state.copyWith(isMenuOpen: !(state.isMenuOpen ?? false)));
  }

  _onSelectTab(SelectTabEvent event, Emitter<RideProfileMenuState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  _onToggleTransportDelivery(
    ToggleTransportDeliveryEvent event,
    Emitter<RideProfileMenuState> emit,
  ) {
    emit(state.copyWith(isTransportSelected: event.isTransport));
  }
}
