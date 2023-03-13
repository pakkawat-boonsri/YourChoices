import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../filter_options/filter_option_entity.dart';

class DishesEntity extends Equatable {
  final String? dishesId;
  final Timestamp? createdAt;
  final bool? isActive;
  final String? menuName;
  final String? menuImg;
  final num? menuPrice;
  final String? menuDescription;
  final List<FilterOptionEntity>? filterOption; 

  final File? disheImageFile;

  const DishesEntity({
    this.disheImageFile,
    this.isActive,
    this.dishesId,
    this.createdAt,
    this.menuName,
    this.menuImg,
    this.menuPrice,
    this.menuDescription,
    this.filterOption,
  });

  @override
  List<Object?> get props => [
        disheImageFile,
        isActive,
        dishesId,
        createdAt,
        menuName,
        menuImg,
        menuPrice,
        menuDescription,
        filterOption,
      ];
}
