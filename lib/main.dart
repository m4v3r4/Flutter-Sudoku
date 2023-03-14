import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/sudoku.dart';

void main() {
  SharedPreferences.getInstance().then((prefs) {
    _prefs = prefs;

    isDarkMode = _prefs.getBool('isDark') ?? false;
  });
  runApp(MyApp());
}

bool isDarkMode = false;
late SharedPreferences _prefs;
final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 110, 110, 110)),
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      surface: Colors.grey,
      onSurface: Colors.black,
    ));

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.black,
  appBarTheme: const AppBarTheme(color: Colors.black),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 138, 138, 138),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    surface: Colors.grey,
    onSurface: Colors.white,
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sudoku',
        theme: isDarkMode == true ? darkTheme : lightTheme,
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      setState(() {
        isDarkMode = _prefs.getBool('isDark') ?? false;
      });
    });
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
      _prefs.setBool('isDark', isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Sudoku",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              letterSpacing: 2,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(10.0, 5.0),
                  blurRadius: 4.0,
                  color: Color.fromARGB(71, 0, 0, 0),
                ),
                Shadow(
                  offset: Offset(10.0, 5.0),
                  blurRadius: 1.0,
                  color: Color.fromARGB(117, 165, 165, 165),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SudokuPage(i: 1, title: "Başlangıç")),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.play_arrow),
                VerticalDivider(
                  thickness: 1,
                ),
                Text("Başlangıç")
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SudokuPage(
                          i: 2,
                          title: "Orta",
                        )),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.play_arrow),
                VerticalDivider(
                  thickness: 1,
                ),
                Text("Orta")
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SudokuPage(
                          i: 3,
                          title: "Zor",
                        )),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.play_arrow),
                VerticalDivider(
                  thickness: 1,
                ),
                Text("Zor")
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SudokuPage(
                          i: 4,
                          title: "İleri",
                        )),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.play_arrow),
                VerticalDivider(
                  thickness: 1,
                ),
                Text("İleri")
              ],
            ),
          ),
        ],
      )),
      floatingActionButton: Switch(
        trackColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (isDarkMode == true) {
            return Colors.orange.withOpacity(.10);
          }
          return Colors.orange;
        }),
        thumbColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (isDarkMode == true) {
            return Colors.orange.withOpacity(.10);
          }
          return Colors.orange;
        }),
        thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
            (Set<MaterialState> states) {
          if (isDarkMode == true) {
            return const Icon(
              Icons.nightlight_round_outlined,
              color: Colors.black,
            );
          } else
            return const Icon(
              Icons.light_mode,
              color: Colors.white,
            );
        }),
        value: isDarkMode,
        onChanged: (value) {
          _toggleDarkMode();

          setState(() {
            isDarkMode;
            MyHomePage();
          });
          runApp(MyApp());
        },
      ),
    );
  }
}
