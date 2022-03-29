import 'package:flutter/material.dart';
import '/screens/screens.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hero-like widget animation',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            headline1: TextStyle(
              color: Colors.black,
              fontFamily: 'MrsSheppards',
              fontSize: 30.0,
              wordSpacing: 5.0,
              letterSpacing: 3.0,
            ),
            bodyText1: TextStyle(
              color: Colors.black,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
            subtitle1: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
            bodyText2: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'MrsSheppards',
              fontSize: 19.0,
              height: .5,
              letterSpacing: 1.5,
              decorationStyle: TextDecorationStyle.solid,
              decoration: TextDecoration.underline,
            ),
          )),
      home: const HomeScreen(),
    );
  }
}
