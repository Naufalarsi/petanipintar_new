import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Floating Action Button (+) di kanan bawah agak naik
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20), // geser ke atas biar tidak menempel
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            // aksi tambah catatan/jadwal
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Bottom Navigation Bar flat putih (canvas tetap ada)
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // canvas putih
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Dashboard
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.dashboard, color: Colors.green),
                Text("Dashboard", style: TextStyle(fontSize: 12)),
              ],
            ),
            // Catatan
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.note, color: Colors.green),
                Text("Catatan", style: TextStyle(fontSize: 12)),
              ],
            ),
            // Jadwal
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.calendar_today, color: Colors.green),
                Text("Jadwal", style: TextStyle(fontSize: 12)),
              ],
            ),
            // Tips
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.lightbulb, color: Colors.green),
                Text("Tips", style: TextStyle(fontSize: 12)),
              ],
            ),
            // Profil
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.person, color: Colors.green),
                Text("Profil", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sapaan
              const Text(
                "Selamat pagi, Pak Trio!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Yuk, tingkatkan hasil panen kamu 👋",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Card Cuaca
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cuaca Hari Ini",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.wb_sunny, size: 48, color: Colors.orange),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("27°C, Cerah sebagian",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("Kelembapan: 70%", style: TextStyle(color: Colors.black54)),
                              Text("Angin: 12 km/h", style: TextStyle(color: Colors.black54)),
                              Text("Hujan: 10%", style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Panel Aktivitas Terakhir
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.green),
                  title: const Text("Aktivitas Terakhir"),
                  subtitle: const Text("Belum ada aktivitas tercatat"),
                ),
              ),
              const SizedBox(height: 12),

              // Panel Jadwal & Notifikasi
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.green),
                  title: const Text("Jadwal & Notifikasi"),
                  subtitle: const Text("Belum ada jadwal atau notifikasi"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
