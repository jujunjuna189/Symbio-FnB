import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_simple_v2/databases/user/model/model_user.dart';
import 'package:pos_simple_v2/pages/profile/bloc/bloc_profile.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';
import 'package:pos_simple_v2/widgets/atoms/button/button.dart';
import 'package:pos_simple_v2/widgets/atoms/field/field_text.dart';

class ModalUpdateProfile {
  ModalUpdateProfile._privateConstructor();
  static final ModalUpdateProfile instance = ModalUpdateProfile._privateConstructor();

  void show(BuildContext context, {required BlocProfile blocProfile, ModelUser? user}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ModalUpdateProfileContent(blocProfile: blocProfile, user: user),
    );
  }
}

class ModalUpdateProfileContent extends StatefulWidget {
  final BlocProfile blocProfile;
  final ModelUser? user;
  const ModalUpdateProfileContent({super.key, required this.blocProfile, this.user});

  @override
  State<ModalUpdateProfileContent> createState() => _ModalUpdateProfileContentState();
}

class _ModalUpdateProfileContentState extends State<ModalUpdateProfileContent> {
  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerId.text = (widget.user?.id ?? '').toString();
    controllerName.text = widget.user?.name ?? '';
    controllerEmail.text = widget.user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Material(
            color: ThemeApp.color.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 500),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(color: ThemeApp.color.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Ubah Data Pengguna", style: ThemeApp.font.bold.copyWith(fontSize: 18)),
                  Text(
                    "Isi data pengguna dengan benar",
                    style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text("Nama Pengguna", style: ThemeApp.font.regular),
                  FieldText(placeHolder: "Masukan nama disini...", controller: controllerName),
                  SizedBox(height: 10),
                  Text("E-mail Pengguna", style: ThemeApp.font.regular),
                  FieldText(placeHolder: "Masukan e-mail disini...", controller: controllerEmail),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Button(
                        onPress: () => Navigator.of(context).pop(),
                        color: ThemeApp.color.grey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Kembali", textAlign: TextAlign.center, style: ThemeApp.font.semiBold),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Button(
                          onPress: () {
                            Navigator.of(context).pop();
                            widget.blocProfile.saveUser(
                              user: ModelUser(
                                id: controllerId.text == "" ? null : int.parse(controllerId.text),
                                name: controllerName.text,
                                email: controllerEmail.text,
                              ),
                            );
                          },
                          child: Text("Simpan", textAlign: TextAlign.center, style: ThemeApp.font.semiBold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
