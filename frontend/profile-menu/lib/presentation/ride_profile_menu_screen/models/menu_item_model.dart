import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';

/// This class is used in the [menu_item_widget] widget.

// ignore_for_file: must_be_immutable
class MenuItemModel extends Equatable {
  MenuItemModel({this.icon, this.title}) {
    icon = icon ?? "";
    title = title ?? "";
  }

  String? icon;
  String? title;

  MenuItemModel copyWith({String? icon, String? title}) {
    return MenuItemModel(icon: icon ?? this.icon, title: title ?? this.title);
  }

  @override
  List<Object?> get props => [icon, title];
}
