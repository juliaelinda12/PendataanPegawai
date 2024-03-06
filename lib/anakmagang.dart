import 'package:flutter/material.dart';
import 'package:uas/db_sqlite.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'models/magang.dart';

void main() {
  runApp(const Anakmagang());
}

class Anakmagang extends StatelessWidget {
  const Anakmagang ({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project UAS ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Data Kepegawaian'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController posisiController = TextEditingController();
  TextEditingController gajiController = TextEditingController();

  List<Map<String, dynamic>> data_kepegawaian = [];

  void refreshData() async {
    final data = await DatabaseHelper.getMagang();

    setState(() {
      data_kepegawaian = data;
    });
  }

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  String? photoprofile;
  Future<String> getFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'webm',
      ],
    );

    if (result != null) {
      PlatformFile sourceFile = result.files.first;
      final destination = await getExternalStorageDirectory();
      File? destinationFile =
          File('${destination!.path}/${sourceFile.name.hashCode}');
      final newFile =
          File(sourceFile.path!).copy(destinationFile.path.toString());
      setState(() {
        photoprofile = destinationFile.path;
      });
      File(sourceFile.path!.toString()).delete();
      return destinationFile.path;
    } else {
      return "Dokumen belum diupload";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data_kepegawaian.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 5,
              child: ListTile(
                leading: 
                data_kepegawaian[index]['nama'] != ''
                    ? Image.file(File(data_kepegawaian[index]['foto']),
                        fit: BoxFit.cover)
                    : FlutterLogo(),
                title: Text(data_kepegawaian[index]['nama']),
                subtitle: 
                Row(
              children: [
                  Text(data_kepegawaian[index]['posisi'] +
                      " ( Rp  " +
                      data_kepegawaian[index]['gaji'] + " ) "),
                  Padding(padding: EdgeInsets.all(5)), //mengatur jarak 
              ],
            ),
                onTap: () {
                  Form(data_kepegawaian[index]['id']);
                },
                trailing: IconButton(
                    onPressed: () {
                      hapusMagang(data_kepegawaian[index]['id']);
                    },
                    icon: const Icon(Icons.delete)),
              )
              );
        },
      ),
      floatingActionButton: FloatingActionButton( //button dengan simbol tambah 
        onPressed: () {
          Form(null);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void Form(id) async {
    if (id != null) {
      final dataupdate =
          data_kepegawaian.firstWhere((element) => element['id'] == id);
      namaController.text = dataupdate['nama'];
      posisiController.text = dataupdate['posisi'];
      gajiController.text = dataupdate['gaji'];
    }
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 800,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(hintText: "Nama"),
                  ),
                  TextField(
                    controller: posisiController,
                    decoration: const InputDecoration(hintText: "Posisi"),
                  ),
                  TextField(
                    controller: gajiController,
                    decoration:
                        const InputDecoration(hintText: "Gaji"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        getFilePicker();
                      },
                      child: Row(
                        children: const [
                          Text("Pilih Gambar"),
                          Icon(Icons.camera)
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        if (id != null) {
                          String? foto = photoprofile;
                          final data = MagangModel(
                              id: id,
                              nama: namaController.text,
                              posisi: posisiController.text,
                              gaji: gajiController.text,
                              foto: foto.toString());
                          updateMagang(data);
                          namaController.text = '';
                          posisiController.text = '';
                          gajiController.text = '';
                          Navigator.pop(context);
                        } else {
                          String? foto = photoprofile;
                          final data = MagangModel(
                              nama: namaController.text,
                              posisi: posisiController.text,
                              gaji: gajiController.text,
                              foto: foto.toString());
                          tambahMagang(data);
                          namaController.text = '';
                          posisiController.text = '';
                          gajiController.text = '';
                          Navigator.pop(context);
                        }
                      },
                      child: Text(id == null ? "Tambah" : 'update'))
                ],
              ),
            ),
          );
        });
  }

  Future<void> tambahMagang(MagangModel MagangModel) async {
    await DatabaseHelper.tambahMagang(MagangModel);
    return refreshData();
  }

  Future<void> updateMagang(MagangModel MagangModel) async {
    await DatabaseHelper.updateMagang(MagangModel);
    return refreshData();
  }

  Future<void> hapusMagang(int id) async {
    await DatabaseHelper.deleteMagang(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Berhasil Dihapus")));
    return refreshData();
  }
}
