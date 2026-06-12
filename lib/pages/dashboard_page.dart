import 'package:flutter/material.dart';
import 'package:petanipintar_baru/pages/tips/tips.dart';
import 'catatan/catatan.dart'; 
import 'catatan/tambah_catatan.dart'; 
import '../database/db_helper.dart'; // Import DBHelper agar Dashboard bisa baca SQLite
import 'jadwal/jadwal.dart';
import 'tips/tips.dart'; // Import JadwalPage untuk navigasi dari FAB
import 'jadwal/tambah_jadwal.dart'; // Import TambahJadwalPage untuk navigasi dari FAB  

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Warna utama berdasarkan desain
  final Color primaryGreen = const Color(0xFF27AE60);
  final Color bgColor = const Color(0xFFF2F5F7);

  // 1. VARIABLE UNTUK MENYIMPAN HALAMAN AKTIF & DATA DATABASE
  int _selectedIndex = 0;
  List<Map<String, dynamic>> aktivitasList = [];
  List<Map<String, dynamic>> jadwalList = [];

  @override
  void initState() {
    super.initState();
    _loadData(); // Panggil fungsi ambil data saat Dashboard pertama kali dimuat
  }

  // 2. FUNGSI MENGAMBIL DATA DARI SQLITE
  Future<void> _loadData() async {
    final dataCatatan = await DBHelper.getCatatan();
    
    // (Opsional) Jika jadwal sudah ada nanti, panggil juga DBHelper.getJadwal()
    // final dataJadwal = await DBHelper.getJadwal();

    setState(() {
      // Untuk Dashboard, biasanya kita hanya menampilkan 3-5 aktivitas terbaru
      // Jadi kita batasi dengan .take(3) jika datanya banyak
      aktivitasList = dataCatatan.length > 3 ? dataCatatan.sublist(0, 3) : dataCatatan;
      
      // jadwalList = dataJadwal;
    });
  }

  // 3. FUNGSI BANTUAN UNTUK ICON & WARNA
  Map<String, dynamic> _getAktivitasStyle(String jenis) {
    switch (jenis) {
      case 'Penanaman': return {'icon': Icons.grass, 'color': Colors.green};
      case 'Penyiraman': return {'icon': Icons.water_drop, 'color': const Color(0xFF4A90E2)};
      case 'Pemupukan': return {'icon': Icons.eco, 'color': const Color(0xFF27AE60)};
      case 'Pengendalian Hama': return {'icon': Icons.bug_report, 'color': const Color(0xFFE57373)};
      case 'Panen': return {'icon': Icons.shopping_basket, 'color': Colors.orange};
      default: return {'icon': Icons.assignment, 'color': Colors.grey};
    }
  }

  // 4. FUNGSI UNTUK MENAMPILKAN PILIHAN SAAT TOMBOL + DITEKAN
  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pilih Aksi Tambah",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: primaryGreen.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.assignment, color: primaryGreen),
                ),
                title: const Text("Tambah Catatan Harian", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Catat aktivitas pemupukan, penyiraman, dll."),
                onTap: () {
                  Navigator.pop(context); // Tutup bottom sheet
                  // Pindah ke Form Tambah, dan JIKA KEMBALI, refresh Dashboard
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TambahCatatanPage()),
                  ).then((value) {
                    _loadData(); // Segarkan data SQLite agar otomatis muncul di Dashboard
                  });
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.calendar_today, color: Colors.blue),
                ),
                title: const Text("Tambah Jadwal Kegiatan", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Buat pengingat untuk aktivitas mendatang."),
                onTap: () {
                  Navigator.pop(context);
                  print("Navigasi ke Form Tambah Jadwal");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // DAFTAR HALAMAN BERDASARKAN MENU YANG DIKLIK
    final List<Widget> pages = [
      _buildDashboardHome(), // Index 0: Dashboard Home
      const CatatanPage(),   // Index 1: Halaman Catatan
      const JadwalPage(), // Index 2
      const TipsPage(),   // Index 3
      const Center(child: Text("Halaman Profil")), // Index 4
    ];

    return Scaffold(
      backgroundColor: bgColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () {
          _showAddOptions(context);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // =======================================================================
  // WIDGET DASHBOARD HOME UTAMA
  // =======================================================================
  Widget _buildDashboardHome() {
    return Stack(
      children: [
        // BACKGROUND IMAGE
        Positioned(
          top: 0, left: 0, right: 0,
          height: MediaQuery.of(context).size.height * 0.45,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bgdashboard.png'), 
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, bgColor.withOpacity(0.5), bgColor],
                  stops: const [0.4, 0.8, 1.0],
                ),
              ),
            ),
          ),
        ),

        // MAIN CONTENT SCROLLABLE
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/petanifont.png', 
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => Text(
                        "🌱 Petani\n     Pintar",
                        style: TextStyle(color: primaryGreen, fontSize: 24, fontWeight: FontWeight.bold, height: 1.1),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                      child: const CircleAvatar(
                        radius: 26, backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white, size: 30), 
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // GREETING
                const Text("Selamat pagi, Pak Trio!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 4),
                const Text("Yuk, tingkatkan hasil panen kamu", style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w400)),
                const SizedBox(height: 24),

                // WEATHER CARD
                _buildWeatherCard(),
                const SizedBox(height: 20),

                // AKTIVITAS TERAKHIR CARD (SUDAH DINAMIS)
                _buildInfoCard(
                  title: "Aktivitas Terakhir",
                  isEmpty: aktivitasList.isEmpty,
                  emptyText: "Belum ada aktivitas terakhir yang\nkamu lakukan",
                  content: Column(
                    children: aktivitasList.map((item) {
                      var style = _getAktivitasStyle(item['jenis_aktivitas'] ?? '');
                      
                      return _buildActivityItem(
                        icon: style['icon'],
                        iconColor: Colors.white,
                        iconBgColor: style['color'],
                        title: item['jenis_aktivitas'] ?? 'Aktivitas',
                        subtitle: "${item['catatan']}\n${item['tanggal']}", 
                        status: "Selesai",
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // JADWAL CARD
                _buildInfoCard(
                  title: "Jadwal & Notifikasi",
                  isEmpty: jadwalList.isEmpty,
                  leadingIcon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.notifications, color: Colors.white, size: 20),
                  ),
                  emptyText: "Belum ada jadwal yang kamu buat",
                  content: Column(
                    children: jadwalList.map((item) {
                      return _buildScheduleItem(
                        icon: Icons.calendar_today,
                        title: item['title'] ?? '',
                        subtitle: item['subtitle'] ?? '',
                        date: item['date'] ?? '',
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 80), 
              ],
            ),
          ),
        ),
      ],
    );
  }

  // WIDGET: CARD CUACA
  Widget _buildWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF4FA8E0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.white, width: 2), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Cuaca Hari Ini", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("27 C", style: TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w800, height: 1.1)),
                  const SizedBox(height: 8),
                  const Text("Hari ini cerah,\nwaktu siram ideal", style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w800, height: 1.2)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.water_drop, color: Color(0xFF2980B9), size: 24),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Kelembapan", style: TextStyle(color: Color(0xFF2980B9), fontSize: 13, fontWeight: FontWeight.bold)),
                          Text("70%", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: 10), child: Icon(Icons.cloud, color: Colors.yellow[600], size: 90)), 
            ],
          ),
        ],
      ),
    );
  }

  // WIDGET: CARD INFORMASI DINAMIS (BISA KOSONG BISA ISI)
  Widget _buildInfoCard({required String title, Widget? leadingIcon, required bool isEmpty, required String emptyText, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black87, width: 0.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leadingIcon != null && isEmpty) ...[leadingIcon, const SizedBox(width: 12)],
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
              const Spacer(),
              Text("Lihat Semua >", style: TextStyle(color: primaryGreen, fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 24),
          isEmpty 
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(emptyText, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w500)),
              )
            : content, 
        ],
      ),
    );
  }

  // WIDGET: ITEM LIST AKTIVITAS
  Widget _buildActivityItem({required IconData icon, required Color iconColor, required Color iconBgColor, required String title, required String subtitle, required String status}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                const SizedBox(height: 4),
                // Menggunakan teks dengan warna berbeda untuk bagian tanggal
                Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // WIDGET: ITEM LIST JADWAL
  Widget _buildScheduleItem({required IconData icon, required String title, required String subtitle, required String date}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: primaryGreen, width: 2), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primaryGreen, size: 28)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black87)),
              const SizedBox(height: 2),
              Text(date, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: primaryGreen)),
            ],
          ),
        ),
      ],
    );
  }

  // WIDGET: CUSTOM BOTTOM NAVIGATION BAR
  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, "Dashboard", 0),
          _buildNavItem(Icons.movie_creation_outlined, "Catatan", 1), 
          _buildNavItem(Icons.calendar_today_rounded, "Jadwal", 2),
          _buildNavItem(Icons.lightbulb_outline, "Tips", 3),
          _buildNavItem(Icons.person_outline, "Profil", 4),
        ],
      ),
    );
  }

  // WIDGET: ITEM BOTTOM NAVIGATION
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    final color = isSelected ? primaryGreen : Colors.grey[400]!;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index; 
        });
        
        // JIKA KEMBALI KE TAB DASHBOARD (Index 0), REFRESH DATA!
        if (index == 0) {
          _loadData();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
        ],
      ),
    );
  }
}