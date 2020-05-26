import 'package:ecorenew_ui/Utilities/size_preferences.dart';
import 'package:ecorenew_ui/View/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'View/Common/neumorph.dart';
import 'package:flutter/services.dart';
import 'View/Login/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   
    return LayoutBuilder(
      builder: (context, constraints)
      {
        return OrientationBuilder
        (
          builder: (context, orientation)
          {
            SizeConfig().init(constraints, orientation);
             return MaterialApp
             (
                debugShowCheckedModeBanner: true,
                theme: ThemeData(textTheme: TextTheme(bodyText1: GoogleFonts.nunitoSans(color: fCL,
                  shadows: [Shadow(blurRadius: 10.0, color: Colors.grey.shade50,offset: Offset(5.0,5.0))]
                ))),
                home: LoginPage(),
              );
          }
        );       
      }      
    );
  }
}





