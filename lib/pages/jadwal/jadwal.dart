import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../database/db_helper.dart'; // Jalur database SQLite
import 'tambah_jadwal.dart'; // Jalur halaman tambah

class JadwalPage extends StatefulWidget {
  const JadwalPage({Key? key}) : super(key: key);

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final Color primaryGreen = const Color(0xFF27AE60);
  final Color bgColor = const Color(0xFFF8FAF9); // Background abu-abu sangat muda khas premium
  
  late Future<List<Map<String, dynamic>>> _jadwalFuture;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _jadwalFuture = DBHelper.getJadwal();
  }

  void refreshData() {
    setState(() {
      _initData();
    });
  }

  // Pemetaan Gaya Visual Dinamis (Ikon & Warna) Sesuai Mockup Gambar
  Map<String, dynamic> _getJadwalStyle(String kegiatan) {
    switch (kegiatan) {
      case 'Pemupukan':
        return {'icon': Icons.bakery_dining_rounded, 'color': const Color(0xFF27AE60)}; // Ganti ke ikon pupuk/kantong jika ada
      case 'Penyiraman':
        return {'icon': Icons.opacity, 'color': const Color(0xFF4A90E2)};
      case 'Panen':
        return {'icon': Icons.agriculture, 'color': const Color(0xFFF2994A)};
      case 'Penanaman':
        return {'icon': Icons.grass, 'color': const Color(0xFF2ECC71)};
      case 'Pengendalian Hama':
        return {'icon': Icons.bug_report, 'color': const Color(0xFFEB5757)};
      default:
        return {'icon': Icons.assignment, 'color': Colors.grey};
    }
  }

  // Fungsi pembantu untuk menghitung sisa hari secara simulasi (bisa dikembangkan nanti)
  String _hitungSisaHari(String tanggal) {
    if (tanggal.contains('21 Mei')) return '2 hari lagi';
    if (tanggal.contains('22 Mei')) return '3 hari lagi';
    if (tanggal.contains('24 Mei')) return '4 hari lagi';
    if (tanggal.contains('01 Juni')) return '12 hari lagi';
    return 'Segera';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _jadwalFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Jika data kosong atau berjalan di Web, tampilkan blank state bawaan lama
        if (!snapshot.hasData || snapshot.data!.isEmpty || kIsWeb) {
          return _buildBlankState(context); 
        }

        List<Map<String, dynamic>> dataJadwal = snapshot.data!;
        return _buildListState(context, dataJadwal); 
      },
    );
  }

  // =======================================================================
  // LAYAR 1: KONDISI BLANK / KOSONG (Sesuai Desain Gambar Pertama Anda)
  // =======================================================================
  Widget _buildBlankState(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Tambah Jadwal", style: TextStyle(color: Color(0xFF27AE60), fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Image.asset(
              'assets/images/iconkalender.png', 
              height: 200, 
              errorBuilder: (c, e, s) => const Icon(Icons.calendar_month, size: 150, color: Color(0xFF27AE60)),
            ),
            const SizedBox(height: 32),
            const Text(
              "Belum ada jadwal", 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF27AE60)),
            ),
            const SizedBox(height: 12),
            Text(
              "Mulai jadwalkan setiap aktivitas pertanianmu untuk hasil panen yang lebih optimal",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.4, fontWeight: FontWeight.w500),
            ),
            const Spacer(flex: 2),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TambahJadwalPage()),
                  ).then((value) {
                    if (value == true) refreshData();
                  });
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 24),
                label: const Text("Tambah Jadwal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // =======================================================================
  // LAYAR 2: TAMPILKAN LAYOUT UTAMA JADWAL & PENGINGAT (Sama Persis Mockup)
  // =======================================================================
  Widget _buildListState(BuildContext context, List<Map<String, dynamic>> listData) {
    // Hitung ringkasan data statis/dinamis untuk diletakkan di card atas
    int totalAktif = listData.length;
    int akanDatang = listData.where((e) => e['status'] == 'Belum Selesai').length;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Spasi agar item paling bawah tidak tertutup FAB
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER DENGAN GAMBAR BACKGROUND SAWAH
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bg_sawah.png'), // Pastikan file gambar ada di aset kamu
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.15), // Overlay tipis agar teks mudah dibaca
                        padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
                        child: const Column(
                          children: [
                            Text(
                              "Jadwal dan Pengingat",
                              style: TextStyle(color: Color(0xFF27AE60), fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Kelola jadwal kegiatan pertanianmu\ndan dapatkan pengingat otomatis",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // 2. TIGA KARTU STATISTIK (MELAYANG MEMOTONG HEADER)
                    Positioned(
                      bottom: -40,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard("Jadwal Aktif", totalAktif.toString(), const Color(0xFF27AE60)),
                          _buildStatCard("Akan Datang", akanDatang.toString(), const Color(0xFFF2994A)),
                          _buildStatCard("Selesai", "12", const Color(0xFF27AE60)), // Nilai statis contoh dari gambar mockup
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 64), // Memberikan ruang pasca overlap kartu statistik

                // 3. SUB-JUDUL SECTION "Jadwal Aktif"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Jadwal Aktif",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Text("Lihat Semua", style: TextStyle(color: Color(0xFF27AE60), fontWeight: FontWeight.bold, fontSize: 14)),
                        label: const Icon(Icons.arrow_forward_ios, color: Color(0xFF27AE60), size: 14),
                      )
                    ],
                  ),
                ),

                // 4. DAFTAR LIST KARTU JADWAL PERTANIAN
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    var item = listData[index];
                    var style = _getJadwalStyle(item['jenis_aktivitas'] ?? '');
                    String sisaHari = _hitungSisaHari(item['tanggal'] ?? '');

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ikon Bundar Kegiatan Utama
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: style['color'],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(style['icon'], color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 16),
                              
                              // Detail Info Konten (Judul & Catatan Pendek)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['jenis_aktivitas'] ?? 'Aktivitas',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (item['catatan'] != null && item['catatan'].toString().isNotEmpty) 
                                          ? item['catatan'] 
                                          : (item['lokasi'] ?? 'Sawah'),
                                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Switch Toggle Kustom (On / Off)
                              Transform.scale(
                                scale: 0.85,
                                child: Switch(
                                  value: true, // Default diset aktif sesuai gambar mockup
                                  activeColor: Colors.white,
                                  activeTrackColor: const Color(0xFF2ECC71),
                                  onChanged: (bool value) {},
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: Color(0xFFF2F2F2)),
                          const SizedBox(height: 12),
                          
                          // Baris Informasi Waktu Pelaksanaan & Badge Sisa Hari
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(item['tanggal'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 14),
                                  const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(item['waktu'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              
                              // Badge Status "X hari lagi"
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: sisaHari.contains('2') || sisaHari.contains('3')
                                      ? const Color(0xFFE8F8EE) 
                                      : const Color(0xFFFDF2E9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  sisaHari,
                                  style: TextStyle(
                                    fontSize: 11, 
                                    fontWeight: FontWeight.bold, 
                                    color: sisaHari.contains('2') || sisaHari.contains('3')
                                        ? const Color(0xFF27AE60)
                                        : const Color(0xFFE28743)
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // // 5. FLOATING ACTION BUTTON (FAB) HIJAU BULAT BESAR
          // Positioned(
          //   bottom: 24,
          //   right: 24,
          //   child: SizedBox(
          //     width: 64,
          //     height: 64,
          //     child: FloatingActionButton(
          //       backgroundColor: primaryGreen,
          //       elevation: 4,
          //       shape: const CircleBorder(),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => const TambahJadwalPage()),
          //         ).then((value) {
          //           if (value == true) refreshData();
          //         });
          //       },
          //       child: const Icon(Icons.add, color: Colors.white, size: 36),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  // Widget Pembantu Pembuat Komponen Kartu Statistik Atas
  Widget _buildStatCard(String title, String count, Color iconColor) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            title == "Jadwal Aktif" 
                ? Icons.calendar_month 
                : title == "Akan Datang" 
                    ? Icons.access_time_filled 
                    : Icons.check_circle_outline, 
            color: iconColor, 
            size: 24
          ),
          const SizedBox(height: 6),
          Text(
            count, 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)
          ),
          const SizedBox(height: 2),
          Text(
            title, 
            style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }
}