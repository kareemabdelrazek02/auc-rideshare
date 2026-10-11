import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';

/// This class is used in the [bottom_tab_item_widget] widget.

// ignore_for_file: must_be_immutable
class BottomTabItemModel extends Equatable {
  BottomTabItemModel({this.icon, this.label, this.isSelected}) {
    icon = icon ?? "";
    label = label ?? "";
    isSelected = isSelected ?? false;
  }

  String? icon;
  String? label;
  bool? isSelected;

  BottomTabItemModel copyWith({String? icon, String? label, bool? isSelected}) {
    return BottomTabItemModel(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [icon, label, isSelected];
}
