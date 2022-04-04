import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/viewmodel/user_view_model.dart';
import 'package:flutter_chat_app/app/widgets/cross_platform_notification.dart';
import 'package:flutter_chat_app/app/widgets/social_login_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _controllerUserName;
  late ImagePicker _picker;
  XFile? _profilePhoto;

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
    _picker = ImagePicker();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    _controllerUserName.text = _userViewModel.user!.userName!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: <Widget>[
          TextButton(
            onPressed: () => signOutAccept(context),
            child: const Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 75,
                    backgroundImage: _profilePhoto == null
                        ? NetworkImage(_userViewModel.user!.profileURL!)
                        : FileImage(File(_profilePhoto!.path)) as ImageProvider,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 170,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.camera),
                                title: const Text("Kameradan Çek"),
                                onTap: () {
                                  _useDeviceCamera();
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.image),
                                title: const Text("Galeriden Seç"),
                                onTap: () {
                                  _useDeviceGallery();
                                },
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  decoration: const InputDecoration(
                    labelText: "Kullanıcı Adı",
                    hintText: "Kullanıcı Adı",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userViewModel.user!.email,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                  buttonText: "Değişiklikleri Kaydet",
                  onPressed: () {
                    _updateUserName(context);
                    _updateProfilePhoto(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> signOut(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    bool value = await _userViewModel.signOut();
    return value;
  }

  Future signOutAccept(BuildContext context) async {
    final result = await const CrossPlatformAlertDialog(
      title: "Emin Misiniz?",
      content: "Çıkmak istediğinizden emin misiniz?",
      mainButtonTitle: "Evet",
      cancelButtonTitle: "Vazgeç",
    ).show(context);

    if (result == true) {
      signOut(context);
    }
  }

  void _updateUserName(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (_userViewModel.user!.userName != _controllerUserName.text) {
      var _updateResult = await _userViewModel.updateUserName(
          _userViewModel.user!.userID, _controllerUserName.text);

      if (_updateResult) {
        const CrossPlatformAlertDialog(
          title: "Bilgi",
          content: "Kullanıcı adı değişikliği başarıyla gerçekleşti",
          mainButtonTitle: "Tamam",
        ).show(context);
      } else {
        _controllerUserName.text = _userViewModel.user!.userName!;
        const CrossPlatformAlertDialog(
          title: "Hata",
          content:
              "Kullanıcı adı kullanımda, lütfen farklı bir kullanıcı adı deneyiniz",
          mainButtonTitle: "Tamam",
        ).show(context);
      }
    }
  }

  Future<void> _useDeviceGallery() async {
    var newImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePhoto = newImage;
      Navigator.of(context).pop();
    });
  }

  Future<void> _useDeviceCamera() async {
    var newImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _profilePhoto = newImage;
      Navigator.of(context).pop();
    });
  }

  Future<void> _updateProfilePhoto(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    File fileProfilePhoto = File(_profilePhoto!.path);
    if (_profilePhoto != null) {
      await _userViewModel.uploadFile(
          _userViewModel.user!.userID, "profile_photo", fileProfilePhoto);
    }
  }
}
