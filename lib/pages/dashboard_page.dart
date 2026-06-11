import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Warna utama berdasarkan desain
  final Color primaryGreen = const Color(0xFF27AE60);
  final Color bgColor = const Color(0xFFF2F5F7); // Warna abu-abu terang background

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE DENGAN GRADIENT FADE
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // TODO: Ganti dengan path asset bg dashboard kamu
                  image: AssetImage('assets/images/bgdashboard.jpg'), 
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

          // 2. MAIN CONTENT SCROLLABLE
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER: Logo & Profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // TODO: Ganti dengan path asset logo PNG Petani Pintar kamu
                      Image.asset(
                        'assets/images/petanifont.png', 
                        height: 50,
                        errorBuilder: (context, error, stackTrace) => Text(
                          "🌱 Petani\n     Pintar",
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
                          // TODO: Masukkan asset foto profil
                          backgroundImage: AssetImage('assets/profile.jpg'), 
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // TEKS GREETING
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

                  // WEATHER CARD
                  _buildWeatherCard(),
                  const SizedBox(height: 20),

                  // AKTIVITAS TERAKHIR CARD
                  _buildInfoCard(
                    title: "Aktivitas Terakhir",
                    emptyText: "Belum ada aktivitas terakhir yang\nkamu lakukan",
                  ),
                  const SizedBox(height: 20),

                  // JADWAL & NOTIFIKASI CARD
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
                  
                  // Extra padding di bawah agar tidak tertutup FAB
                  const SizedBox(height: 80), 
                ],
              ),
            ),
          ),
        ],
      ),
      
      // FLOATING ACTION BUTTON (FAB)
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () {
          // Aksi tambah
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // WIDGET: CARD CUACA
  Widget _buildWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        // Gunakan warna solid kebiruan jika asset gambar awan tidak ada
        color: const Color(0xFF4FA8E0),
        image: const DecorationImage(
          // TODO: Ganti dengan background awan jika ada
          image: AssetImage('assets/bg_weather.jpg'), 
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2), // Efek border putih tipis di desain
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cuaca Hari Ini",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 14, 
              fontWeight: FontWeight.w600
            ),
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
                  shadows: [
                    Shadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
                  ]
                ),
              ),
              // Icon matahari dan awan (menggunakan icon standar)
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

  // WIDGET: ITEM DETAIL CUACA (Kelembapan, Angin, Hujan)
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

  // WIDGET: CARD INFORMASI (Reusable untuk Aktivitas & Jadwal)
  Widget _buildInfoCard({required String title, Widget? leadingIcon, required String emptyText}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
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
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const Spacer(),
              Text(
                "Lihat Semua >",
                style: TextStyle(color: primaryGreen, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            emptyText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[400], 
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // WIDGET: CUSTOM BOTTOM NAVIGATION BAR
  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), 
          topRight: Radius.circular(30)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, "Dashboard", true),
          _buildNavItem(Icons.movie_creation_outlined, "Catatan", false), // Icon mirip clapperboard/catatan
          _buildNavItem(Icons.calendar_today_rounded, "Jadwal", false),
          _buildNavItem(Icons.lightbulb_outline, "Tips", false),
          _buildNavItem(Icons.person_outline, "Profil", false),
        ],
      ),
    );
  }

  // WIDGET: ITEM BOTTOM NAVIGATION
  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    final color = isSelected ? primaryGreen : Colors.grey[400]!;
    return Column(
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
    );
  }
}