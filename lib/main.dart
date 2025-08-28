import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pos_simple_v2/configs/config.dart';
import 'package:pos_simple_v2/databases/database_initial.dart';
import 'package:pos_simple_v2/routes/route_generate.dart';
import 'package:pos_simple_v2/routes/route_name.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Config.easyLoading();
  DatabaseInitial.instance.initialDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [...RouteGenerate.pageProvider(context)],
      child: MaterialApp(
        title: const String.fromEnvironment("APP_NAME"),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          scaffoldBackgroundColor: Colors.white,
          bottomSheetTheme: const BottomSheetThemeData(surfaceTintColor: Colors.white),
          useMaterial3: true,
        ),
        initialRoute: RouteName.INITIAL,
        onGenerateRoute: RouteGenerate.onRoute,
        builder: EasyLoading.init(),
      ),
    );
  }
}
