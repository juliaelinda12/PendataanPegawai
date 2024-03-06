import 'package:uas/models/magang.dart';
import 'package:uas/models/tetap.dart';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'dart:async';

import 'package:flutter/widgets.dart'; 

class DatabaseHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(join(await sql.getDatabasesPath(), 'pegawai.db'),
        version: 1, onCreate: (database, version) async {
      await database.execute("""
        CREATE TABLE magang (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          nama TEXT,
          posisi TEXT,
          gaji TEXT,
          foto TEXT

        )
      """);

      await database.execute("""
        CREATE TABLE tetap (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          nama TEXT,
          posisi TEXT,
          gaji TEXT,
          foto TEXT

        )
      """);

    });
  }

  static Future<int> tambahMagang(MagangModel magang) async {
    final db = await DatabaseHelper.db();
    final data = magang.toList();
    return db.insert('magang', data);
  }

  static Future<int> tambahTetap(TetapModel tetap) async {
    final db = await DatabaseHelper.db();
    final data =tetap.toList();
    return db.insert('tetap', data);
  }

  static Future<List<Map<String, dynamic>>> getMagang() async {
    final db = await DatabaseHelper.db();
    return db.query("magang");
  }

  static Future<List<Map<String, dynamic>>> getTetap() async {
    final db = await DatabaseHelper.db();
    return db.query("tetap");
  }

  static Future<int> updateMagang(
      MagangModel magang) async {
    final db = await DatabaseHelper.db();
    final data = magang.toList();
    return db.update('magang', data, where: "id=?", whereArgs: [magang.id]);
  }

  static Future<int> updateTetap(
      TetapModel tetap) async {
    final db = await DatabaseHelper.db();
    final data = tetap.toList();
    return db.update('tetap', data, where: "id=?", whereArgs: [tetap.id]);
  }

  static Future<int> deleteMagang(int id) async {
    final db = await DatabaseHelper.db();
    return db.delete('magang', where: 'id=$id');
  }

  static Future<int> deleteTetap(int id) async {
    final db = await DatabaseHelper.db();
    return db.delete('tetap', where: 'id=$id');
  }
}
