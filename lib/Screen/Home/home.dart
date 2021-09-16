import 'package:bedridden/Screen/edit_sick.dart';
import 'package:bedridden/models/sick_model.dart';
import 'package:bedridden/widgets/show_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final primary = Color(0xffdfad98);
  final secondary = Color(0xfff29a94);

  get padding => null;

  List<SickModel> sickModels = [];
  List<SickModel> sickModelsLevel1 = [];
  List<String> docIds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllSick();
  }

  Future<Null> readAllSick() async {
    if (sickModels.length != 0) {
      sickModels.clear();
      sickModelsLevel1.clear();
      docIds.clear();
    }

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('sick')
          .snapshots()
          .listen((event) {
        for (var item in event.docs) {
          SickModel model = SickModel.fromMap(item.data());
          print('## name ==> ${model.name}');
          setState(() {
            sickModels.add(model);
            if (model.level == '1') {
              sickModelsLevel1.add(model);
              docIds.add(item.id);
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    // ignore: unused_local_variable
    final IconThemeData data;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffdfad98),
        toolbarHeight: 90,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(bottom: Radius.elliptical(50.0, 50.0))),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildSearch(), //'ค้นหารายชื่อผู้ป่วยติดเตียง'
                buildtTtleListNameAllBedridden(), //'รายชื่อผู้ป่วยติดเตียง,โชว์ทั้งหมด'
                buildtListNameAllBedridden(), //'รายชื่อผู้ป่วยติดเตียง'
                buildtTtleListNameAllBedriddenLevel1(), //'รายชื่อผู้ป่วยติดเตียง ระดับที่ 1,โชว์ทั้งหมด'
                buildtListNameAllBedriddenLevel1(), //'รายชื่อผู้ป่วยติดเตียง ระดับที่ 1'
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> showSickDialog(SickModel model, int index) async {
    DateTime dateTime = model.bond.toDate();
    DateFormat dateFormat = DateFormat('dd MMM yyyy');
    String bondStr = dateFormat.format(dateTime);

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: EdgeInsets.all(16),
        title: ListTile(
          leading: Image.network(model.urlImage),
          title: Text(model.name),
          subtitle: Text('ระดับที่ = ${model.level}'),
        ),
        children: [
          Text('รหัสบัตร = ${model.idCard}'),
          Text('ที่อยู่ = ${model.address}'),
          Text('Phone = ${model.phone}'),
          Text('Gendle = ${model.typeSex}'),
          Text('สถาณภาพ = ${model.typeStatus}'),
          Text('วันเกิด = $bondStr'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSick(sickModel: model, docId: docIds[index],),
                      )).then((value) => readAllSick());
                },
                child: Text(
                  'Edit',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  confirmDelete(model, index);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

//'รายชื่อผู้ป่วยติดเตียง ระดับที่ 1'
  Widget buildtListNameAllBedriddenLevel1() {
    return sickModelsLevel1.length == 0
        ? ShowProgress()
        : Container(
            height: 200,
            child: Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: sickModelsLevel1.length,
                itemBuilder: (context, index) => Container(
                  width: 150,
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 80,
                          child: Image.network(
                            sickModelsLevel1[index].urlImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              width: 140,
                              child: Text(
                                sickModelsLevel1[index].name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 140,
                              child: Text(sickModelsLevel1[index].address),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 140,
                              child: Text(
                                  'ระดับที่ ${sickModelsLevel1[index].level}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

//'รายชื่อผู้ป่วยติดเตียง ระดับที่ 1,โชว์ทั้งหมด'
  Row buildtTtleListNameAllBedriddenLevel1() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "รายชื่อผู้ป่วย ระดับที่ 1",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(primary: Colors.black87),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => LoginPage()),
              // );
            },
            child: Text(
              "ทั้งหมด",
              style: TextStyle(
                color: Colors.black54,
              ),
            )),
      ],
    );
  }

//'รายชื่อผู้ป่วยติดเตียง'
  Widget buildtListNameAllBedridden() {
    return sickModels.length == 0
        ? ShowProgress()
        : Container(
            height: 220,
            child: Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: sickModels.length,
                itemBuilder: (context, index) => Container(
                  width: 160,
                  child: GestureDetector(
                    onTap: () {
                      print('## You Click index = $index');
                      showSickDialog(sickModels[index], index);
                    },
                    child: Card(
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              width: 100,
                              height: 80,
                              child: Image.network(
                                sickModels[index].urlImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  width: 140,
                                  child: Text(
                                    sickModels[index].name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 140,
                                  child: Text(sickModels[index].address),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                      'ระดับที่ ${sickModels[index].level}'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

//'รายชื่อผู้ป่วยติดเตียง,โชว์ทั้งหมด'
  Row buildtTtleListNameAllBedridden() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "รายชื่อผู้ป่วย",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(primary: Colors.black87),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => LoginPage()),
              // );
            },
            child: Text(
              "ทั้งหมด",
              style: TextStyle(
                color: Colors.black54,
              ),
            )),
      ],
    );
  }

//'ค้นหารายชื่อผู้ป่วยติดเตียง'
  Widget buildSearch() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                // controller: TextEditingController(),
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(color: Colors.black54),
                decoration: InputDecoration(
                    hintText: "Search ",
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                    suffixIcon: Material(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(Icons.search),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<Null> confirmDelete(SickModel model, int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Icon(
            Icons.delete,
            size: 48,
            color: Colors.red,
          ),
          title: Text('ต้องการลบ ${model.name} จริงๆ หรือ ?'),
          subtitle: Text('ถ้าลบแล้ว จะไม่สามารถ กู้ คื่นได้นะคะ'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection('sick')
                  .doc(docIds[index])
                  .delete()
                  .then((value) => readAllSick());
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
