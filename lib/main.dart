import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/change_notifire.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/storage/db_controller.dart';
import 'package:todo_app/storage/db_provider.dart';
import 'package:todo_app/ui/pages/home_page.dart';
import 'package:todo_app/ui/pages/lunch_screen.dart';
import 'package:todo_app/ui/pages/notification_screen.dart';
import 'package:todo_app/ui/theme.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized;
  await DbProvider().initDatabase();
  await TaskChangeProvider();
  // NotifyHelper().initializatonNotification();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskChangeProvider>(
            create: (_) => TaskChangeProvider()),
      ],
      child: GetMaterialApp(
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeServices().themeMode,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: LunchScreen(),
      ),
    );
  }
}
