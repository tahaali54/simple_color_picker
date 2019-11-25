import 'package:flutter/material.dart';
import 'package:simple_color_picker/simple_color_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Picker Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HSVColor color = HSVColor.fromColor(Colors.cyan);
  void onChanged(HSVColor value) => this.color = value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Picker Example'),
      ),
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: this.color.toColor(),
                    ),
                    Divider(),
                    SimpleColorPicker(
                      color: this.color,
                      onChanged: (value) =>
                          super.setState(() => this.onChanged(value)),
                    ),
                  ],
                ),
              )),
        ),
      )),
    );
  }
}
