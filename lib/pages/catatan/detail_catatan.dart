import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;
import '../../database/db_helper.dart';
import 'tambah_catatan.dart';

class DetailCatatanPage extends StatefulWidget {
  final Map<String, dynamic> catatanData; // Menerima data catatan yang diklik

  const DetailCatatanPage({Key? key, required this.catatanData}) : super(key: key);

  @override
  State<DetailCatatanPage> createState() => _DetailCatatanPageState();
}

class _DetailCatatanPageState extends State<DetailCatatanPage> {
  final Color primaryGreen = const Color(0xFF27AE60);
  late Map<String, dynamic> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.catatanData; // Salin data awal ke variabel state lokal
  }

  // Fungsi mengonversi jenis aktivitas ke Ikon & Warna
  Map<String, dynamic> _getStyle(String jenis) {
    switch (jenis) {
      case 'Penyiraman': return {'icon': Icons.water_drop, 'color': const Color(0xFF4A90E2)};
      case 'Pemupukan': return {'icon': Icons.eco, 'color': const Color(0xFF27AE60)};
      case 'Pengendalian Hama': return {'icon': Icons.bug_report, 'color': const Color(0xFFE57373)};
      case 'Penanaman': return {'icon': Icons.grass, 'color': Colors.green};
      case 'Panen': return {'icon': Icons.shopping_basket, 'color': Colors.orange};
      default: return {'icon': Icons.assignment, 'color': Colors.grey};
    }
  }

  // Fungsi Hapus Catatan
  void _konfirmasiHapus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Catatan"),
        content: const Text("Apakah kamu yakin ingin menghapus catatan aktivitas ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () async {
              await DBHelper.deleteCatatan(_currentData['id_catatan']);
              if (mounted) {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context, true); // Kembali ke list & beri sinyal refresh
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Widget baris informasi di dalam tabel/card detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var style = _getStyle(_currentData['jenis_aktivitas'] ?? '');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen, size: 28),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text("Detail Catatan", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black54), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BESAR ICON AVATAR & JENIS AKTIVITAS
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: style['color'].withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(style['icon'], color: style['color'], size: 48),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentData['jenis_aktivitas'] ?? 'Aktivitas',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. CARD PROTOKOL DETAIL DATA (Tabel data ringkas)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildDetailRow("Tanggal", _currentData['tanggal'] ?? '-'),
                  const Divider(),
                  _buildDetailRow("Waktu", _currentData['waktu'] ?? '-'),
                  const Divider(),
                  _buildDetailRow("Lokasi", _currentData['lokasi'] ?? '-'),
                  const Divider(),
                  _buildDetailRow("Catatan", _currentData['catatan'] ?? '-'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. DETAIL CATATAN (Teks Deskripsi Panjang)
            const Text("Detail Catatan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 8),
            Text(
              _currentData['detail_catatan'] ?? 'Tidak ada detail cerita.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),

            // 4. PREVIEW FOTO
            const Text("Foto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 180,
                color: Colors.grey.shade100,
                child: _currentData['foto'] == null || _currentData['foto'].isEmpty
                    ? const Icon(Icons.image_not_supported, color: Colors.grey, size: 40)
                    : kIsWeb
                        ? Image.network(_currentData['foto'], fit: BoxFit.cover)
                        : Image.file(io.File(_currentData['foto']), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 40),

            // 5. TOMBOL AKSI BAWAH (EDIT & HAPUS) SISI BY SISI
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: primaryGreen, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // Buka halaman edit dengan mengirimkan data lama
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TambahCatatanPage(catatanUntukEdit: _currentData),
                        ),
                      ).then((updatedData) {
                        // Jika ada data baru hasil update, refresh state lokal halaman detail
                        if (updatedData != null && updatedData is Map<String, dynamic>) {
                          setState(() {
                            _currentData = updatedData;
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.edit_outlined, color: primaryGreen),
                    label: Text("Edit", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _konfirmasiHapus,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text("Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}