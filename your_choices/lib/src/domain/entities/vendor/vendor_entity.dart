// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';

import 'dishes_menu/dishes_entity.dart';

class VendorEntity extends Equatable {
  final String? uid;
  final String? email;
  final String? username;
  final String? profileUrl;
  final String? type;
  final String? resName;
  final String? resProfileUrl;
  final bool? isActive;
  final num? onQueue;
  final String? description;
  final num? totalPriceSell;
  final List<DishesEntity>? dishes;

  //Not collect in db
  final File? imageFile;
  final File? resImageFile;
  final String? password;
  final String? otherUid;

  const VendorEntity({
    this.type,
    this.uid,
    this.resName,
    this.resProfileUrl,
    this.isActive,
    this.onQueue,
    this.description,
    this.totalPriceSell,
    this.dishes,
    this.email,
    this.username,
    this.profileUrl,
    this.imageFile,
    this.resImageFile,
    this.password,
    this.otherUid,
  });

  @override
  List<Object?> get props => [
        uid,
        type,
        resName,
        resProfileUrl,
        isActive,
        onQueue,
        description,
        totalPriceSell,
        dishes,
        email,
        username,
        profileUrl,
        imageFile,
        resImageFile,
        password,
        otherUid,
      ];

  VendorEntity copyWith({
    String? uid,
    String? email,
    String? username,
    String? profileUrl,
    String? type,
    String? resName,
    String? resProfileUrl,
    bool? isActive,
    num? onQueue,
    String? description,
    num? totalPriceSell,
    List<DishesEntity>? dishes,
    File? imageFile,
    File? resImageFile,
    String? password,
    String? otherUid,
  }) {
    return VendorEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      profileUrl: profileUrl ?? this.profileUrl,
      type: type ?? this.type,
      resName: resName ?? this.resName,
      resProfileUrl: resProfileUrl ?? this.resProfileUrl,
      isActive: isActive ?? this.isActive,
      onQueue: onQueue ?? this.onQueue,
      description: description ?? this.description,
      totalPriceSell: totalPriceSell ?? this.totalPriceSell,
      dishes: dishes ?? this.dishes,
      imageFile: imageFile ?? this.imageFile,
      resImageFile: resImageFile ?? this.resImageFile,
      password: password ?? this.password,
      otherUid: otherUid ?? this.otherUid,
    );
  }
}
