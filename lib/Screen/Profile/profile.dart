import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:bedridden/utility/dialog.dart';
import 'package:bedridden/widgets/show_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController userNameController = TextEditingController();

  bool load = true;
  String? email;
  bool changeDisplayName = true; // ture => ยังไม่มีการเปลียน DisplayName
  String? urlImage;
  File? file;

  @override
  void initState() {
    super.initState();
    findCurrentUser();
  }

  Future<Null> findCurrentUser() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          userNameController.text = event!.displayName!;
          email = event.email;
          urlImage = event.photoURL;
          print('### urlImage = $urlImage');
          load = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xffdfad98),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: load ? ShowProgress() : buildContent(context),
    );
  }

  Widget buildContent(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          painter: HeaderCurvedContainer(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              // padding: EdgeInsets.all(50.0),
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.width / 3,
              child: file != null
                  ? circleFile()
                  : urlImage != null
                      ? circleNetWork()
                      : circleAsset(),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildEditImage(),
            buildUpdateImage(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 400,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                      onChanged: (value) {
                        changeDisplayName = false;
                      },
                      controller: userNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_circle_outlined),
                        hintText: "username",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 45,
                          vertical: 20,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (changeDisplayName) {
                              normalDialog(
                                  context, 'Display ยังไม่มีการเปลี่ยนแปลง ?');
                            } else {
                              processChangeDisplayName();
                            }
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: Icon(Icons.email_outlined),
                    title: Text(email!),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline_outlined),
                    title: Text('Help'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () async {
                      await Firebase.initializeApp().then((value) async {
                        await FirebaseAuth.instance.signOut().then((value) =>
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/LoginPage', (route) => false));
                      });
                    },
                    title: Text("log out"),
                    subtitle: Text("you can logout from here"),
                    leading: Icon(Icons.exit_to_app),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  CircleAvatar circleFile() {
    return CircleAvatar(
      backgroundImage: FileImage(file!),
    );
  }

  CircleAvatar circleNetWork() {
    return CircleAvatar(
      backgroundImage: NetworkImage(urlImage!),
    );
  }

  CircleAvatar circleAsset() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      backgroundImage: AssetImage(
        'assets/images/bedridden.png',
      ),
    );
  }

  DecorationImage showLogo() {
    return DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage("assets/images/bedridden.png"),
    );
  }

  Future<Null> processGetImage(ImageSource source) async {
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

  Future<Null> confirmImageDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Image.asset('assets/images/bedridden.png'),
          title: Text('กรุณาเลือกแหล่งภาพ'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              processGetImage(ImageSource.camera);
            },
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              processGetImage(ImageSource.gallery);
            },
            child: Text('Gallery'),
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

  Padding buildEditImage() {
    return Padding(
      padding: EdgeInsets.only(bottom: 260, left: 110),
      child: CircleAvatar(
        backgroundColor: Colors.black54,
        child: IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () => confirmImageDialog(),
        ),
      ),
    );
  }

  Padding buildUpdateImage() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 260,
        left: 4,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.black54,
        child: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
          onPressed: () {
            if (file == null) {
              normalDialog(context, 'กรุณา ถ่ายภาพ หรือ เลือกภาพจาก Gallery');
            } else {
              processChangeImageProfile();
            }
          },
        ),
      ),
    );
  }

  Future<Null> processChangeImageProfile() async {
    String nameImage = 'profile${Random().nextInt(100000)}.jpg';
    print('## nameImage ==>> $nameImage');
    await Firebase.initializeApp().then((value) async {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child('profile/$nameImage');
      UploadTask task = reference.putFile(file!);
      await task.whenComplete(() async {
        await reference.getDownloadURL().then((value) async {
          print('Upload Success access Token ==> $value');
          String urlProfile = value.toString();
          await FirebaseAuth.instance.authStateChanges().listen((event) async {
            await event!.updatePhotoURL(urlProfile).then((value) =>
                normalDialog(context, 'Update Image Profile Success'));
          });
        });
      });
    });
  }

  Future<Null> processChangeDisplayName() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        await event!
            .updateDisplayName(userNameController.text)
            .then((value) => normalDialog(context, 'Change Display Success'));
      });
    });
  } // end build

}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xffdfad98);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
