import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;
import '../../database/db_helper.dart'; // Jalur naik 2 tingkat ke folder database
import 'tambah_catatan.dart';
import 'detail_catatan.dart'; // Jangan lupa import halaman detailnya

class CatatanPage extends StatefulWidget {
  const CatatanPage({Key? key}) : super(key: key);

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  final Color primaryGreen = const Color(0xFF27AE60);
  final Color bgColor = const Color(0xFFF2F5F7);

  // Fungsi bantuan untuk mendapatkan icon & warna berdasarkan jenis aktivitas
  Map<String, dynamic> _getAktivitasStyle(String jenis) {
    switch (jenis) {
      case 'Penanaman':
        return {'icon': Icons.grass, 'color': Colors.green}; // Menggunakan icon grass (valid)
      case 'Penyiraman':
        return {'icon': Icons.water_drop, 'color': const Color(0xFF4A90E2)};
      case 'Pemupukan':
        return {'icon': Icons.eco, 'color': const Color(0xFF27AE60)};
      case 'Pengendalian Hama':
        return {'icon': Icons.bug_report, 'color': const Color(0xFFE57373)};
      case 'Panen':
        return {'icon': Icons.gavel, 'color': Colors.orange}; 
      default:
        return {'icon': Icons.assignment, 'color': Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DBHelper.getCatatan(), // Mengambil data riwayat langsung dari SQLite
      builder: (context, snapshot) {
        // Jika data sedang dimuat
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Cek apakah data null atau kosong, atau jika dijalankan di Web (karena sqflite web selalu kosong/error)
        if (!snapshot.hasData || snapshot.data!.isEmpty || kIsWeb) {
          return _buildBlankState(context); // TAMPILKAN LAYAR 1 (BLANK)
        }

        // Jika data tersedia dan ada isinya
        List<Map<String, dynamic>> dataCatatan = snapshot.data!;
        return _buildListState(context, dataCatatan); // TAMPILKAN LAYAR 3 (DAFTAR ISI)
      },
    );
  }

  // =======================================================================
  // LAYAR 1: TAMPILKAN KONDISI BLANK / KOSONG (Desain Pertama)
  // =======================================================================
  Widget _buildBlankState(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Tambah Harian", style: TextStyle(color: Color(0xFF27AE60), fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/clipboard.png',
              height: 220,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.assignment, size: 150, color: Colors.grey[300]),
            ),
            const SizedBox(height: 32),
            Text("Belum ada catatan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: primaryGreen)),
            const SizedBox(height: 12),
            Text(
              "Mulai catat setiap aktivitas\npertanianmu untuk hasil panen\nyang lebih optimal",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.4, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  // Navigasi ke Form Tambah, panggil setState saat kembali untuk refresh data
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TambahCatatanPage()),
                  ).then((value) => setState(() {}));
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 28),
                label: const Text("Tambah Catatan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // =======================================================================
  // LAYAR 3: TAMPILKAN DAFTAR RIWAYAT CATATAN TERISI (Desain Ketiga)
  // =======================================================================
  Widget _buildListState(BuildContext context, List<Map<String, dynamic>> listData) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Catatan Harian", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // KOMPONEN ATAS: SEARCH BAR & FILTER
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "Cari Aktivitas",
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.tune, color: Colors.grey), // Icon Filter Corong
                    )
                  ],
                ),
                const SizedBox(height: 12),
                // PILIHAN FILTER DROPDOWN MINI
                Row(
                  children: [
                    _buildMiniDropdown("Semua Aktivitas"),
                    const SizedBox(width: 10),
                    _buildMiniDropdown("Mei 2026"),
                  ],
                ),
              ],
            ),
          ),

          // CARD SUMMARY RINGKASAN BULAN INI
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.analytics_outlined, color: primaryGreen, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ringkasan Bulan Ini", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 2),
                      Text("${listData.length} Aktivitas tercatat", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // LIST DATA AKTIVITAS UTAMA
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: listData.length,
              itemBuilder: (context, index) {
                var item = listData[index];
                var style = _getAktivitasStyle(item['jenis_aktivitas'] ?? '');

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  // INI ADALAH KODE INKWELL YANG DITAMBAHKAN AGAR BISA DIKLIK
                  child: InkWell( 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCatatanPage(catatanData: item), // Kirim data item ke detail
                        ),
                      ).then((value) {
                        // Ketika kembali dari halaman detail (setelah edit atau hapus), refresh data list utama
                        if (value == true) {
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: style['color'].withOpacity(0.1), shape: BoxShape.circle),
                            child: Icon(style['icon'], color: style['color'], size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['jenis_aktivitas'] ?? 'Aktivitas', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 2),
                                Text(item['catatan'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                                const SizedBox(height: 2),
                                Text(item['lokasi'] ?? '', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey.shade400)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(item['waktu'] ?? '', style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(item['tanggal'] ?? '', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // FLOATING ACTION BUTTON (FAB) UNTUK TAMBAH DATA SAAT HALAMAN SUDAH TERISI
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahCatatanPage()),
          ).then((value) => setState(() {})); // Refresh data saat kembali dari form
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  // WIDGET BANTUAN: PILIHAN FILTER MINI
  Widget _buildMiniDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}