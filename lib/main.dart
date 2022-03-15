import 'package:doingdubai/config/keys/pref_keys.dart';
import 'package:doingdubai/src/ui/pages/get_started.dart';
import 'package:doingdubai/src/ui/pages/personaility_test.dart';
import 'package:doingdubai/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:req_fun/req_fun.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.getPrefs().then((prefs) {
    var firstTimeLogin = prefs.getBool(PrefKey.FIRST_TIME_LOGIN) ?? true;
    String authToken = prefs.getString(PrefKey.AUTHORIZATION) ?? "";
    StatefulWidget child = GetStarted();
    if (!firstTimeLogin && authToken.isNotEmpty) {
      child = PersonalityTestPage();
    }
    runApp(MyApp(child: child));
  });
}

class MyApp extends StatelessWidget {
  final StatefulWidget? child;

  const MyApp({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       themeMode: ThemeMode.dark,
       darkTheme: ThemeData.dark(),
       theme: AppColors.knarkzThemeData,
      home: Material(
        child: this.child,
      ),
    );
  }
}
