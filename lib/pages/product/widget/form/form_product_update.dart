import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pos_simple_v2/databases/product/model/model_product.dart';
import 'package:pos_simple_v2/databases/product/repository/repository_product.dart';
import 'package:pos_simple_v2/helpers/formatter/price_formatter.dart';
import 'package:pos_simple_v2/pages/product/bloc/bloc_product.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';
import 'package:pos_simple_v2/widgets/atoms/button/button.dart';
import 'package:pos_simple_v2/widgets/atoms/field/field_number.dart';
import 'package:pos_simple_v2/widgets/atoms/field/field_text.dart';

class FormProductUpdate {
  FormProductUpdate._privateConstructor();
  static final FormProductUpdate instance = FormProductUpdate._privateConstructor();

  void show(BuildContext context, BlocProduct blocProduct, {required int id}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => FormProductUpdateContent(blocProduct: blocProduct, id: id),
    );
  }
}

class FormProductUpdateContent extends StatefulWidget {
  final BlocProduct blocProduct;
  final int id;
  const FormProductUpdateContent({super.key, required this.blocProduct, required this.id});

  @override
  State<FormProductUpdateContent> createState() => _FormProductUpdateContentState();
}

class _FormProductUpdateContentState extends State<FormProductUpdateContent> {
  Map<String, dynamic> controller = {};
  final picker = ImagePicker();

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerUnit = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  void loadProduct() {
    final List<ModelProduct> products = [];
    RepositoryProduct.instance.get(where: 'id = ${widget.id}').then((res) {
      products.addAll(res.map((res) => ModelProduct.fromMap(res)).toList());
      controllerName.text = products.first.name;
      controllerUnit.text = products.first.unit;
      controllerPrice.text = PriceFormatter.instance.decimal(products.first.price, decimalDigits: 0);

      if (products.first.image != '' && products.first.image != null) {
        setState(() {
          controller = {...controller, "image": null, "image_preview": base64Decode(products.first.image ?? '')};
        });
      }
    });
  }

  void onReset() {
    setState(() {
      controller = {};
      controllerName.text = "";
      controllerPrice.text = "";
      controllerUnit.text = "";
    });
  }

  void onPickImage({type}) async {
    ImageSource imageSource;
    if (type == "galery") {
      imageSource = ImageSource.gallery;
    } else {
      imageSource = ImageSource.camera;
    }
    final pickedFile = await picker.pickImage(source: imageSource, imageQuality: 50);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      final cleanBase64 = base64Image.split(",").last;
      final Uint8List imageByte = base64Decode(cleanBase64);

      // Image profile saved as Base64 directly
      setState(() {
        controller = {...controller, "image": file, "image_preview": imageByte};
      });
    }
  }

  void onSave(BuildContext context, {bool reset = true}) async {
    File? file;
    if (controller['image'] != null) {
      file = controller["image"];

      if (!await file!.exists()) {
        return;
      }

      String fileExtension = extension(file.path); // ".jpg"
      bool isRenamed = RegExp(r'^\d{13}\.').hasMatch(basename(file.path));
      if (!isRenamed) {
        String newFileName = "${DateTime.now().millisecondsSinceEpoch}$fileExtension";
        var path = file.path;
        var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
        var newPath = path.substring(0, lastSeparator + 1) + newFileName;

        try {
          file = await file.rename(newPath);
          controller["image"] = file;
        } catch (e) {
          return;
        }
      }
    }

    try {
      String? image;
      if (file != null) {
        Uint8List imageBytes = await file.readAsBytes();
        image = base64Encode(imageBytes);
      }

      String price = controllerPrice.text.replaceAll(".", "");

      ModelProduct product = ModelProduct(
        id: widget.id,
        image: image,
        name: controllerName.text,
        unit: controllerUnit.text,
        price: double.parse(price),
      );

      widget.blocProduct.onUpdateProduct(product: product).then((res) {
        if (context.mounted && reset == false) {
          onReset();
          Navigator.of(context).pop();
        } else {
          onReset();
        }
      });
    } catch (e) {
      print("Gagal Simpan data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(color: ThemeApp.color.white, borderRadius: BorderRadius.circular(20)),
          child: ListView(
            children: [
              Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Navigator.of(context).pop(),
                    child: Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: ThemeApp.color.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(Icons.chevron_left, color: ThemeApp.color.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ubah Produk", style: ThemeApp.font.bold.copyWith(fontSize: 18)),
                        Text(
                          "Maksimalkan informasi produk lebih akurat",
                          style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => onPickImage(type: 'galery'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller["image_preview"] != null
                          ? SizedBox(
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.memory(
                                  controller["image_preview"],
                                  errorBuilder: (context, error, stackTrace) => Container(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                        decoration: BoxDecoration(color: ThemeApp.color.grey, borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(Icons.add_photo_alternate),
                            ),
                            SizedBox(height: 5),
                            Text("Tambahkan Foto"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: ThemeApp.font.regular.copyWith(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "*",
                      style: ThemeApp.font.regular.copyWith(color: Colors.red),
                    ),
                    TextSpan(text: "Isi judul atau nama produk"),
                  ],
                ),
              ),
              SizedBox(height: 3),
              FieldText(placeHolder: "Judul", controller: controllerName),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: ThemeApp.font.regular.copyWith(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "*",
                      style: ThemeApp.font.regular.copyWith(color: Colors.red),
                    ),
                    TextSpan(text: "Satuan produk contoh: kg, pcs"),
                  ],
                ),
              ),
              SizedBox(height: 3),
              FieldText(placeHolder: "Satuan", controller: controllerUnit),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: ThemeApp.font.regular.copyWith(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "*",
                      style: ThemeApp.font.regular.copyWith(color: Colors.red),
                    ),
                    TextSpan(text: "Harga satuan produk"),
                  ],
                ),
              ),
              SizedBox(height: 3),
              FieldNumber(placeHolder: "Harga", autoFocus: false, controller: controllerPrice),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Button(
                      onPress: () => onSave(context, reset: false),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, size: 20),
                          SizedBox(width: 5),
                          Text("Simpan", style: ThemeApp.font.medium),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
