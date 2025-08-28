import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AppPath {
  AppPath._privateConstructor();
  static final AppPath instance = AppPath._privateConstructor();

  Future<String> mainDirectoryDb(dbName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return path;
  }
}
