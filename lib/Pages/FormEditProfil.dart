import 'package:fisikamu/Widgets/InputText.dart';
import 'package:fisikamu/Widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';

import '../APIAction.dart';

class FormEditProfil extends StatefulWidget {
  const FormEditProfil({Key? key}) : super(key: key);

  @override
  _FormEditProfilState createState() => _FormEditProfilState();
}

class _FormEditProfilState extends State<FormEditProfil> {
  final formKey = GlobalKey<FormState>();
  Map args = {};
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController noHpTextEditingController = new TextEditingController();
  TextEditingController alamatTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments = (ModalRoute.of(context)!.settings.arguments as Map);
      
        if (mounted){setState(() {
          args = arguments;
        });
      }
      loadDataSebelumnya(arguments);
    });
  }

  loadDataSebelumnya(Map data) {
    // print(data);
    
      if (mounted){setState(() {
        userNameTextEditingController.text = data['username'];
        noHpTextEditingController.text = data['no_hp'];
        alamatTextEditingController.text = data['alamat'];
      });
    }
  }

  saveProfil() {
    Map<String, String> dataUsers = {
      "id": args['id_user'],
      "username": userNameTextEditingController.text,
      "email": args['email'],
      "password": args['password'],
    };

    Map<String, String> dataUsersDetails = {
      "id": args['id_user'],
      "harga": "",
      "rating": "",
      "status_online": "",
      "photo": args['photo'],
      "pendidikan": "",
      "alamat": alamatTextEditingController.text,
      "no_hp": noHpTextEditingController.text,
      "koordinat_alamat": "",
    };
    putAPI("/users_api", dataUsers);
    putAPI("/users_details", dataUsersDetails);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: formKey,
      child: ListView(
        children: [
          InputText("Nama", false, 45, 1, userNameTextEditingController, (val) {
            return val.isEmpty || val.length < 2
                ? "Nama tidak boleh kosong"
                : null;
          }, 8),
          InputText("No Hp", false, 45, 1, noHpTextEditingController, (val) {
            return val.isEmpty || val.length < 2
                ? "No Hp tidak boleh kosong"
                : null;
          }, 8),
          InputText("Alamat", false, 45, 1, alamatTextEditingController, (val) {
            return val.isEmpty || val.length < 2
                ? "Alamat tidak boleh kosong"
                : null;
          }, 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: PrimaryButton("Submit", Color(0xFF1A91DA), Container(), () {
              saveProfil();
            }, context),
          ),
        ],
      ),
    ));
  }
}
