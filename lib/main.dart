import 'package:flutter/material.dart';
import 'package:uas/db_sqlite.dart';
import 'tab_bar.dart';
import 'dart:math' as math;


void main() {
  runApp(new MaterialApp(
    home: MyStatefulWidget(),
    title: "DATA PEGAWAI",
    routes: <String, WidgetBuilder>{
      '/tabBar': (context) => tabBar(),
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
      body: Container(
          alignment: FractionalOffset.center,
          color: Colors.grey[700],
          padding: EdgeInsets.only(top: 200),
          child: Column(children: [
            Text(
              'DATA KEPEGAWAIAN',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Padding(padding: EdgeInsets.all(20)),
            Image.asset(
              'images/logo.png',
              height: 200,
              
            ),
            Padding(padding: EdgeInsets.all(20)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                primary: Colors.white,
                onPrimary: Colors.grey[700],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/tabBar');
              },
              child: new Text('Masuk'),
            ),
          ])),
    ));
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  //memanggil class _MyStatefulWidgetState
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3), //butuh 3 detik untuk 1 putaran
    vsync: this,
  )..repeat();
  bool _currentState = false; // mendefinisikan default false (kondisi bergerak)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: FractionalOffset.center,
        color: Colors.grey[700],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DATA KEPEGAWAIAN',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Padding(padding: EdgeInsets.all(10)),
            AnimatedBuilder( //membuat animasi
                child: ClipOval(
                  child: Image.asset(
                    'lib/images/logo.jpg',
                    width: 200.0, height: 200.0,
                    fit: BoxFit.cover, //mengatur foto fit dengan ukuran
                  ),
                ),
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: _controller.value * 2.0 * math.pi, //mengatur putaran
                    child: child,
                  );
                },
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            GestureDetector(
                onDoubleTap: () {
                  print(_currentState);
                  setState(() {
                    _currentState = !_currentState;
                    if (_currentState == true) {
                      _controller.stop(); //jika true maka berhenti berotasi
                    } else {
                      _controller.repeat(); //jika false maka mulai berotasi
                    }
                  });
                },
                child: Container(
                  width: 40.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(139, 0, 0, 0),
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //mengatur tampilan button
                      Icon(
                          _currentState ? Icons.play_arrow : Icons.stop_circle),
                    ],
                  ),
                )),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                primary: Colors.amber[100],
                onPrimary: Colors.grey[900],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/tabBar');
              },
              child: new Text('Masuk'),
            ),

          ],
        ),
      ),
    );
  }
}
