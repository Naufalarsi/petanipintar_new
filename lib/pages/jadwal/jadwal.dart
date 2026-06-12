import 'package:flutter/material.dart';
import '../catatan/catatan.dart';
import '../catatan/tambah_catatan.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Warna utama berdasarkan desain
  final Color primaryGreen = const Color(0xFF27AE60);
  final Color bgColor = const Color(0xFFF2F5F7);

  // 1. VARIABLE UNTUK MENYIMPAN HALAMAN YANG AKTIF
  int _selectedIndex = 0;

  // 2. FUNGSI UNTUK MENAMPILKAN PILIHAN SAAT TOMBOL + DITEKAN
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TambahCatatanPage()), 
                  );
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
    // 3. DAFTAR HALAMAN BERDASARKAN MENU YANG DIKLIK
    final List<Widget> pages = [
      _buildDashboardHome(), // Index 0: Dashboard
      const CatatanPage(),   // Index 1: Halaman Catatan
      const JadwalContent(), // Index 2: Halaman Jadwal (Widget Baru di bawah)
      const Center(child: Text("Halaman Tips")),   // Index 3
      const Center(child: Text("Halaman Profil")), // Index 4
    ];

    return Scaffold(
      backgroundColor: bgColor,
      // 4. MENGGUNAKAN INDEXED STACK AGAR BISA GANTI HALAMAN TANPA BERAT
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      
      // FLOATING ACTION BUTTON (FAB)
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
      
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // =======================================================================
  // WIDGET DASHBOARD HOME
  // =======================================================================
  Widget _buildDashboardHome() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
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
                  colors: [
                    Colors.transparent,
                    bgColor.withOpacity(0.5),
                    bgColor,
                  ],
                  stops: const [0.4, 0.8, 1.0],
                ),
              ),
            ),
          ),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/petanifont.png', 
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => Text(
                        "🌱 Petani\n    Pintar",
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white, size: 30), 
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  "Selamat pagi, Pak Trio!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Yuk, tingkatkan hasil panen kamu",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),

                _buildWeatherCard(),
                const SizedBox(height: 20),

                _buildInfoCard(
                  title: "Aktivitas Terakhir",
                  emptyText: "Belum ada aktivitas terakhir yang\nkamu lakukan",
                ),
                const SizedBox(height: 20),

                _buildInfoCard(
                  title: "Jadwal & Notifikasi",
                  leadingIcon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.notifications, color: Colors.white, size: 20),
                  ),
                  emptyText: "Belum ada jadwal yang kamu buat",
                ),
                
                const SizedBox(height: 80), 
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF4FA8E0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cuaca Hari Ini",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "27 °C",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  shadows: [Shadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))]
                ),
              ),
              Icon(Icons.cloud, color: Colors.yellow[600], size: 70), 
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWeatherDetail(Icons.water_drop, "Kelembapan", "70%", Colors.lightBlueAccent),
              _buildWeatherDetail(Icons.air, "Angin", "12 km/jam", Colors.white),
              _buildWeatherDetail(Icons.cloudy_snowing, "Hujan", "10%", Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({required String title, Widget? leadingIcon, required String emptyText}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (leadingIcon != null) ...[
                leadingIcon,
                const SizedBox(width: 12),
              ],
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
              const Spacer(),
              Text("Lihat Semua >", style: TextStyle(color: primaryGreen, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            emptyText,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, "Dashboard", 0),
          _buildNavItem(Icons.assignment_outlined, "Catatan", 1), 
          _buildNavItem(Icons.calendar_month, "Jadwal", 2),
          _buildNavItem(Icons.lightbulb_outline, "Tips", 3),
          _buildNavItem(Icons.person_outline, "Profil", 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    final color = isSelected ? primaryGreen : Colors.grey[400]!;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color, 
              fontSize: 12, 
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================================
// WIDGET COMPONENT: HALAMAN JADWAL (MEMBUAT SYSTEM TETAP RINGAN)
// =======================================================================
class JadwalContent extends StatelessWidget {
  const JadwalContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF27AE60); // Disamakan agar selaras
    const Color textGray = Color(0xFF757575);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tambah Jadwal',
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://cdni.iconscout.com/illustration/premium/thumb/calendar-5380549-4497743.png',
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.calendar_month_rounded,
                    size: 150,
                    color: primaryGreen,
                  );
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Belum ada jadwal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Mulai jadwalkan setiap aktivitas pertanianmu untuk hasil panen yang lebih optimal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: textGray,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Masukkan aksi buka form tambah jadwal di sini
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 28),
                  label: const Text(
                    'Tambah Jadwal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600, // Amann dari error semibold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}