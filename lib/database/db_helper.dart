import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  // Open database
  static Future<Database> openDB() async {
    if (_db != null) return _db!;
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'petani_pintar.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabel User
        await db.execute('''
          CREATE TABLE User(
            id_user INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            email TEXT,
            password TEXT,
            no_hp TEXT,
            created_at DATETIME
          )
        ''');

        // Tabel Catatan
        await db.execute('''
          CREATE TABLE Catatan(
            id_catatan INTEGER PRIMARY KEY AUTOINCREMENT,
            id_user INTEGER,
            jenis_aktivitas TEXT,
            catatan TEXT,
            detail_catatan TEXT,
            lokasi TEXT,
            foto TEXT,
            tanggal DATE,
            waktu TIME,
            created_at DATETIME
          )
        ''');

        // Tabel Jadwal
        await db.execute('''
          CREATE TABLE Jadwal(
            id_jadwal INTEGER PRIMARY KEY AUTOINCREMENT,
            id_user INTEGER,
            jenis_aktivitas TEXT,
            catatan TEXT,
            detail_catatan TEXT,
            lokasi TEXT,
            tanggal DATE,
            waktu TIME,
            status TEXT,
            created_at DATETIME
          )
        ''');

        // Tabel Cuaca
        await db.execute('''
          CREATE TABLE Cuaca(
            id_cuaca INTEGER PRIMARY KEY AUTOINCREMENT,
            kota TEXT,
            suhu REAL,
            kelembapan INTEGER,
            kondisi TEXT,
            kecepatan_angin REAL,
            tanggal_update DATETIME
          )
        ''');

        // Tabel Tips
        await db.execute('''
          CREATE TABLE Tips(
            id_tips INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT,
            isi_tips TEXT,
            kategori TEXT,
            created_at DATETIME
          )
        ''');

        // Tabel Notifikasi
        await db.execute('''
          CREATE TABLE Notifikasi(
            id_notifikasi INTEGER PRIMARY KEY AUTOINCREMENT,
            id_jadwal INTEGER,
            judul TEXT,
            pesan TEXT,
            status_baca INTEGER,
            created_at DATETIME
          )
        ''');
      },
    );
    return _db!;
  }

  // Contoh insert User
  static Future<int> insertUser(Map<String, dynamic> data) async {
    final db = await openDB();
    return await db.insert('User', data);
  }

  // Contoh query User
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await openDB();
    return await db.query('User');
  }

  // ==========================================
  // TAMBAHAN FUNGSI UNTUK CATATAN (AKTIVITAS)
  // ==========================================

  // Insert data catatan baru
  static Future<int> insertCatatan(Map<String, dynamic> data) async {
    final db = await openDB();
    return await db.insert('Catatan', data);
  }

  // Ambil semua data catatan, diurutkan dari yang terbaru (DESC)
  static Future<List<Map<String, dynamic>>> getCatatan() async {
    final db = await openDB();
    return await db.query('Catatan', orderBy: 'tanggal DESC, waktu DESC');
  }

  // Hapus catatan berdasarkan ID
  static Future<int> deleteCatatan(int id) async {
    final db = await openDB();
    return await db.delete('Catatan', where: 'id_catatan = ?', whereArgs: [id]);
  }

  // Update/Edit catatan berdasarkan ID
  static Future<int> updateCatatan(int id, Map<String, dynamic> data) async {
    final db = await openDB();
    return await db.update('Catatan', data, where: 'id_catatan = ?', whereArgs: [id]);
  }

  // ==========================================
  // TAMBAHAN FUNGSI UNTUK JADWAL
  // ==========================================

  // Insert data jadwal baru
  static Future<int> insertJadwal(Map<String, dynamic> data) async {
    final db = await openDB();
    return await db.insert('Jadwal', data);
  }

  // Ambil data jadwal, diurutkan dari tanggal terdekat (ASC)
  static Future<List<Map<String, dynamic>>> getJadwal() async {
    final db = await openDB();
    return await db.query('Jadwal', orderBy: 'tanggal ASC');
  }

  // Tambahan fungsi untuk mengupdate data Jadwal berdasarkan ID
  static Future<int> updateJadwal(int id, Map<String, dynamic> data) async {
    final db = await openDB();
    return await db.update('Jadwal', data, where: 'id_jadwal = ?', whereArgs: [id]);
  }

  // ========================================================
  // BARU: FUNGSI UNTUK MENGHAPUS DATA JADWAL BERDASARKAN ID
  // ========================================================
  static Future<int> deleteJadwal(int id) async {
    final db = await openDB();
    return await db.delete('Jadwal', where: 'id_jadwal = ?', whereArgs: [id]);
  }
}