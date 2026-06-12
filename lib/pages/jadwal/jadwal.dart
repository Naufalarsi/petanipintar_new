import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../database/db_helper.dart'; // Jalur naik 2 tingkat ke folder database, sesuaikan jika berbeda
// import 'tambah_jadwal.dart'; // Buka comment ini jika sudah ada file tambah jadwal

class JadwalPage extends StatefulWidget {
  const JadwalPage({Key? key}) : super(key: key);

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final Color primaryGreen = const Color(0xFF27AE60);
  final Color bgColor = const Color(0xFFF2F5F7);

  // Fungsi bantuan untuk mendapatkan icon & warna berdasarkan jenis kegiatan/jadwal
  Map<String, dynamic> _getJadwalStyle(String kegiatan) {
    switch (kegiatan) {
      case 'Penyiraman':
        return {'icon': Icons.water_drop, 'color': const Color(0xFF4A90E2)};
      case 'Pemupukan':
        return {'icon': Icons.eco, 'color': const Color(0xFF27AE60)};
      case 'Panen':
        return {'icon': Icons.gavel, 'color': Colors.orange};
      default:
        return {'icon': Icons.calendar_today, 'color': Colors.blue};
    }
  }

  // Fungsi untuk refresh state saat kembali dari halaman tambah
  void refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DBHelper.getJadwal(), // <-- Pastikan fungsi ini sudah ada di db_helper.dart kamu
      builder: (context, snapshot) {
        // 1. JIKA DATA SEDANG DIMUAT
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. CEK JIKA DATA KOSONG ATAU DIJALANKAN DI WEB
        if (!snapshot.hasData || snapshot.data!.isEmpty || kIsWeb) {
          return _buildBlankState(context); // TAMPILKAN LAYAR KONDISI BLANK/KOSONG
        }

        // 3. JIKA DATA JADWAL TERSEDIA
        List<Map<String, dynamic>> dataJadwal = snapshot.data!;
        return _buildListState(context, dataJadwal); // TAMPILKAN LAYAR UTAMA JADWAL
      },
    );
  }

  // =======================================================================
  // LAYAR 1: TAMPILKAN KONDISI BLANK / KOSONG (Adopsi gaya catatan.dart)
  // =======================================================================
  Widget _buildBlankState(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Jadwal Kegiatan", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pake icon kalender bawaan dulu sebagai placeholder, atau ganti asset gambarmu
            Image.asset('assets/images/iconkalender.png', height: 220, errorBuilder: (c, e, s) => Icon(Icons.assignment, size: 150, color: Colors.grey[300])),
            const SizedBox(height: 10),
            Text("Belum ada jadwal", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: primaryGreen)),
            const SizedBox(height: 12),
            Text(
              "Buat pengingat aktivitas pertanianmu\nagar perawatan tanaman tetap\nterjadwal dengan baik.",
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
                  // Jalur navigasi ke form tambah jadwal kamu
                  print("Navigasi ke Tambah Jadwal");
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TambahJadwalPage()),
                  ).then((value) => refreshData());
                  */
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 28),
                label: const Text("Tambah Jadwal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // =======================================================================
  // LAYAR 2: TAMPILKAN LAYOUT ASLI JADWAL (Silakan sesuaikan isi Column-nya)
  // =======================================================================
  Widget _buildListState(BuildContext context, List<Map<String, dynamic>> listData) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Jadwal Kegiatan", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // -----------------------------------------------------------------
          // Taruh Layout Atas Aslimu di sini (Misal: Kalender horizontal / Filter)
          // -----------------------------------------------------------------
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: const Center(
              child: Text("Tempat Kalender Horizontal / Filter Jadwal Aslimu"),
            ),
          ),

          // -----------------------------------------------------------------
          // LIST DATA JADWAL UTAMA (Desain Card Aslimu masukkan ke sini)
          // -----------------------------------------------------------------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 80), // Padding bawah 80 biar gak ketutupan FAB Global
              itemCount: listData.length,
              itemBuilder: (context, index) {
                var item = listData[index];
                var style = _getJadwalStyle(item['kegiatan'] ?? ''); // Sesuaikan key map dari database-mu

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
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
                              Text(item['kegiatan'] ?? 'Kegiatan', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(item['keterangan'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(item['jam'] ?? '', style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(item['tanggal'] ?? '', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}