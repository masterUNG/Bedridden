import 'package:bedridden/models/sick_model.dart';
import 'package:bedridden/utility/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditSick extends StatefulWidget {
  final SickModel sickModel;
  final String docId;
  const EditSick({Key? key, required this.sickModel, required this.docId})
      : super(key: key);

  @override
  _EditSickState createState() => _EditSickState();
}

class _EditSickState extends State<EditSick> {
  SickModel? sickModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController idcartController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? typeSex;
  String? _typestatus;
  DateTime? bondDateTime;
  String? bondDateTimeStr;

  Map<String, dynamic> map = {};
  String? docId;

  bool typeSexBol = false;
  bool typeStatusBol = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sickModel = widget.sickModel;
    nameController.text = sickModel!.name;
    idcartController.text = sickModel!.idCard;
    addressController.text = sickModel!.address;
    phoneController.text = sickModel!.phone;
    typeSex = sickModel!.typeSex;
    _typestatus = sickModel!.typeStatus;
    bondDateTime = sickModel!.bond.toDate();

    DateFormat dateFormat = DateFormat('dd MMM yyyy');
    bondDateTimeStr = dateFormat.format(bondDateTime!);

    docId = widget.docId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Sick'),
        actions: [
          IconButton(onPressed: () => processEditData(), icon: Icon(Icons.edit))
        ],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 16),
          width: 250,
          child: SingleChildScrollView(
            child: Column(
              children: [
                fieldName(),
                buildSizeBox(),
                fieldIdCard(),
                buildSizeBox(),
                fieldAddress(),
                buildSizeBox(),
                fieldPhone(),
                buildSizeBox(),
                buildBond(),
                buildImage(),
                buildSizeBox(),
                controllerImage(),
                titleGendle(),
                radioGendle(),
                titleStatus(),
                groupStatus(),
                buildSizeBox(),
                buttonEdit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildBond() {
    return ListTile(
      leading: Text(bondDateTimeStr!),
      trailing: IconButton(onPressed: () {}, icon: Icon(Icons.calendar_today)),
    );
  }

  Future<Null> processEditData() async {
    if (typeSexBol) {
      map['typeSex'] = typeSex;
    }

    if (typeStatusBol) {
      map['typeStatus'] = _typestatus;
    }

    print('### map ==>> $map');
    if (map.isEmpty) {
      normalDialog(context, 'ไม่มีการเปลี่ยนแปลงอะไร ? ไม่สามารถ Edit ได้');
    } else {
      await Firebase.initializeApp().then((value) async {
        await FirebaseFirestore.instance
            .collection('sick')
            .doc(docId)
            .update(map)
            .then((value) => Navigator.pop(context));
      });
    }
  }

  Container buttonEdit() {
    return Container(
      width: 250,
      child: ElevatedButton(
        onPressed: () => processEditData(),
        child: Text('Edit Data'),
      ),
    );
  }

  Column groupStatus() {
    return Column(
      children: [
        RadioListTile(
          title: const Text('โสด'),
          value: 'single',
          groupValue: _typestatus,
          onChanged: (value) {
            setState(
              () {
                _typestatus = value as String?;
                typeStatusBol = true;
              },
            );
          },
        ),
        RadioListTile(
          title: const Text('สมรส'),
          value: 'marital',
          groupValue: _typestatus,
          onChanged: (value) {
            setState(
              () {
                _typestatus = value as String?;
                typeStatusBol = true;
              },
            );
          },
        ),
        RadioListTile(
          title: const Text('หม้าย'),
          value: 'widow',
          groupValue: _typestatus,
          onChanged: (value) {
            setState(
              () {
                _typestatus = value as String?;
                typeStatusBol = true;
              },
            );
          },
        ),
        RadioListTile(
          title: const Text('อย่าร้าง'),
          value: 'divorce',
          groupValue: _typestatus,
          onChanged: (value) {
            setState(
              () {
                _typestatus = value as String?;
                typeStatusBol = true;
              },
            );
          },
        ),
      ],
    );
  }

  Row titleStatus() {
    return Row(
      children: [
        Text('สถาณภาพ :'),
      ],
    );
  }

  Row radioGendle() {
    return Row(
      children: [
        Container(
          width: 120,
          child: RadioListTile(
            title: Text('ชาย'),
            value: 'man',
            groupValue: typeSex,
            onChanged: (value) {
              setState(() {
                typeSex = value as String?;
                typeSexBol = true;
              });
            },
          ),
        ),
        Container(
          width: 120,
          child: RadioListTile(
            title: Text('หญิง'),
            value: 'female',
            groupValue: typeSex,
            onChanged: (value) {
              setState(() {
                typeSex = value as String?;
                typeSexBol = true;
              });
            },
          ),
        ),
      ],
    );
  }

  Row titleGendle() {
    return Row(
      children: [
        Text('Gendle :'),
      ],
    );
  }

  Row controllerImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.add_a_photo)),
        IconButton(onPressed: () {}, icon: Icon(Icons.add_photo_alternate)),
      ],
    );
  }

  Container buildImage() {
    return Container(
      width: 200,
      child: Image.network(sickModel!.urlImage),
    );
  }

  SizedBox buildSizeBox() {
    return SizedBox(
      height: 16,
    );
  }

  TextFormField fieldName() {
    return TextFormField(
      onChanged: (value) {
        map['name'] = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Name Not Empty';
        } else {
          return null;
        }
      },
      controller: nameController,
      decoration: InputDecoration(border: OutlineInputBorder()),
    );
  }

  TextFormField fieldIdCard() {
    return TextFormField(
      onChanged: (value) {
        map['idCard'] = value;
      },
      maxLength: 13,
      validator: (value) {
        if (value!.isEmpty) {
          return 'IdCard Not Empty';
        } else {
          return null;
        }
      },
      controller: idcartController,
      decoration: InputDecoration(border: OutlineInputBorder()),
    );
  }

  TextFormField fieldAddress() {
    return TextFormField(
      onChanged: (value) {
        map['address'] = value;
      },
      maxLines: 3,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Address Not Empty';
        } else {
          return null;
        }
      },
      controller: addressController,
      decoration: InputDecoration(border: OutlineInputBorder()),
    );
  }

  TextFormField fieldPhone() {
    return TextFormField(
      onChanged: (value) {
        map['phone'] = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Phone Not Empty';
        } else {
          return null;
        }
      },
      controller: phoneController,
      decoration: InputDecoration(border: OutlineInputBorder()),
    );
  }
}
