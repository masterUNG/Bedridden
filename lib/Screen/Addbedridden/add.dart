import 'dart:io';
import 'dart:math';
import 'package:bedridden/models/sick_model.dart';
import 'package:bedridden/utility/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class Add extends StatefulWidget {
  const Add({
    Key? key,
  }) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

String? _typesex;
String? _typestatus;

class _AddState extends State<Add> {
  late DateTime pickedDate;
  bool bondStatus = true; // true => ยังไม่ได้เลือกวันเกิด

  File? file;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController idCardController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? level;
  List<String> levels = ['1', '2', '3'];

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final IconThemeData data;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffdfad98),
        toolbarHeight: 90,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(50.0, 50.0),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              buildSaveBedridden(), //'บันทึก'
              buildBedriddenTitle(), //'ข้อมูลผู้ป่วย'
              buildImageBedridden(context), //'รูปภาพ'
              buildNameNumBersexBedridden(), //'ชื่อ-นามสุกม,เลขบัตรประจำตัวประชาชน,เพศ'
              buildAddressPhonenumberBedridden(), //'ที่อยู่เ,บอร์โทร์'
              buildDatePickerBedridden(), //'วัน/เดือน/ปีเกิด'
              buildTitleStatus(),
              groupStatus(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTitleLevel(),
                  DropdownButton<String>(
                    onChanged: (value) {
                      setState(() {
                        level = value as String;
                      });
                    },
                    value: level,
                    hint: Text('level'),
                    items: levels
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              },
            );
          },
        ),
      ],
    );
  }

  Container buildTitleStatus() {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            'สถานภาพสมรส',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Container buildTitleLevel() {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            'ระดับการป่วย',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Column buildDatePickerBedridden() {
    return Column(
      children: [
        ListTile(
          title: bondStatus
              ? Text("วัน/เดือน/ปีเกิด : ? , ? , ?")
              : Text(
                  "วัน/เดือน/ปีเกิด : ${pickedDate.day} , ${pickedDate.month} , ${pickedDate.year}"),
          trailing: Icon(Icons.keyboard_arrow_down),
          onTap: _pickDate,
        ),
      ],
    );
  }

  Column buildAddressPhonenumberBedridden() {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณา ที่อยู่ ด้วยคะ';
            } else {
              return null;
            }
          },
          controller: addressController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            hintText: 'ที่อยู่ปัจจุบัน',
            labelText: 'ที่อยู่ปัจจุบัน *',
            fillColor: const Color(0xfff7e4db),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณา Phone ด้วยคะ';
            } else {
              return null;
            }
          },
          controller: phoneController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            hintText: 'เบอร์โทรศัพท์',
            labelText: 'เบอร์โทรศัพท์ *',
            fillColor: const Color(0xfff7e4db),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Column buildNameNumBersexBedridden() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 16.0),
        // "ชื่อ-นามสุกล" form.
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณา กรอก ชื่อ-นามสกุล ด้วยคะ';
            } else {
              return null;
            }
          },
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            hintText: 'ชื่อ-นามสุกล',
            labelText: 'ชื่อ-นามสุกล *',
            fillColor: const Color(0xfff7e4db),
          ),
        ),
        const SizedBox(height: 16.0),
        // "เลขบัตรประจำตัวชาชน" form.
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณา idCard ด้วยคะ';
            } else {
              if (value.length != 13) {
                return 'idCard ต้องมี 13 หลัก คะ';
              } else {
                return null;
              }
            }
          },
          controller: idCardController,
          maxLength: 13,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            hintText: 'เลขบัตรประจำตัวชาชน',
            labelText: 'เลขบัตรประจำตัวชาชน *',
            fillColor: const Color(0xfff7e4db),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16.0),
        Container(
          child: Row(
            children: <Widget>[
              Text('เพศ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ))
            ],
          ),
        ),

        //"เพศ"

        RadioListTile(
          title: const Text('ชาย'),
          value: 'man',
          groupValue: _typesex,
          onChanged: (value) {
            setState(
              () {
                _typesex = value as String?;
              },
            );
          },
        ),
        RadioListTile(
          title: const Text('หญิง'),
          value: 'female',
          groupValue: _typesex,
          onChanged: (value) {
            setState(
              () {
                _typesex = value as String?;
              },
            );
          },
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Widget buildImageBedridden(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => chooseImage(ImageSource.camera),
            icon: Icon(Icons.add_a_photo)),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width / 2,
          child: file == null ? circleAsset() : circleFile(),
        ),
        IconButton(
            onPressed: () => chooseImage(ImageSource.gallery),
            icon: Icon(Icons.add_photo_alternate)),
      ],
    );
  }

  CircleAvatar circleAsset() {
    return CircleAvatar(
      backgroundImage: AssetImage('assets/images/image_icon.png'),
    );
  }

  CircleAvatar circleFile() {
    return CircleAvatar(
      backgroundImage: FileImage(file!),
    );
  }

  Widget buildBedriddenTitle() {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            'ข้อมูลข้องผู้ป่วย',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.photo_camera),
          //   onPressed: () async => _pickImageFromCamera(),
          //   tooltip: 'Shoot picture',
          // ),
          // IconButton(
          //   icon: const Icon(Icons.photo),
          //   onPressed: () async => _pickImageFromGallery(),
          //   tooltip: 'Pick from gallery',
          // ),
        ],
      ),
    );
  }

  Future<Null> processUploadImageAndInsertValue() async {
    String nameImage = 'sick${Random().nextInt(1000000)}.jpg';

    await Firebase.initializeApp().then((value) async {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child('sick/$nameImage');
      UploadTask task = reference.putFile(file!);
      await task.whenComplete(() async {
        await reference.getDownloadURL().then((value) async {
          String urlImage = value.toString();
          print('## urlImage ==> $urlImage');

          Timestamp timestamp = Timestamp.fromDate(pickedDate);

          SickModel model = SickModel(
              address: addressController.text,
              bond: timestamp,
              idCard: idCardController.text,
              name: nameController.text,
              phone: phoneController.text,
              typeSex: _typesex!,
              typeStatus: _typestatus!,
              urlImage: urlImage,
              level: level!);

          await FirebaseFirestore.instance
              .collection('sick')
              .doc()
              .set(model.toMap())
              .then((value) => normalDialog(
                  context, 'Insert Sick Data to Database Success'));
        });
      });
    });
  }

  MaterialButton buildSaveBedridden() {
    return MaterialButton(
      padding: EdgeInsets.all(8),
      minWidth: 0.50,
      height: 30,
      onPressed: () {
        if (file == null) {
          normalDialog(context, 'กรุณา ถ่ายรุปด้วย คะ');
        } else if (_typesex == null) {
          normalDialog(context, 'กรุณา เลือกเพศด้วย คะ');
        } else if (_typestatus == null) {
          normalDialog(context, 'กรุณา สถาณะด้วย คะ');
        } else if (bondStatus) {
          normalDialog(context, 'กรุณา เลือกวันเกิดด้วย คะ');
        } else if (level == null) {
          normalDialog(context, 'กรุณา เลือก ระดับการป่วยด้วย คะ');
        } else if (formKey.currentState!.validate()) {
          processUploadImageAndInsertValue();
        }
      },
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: const Color(0xffffede5),
          ),
          borderRadius: BorderRadius.circular(50)),
      child: Text(
        "บันทึก",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      color: const Color(0xffdfad98),
    );
  }

  _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime(DateTime.now().year + 1));
    if (date != null)
      setState(
        () {
          pickedDate = date;
          bondStatus = false;
        },
      );
  }
}
