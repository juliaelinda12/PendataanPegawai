import 'package:flutter/material.dart';
import 'db_sqlite.dart';
import 'main.dart';
import 'anakmagang.dart';
import 'pegawaitetap.dart';


void main() => runApp(const tabBar());

class tabBar extends StatelessWidget {
  const tabBar({super.key});

  static const String _title = '';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.business_center_outlined),
        title: Text('Data Kepegawaian'),
        backgroundColor: Colors.grey[700],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.timelapse_rounded),
              text: "Magang"
            ),
            Tab(
              icon: Icon(Icons.supervised_user_circle),
              text: "Pegawai Tetap",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: Anakmagang(),
          ),
          Center(
            child: Pegawaitetap(),
          ),
        ],
      ),
    );
  }
}
