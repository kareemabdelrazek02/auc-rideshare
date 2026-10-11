part of 'ride_profile_menu_bloc.dart';

class RideProfileMenuState extends Equatable {
  final RideProfileMenuModel? rideProfileMenuModel;
  final List<MenuItemModel>? menuItems;
  final bool? isMenuOpen;
  final int? selectedTabIndex;
  final bool? isTransportSelected;

  const RideProfileMenuState({
    this.rideProfileMenuModel,
    this.menuItems,
    this.isMenuOpen,
    this.selectedTabIndex,
    this.isTransportSelected,
  });

  @override
  List<Object?> get props => [
    rideProfileMenuModel,
    menuItems,
    isMenuOpen,
    selectedTabIndex,
    isTransportSelected,
  ];

  RideProfileMenuState copyWith({
    RideProfileMenuModel? rideProfileMenuModel,
    List<MenuItemModel>? menuItems,
    bool? isMenuOpen,
    int? selectedTabIndex,
    bool? isTransportSelected,
  }) {
    return RideProfileMenuState(
      rideProfileMenuModel: rideProfileMenuModel ?? this.rideProfileMenuModel,
      menuItems: menuItems ?? this.menuItems,
      isMenuOpen: isMenuOpen ?? this.isMenuOpen,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isTransportSelected: isTransportSelected ?? this.isTransportSelected,
    );
  }
}
