import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SickModel {
  final String address;
  final Timestamp bond;
  final String idCard;
  final String name;
  final String phone;
  final String typeSex;
  final String typeStatus;
  final String urlImage;
  final String level;
  SickModel({
    required this.address,
    required this.bond,
    required this.idCard,
    required this.name,
    required this.phone,
    required this.typeSex,
    required this.typeStatus,
    required this.urlImage,
    required this.level,
  });

  SickModel copyWith({
    String? address,
    Timestamp? bond,
    String? idCard,
    String? name,
    String? phone,
    String? typeSex,
    String? typeStatus,
    String? urlImage,
    String? level,
  }) {
    return SickModel(
      address: address ?? this.address,
      bond: bond ?? this.bond,
      idCard: idCard ?? this.idCard,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      typeSex: typeSex ?? this.typeSex,
      typeStatus: typeStatus ?? this.typeStatus,
      urlImage: urlImage ?? this.urlImage,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'bond': bond,
      'idCard': idCard,
      'name': name,
      'phone': phone,
      'typeSex': typeSex,
      'typeStatus': typeStatus,
      'urlImage': urlImage,
      'level': level,
    };
  }

  factory SickModel.fromMap(Map<String, dynamic> map) {
    return SickModel(
      address: map['address'],
      bond: map['bond'],
      idCard: map['idCard'],
      name: map['name'],
      phone: map['phone'],
      typeSex: map['typeSex'],
      typeStatus: map['typeStatus'],
      urlImage: map['urlImage'],
      level: map['level'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SickModel.fromJson(String source) => SickModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SickModel(address: $address, bond: $bond, idCard: $idCard, name: $name, phone: $phone, typeSex: $typeSex, typeStatus: $typeStatus, urlImage: $urlImage, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SickModel &&
      other.address == address &&
      other.bond == bond &&
      other.idCard == idCard &&
      other.name == name &&
      other.phone == phone &&
      other.typeSex == typeSex &&
      other.typeStatus == typeStatus &&
      other.urlImage == urlImage &&
      other.level == level;
  }

  @override
  int get hashCode {
    return address.hashCode ^
      bond.hashCode ^
      idCard.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      typeSex.hashCode ^
      typeStatus.hashCode ^
      urlImage.hashCode ^
      level.hashCode;
  }
}
