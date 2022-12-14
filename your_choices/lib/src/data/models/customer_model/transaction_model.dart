import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/customer/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    final Timestamp? date,
    final String? menuName,
    final num? totalPrice,
    final String? resName,
    final String? type,
    final String? name,
    final num? deposit,
    final num? withdraw,
  }) : super(
          date: date,
          deposit: deposit,
          menuName: menuName,
          name: name,
          resName: resName,
          totalPrice: totalPrice,
          type: type,
          withdraw: withdraw,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      type: json['type'],
      withdraw: json['withdraw'],
      totalPrice: json['totalPrice'],
      resName: json['resName'],
      name: json['name'],
      menuName: json['menuName'],
      deposit: json['deposit'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['menuName'] = menuName;
    data['totalPrice'] = totalPrice;
    data['resName'] = resName;
    data['type'] = type;
    data['name'] = name;
    data['deposit'] = deposit;
    data['withdraw'] = withdraw;
    return data;
  }
}
