import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_simple_v2/databases/outlet/model/model_outlet.dart';
import 'package:pos_simple_v2/pages/profile/bloc/bloc_profile.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';
import 'package:pos_simple_v2/widgets/atoms/button/button.dart';
import 'package:pos_simple_v2/widgets/atoms/field/field_area.dart';
import 'package:pos_simple_v2/widgets/atoms/field/field_text.dart';

class ModalUpdateOutlet {
  ModalUpdateOutlet._privateConstructor();
  static final ModalUpdateOutlet instance = ModalUpdateOutlet._privateConstructor();

  void show(BuildContext context, {required BlocProfile blocProfile, ModelOutlet? outlet}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ModalUpdateOutletContent(blocProfile: blocProfile, outlet: outlet),
    );
  }
}

class ModalUpdateOutletContent extends StatefulWidget {
  final BlocProfile blocProfile;
  final ModelOutlet? outlet;
  const ModalUpdateOutletContent({super.key, required this.blocProfile, this.outlet});

  @override
  State<ModalUpdateOutletContent> createState() => _ModalUpdateOutletContentState();
}

class _ModalUpdateOutletContentState extends State<ModalUpdateOutletContent> {
  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerId.text = (widget.outlet?.id ?? '').toString();
    controllerName.text = widget.outlet?.name ?? '';
    controllerPhone.text = widget.outlet?.phone ?? '';
    controllerAddress.text = widget.outlet?.address ?? '';
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
                  Text("Ubah Data Toko", style: ThemeApp.font.bold.copyWith(fontSize: 18)),
                  Text(
                    "Isi data pengguna dengan benar",
                    style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text("Nama Toko", style: ThemeApp.font.regular),
                  FieldText(placeHolder: "Masukan nama disini...", controller: controllerName),
                  SizedBox(height: 10),
                  Text("Nomor hp yang dapat dihubungi", style: ThemeApp.font.regular),
                  FieldText(placeHolder: "Masukan nomor hp disini...", controller: controllerPhone),
                  SizedBox(height: 10),
                  Text("Alamat toko", style: ThemeApp.font.regular),
                  FieldArea(placeHolder: "Masukan alamat disini...", controller: controllerAddress),
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
                            widget.blocProfile.saveOutlet(
                              outlet: ModelOutlet(
                                id: controllerId.text == "" ? null : int.parse(controllerId.text),
                                name: controllerName.text,
                                phone: controllerPhone.text,
                                address: controllerAddress.text,
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
