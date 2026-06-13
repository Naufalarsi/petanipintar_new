import 'package:flutter/material.dart';
import 'profil_saya.dart';
import 'lahan.dart';
import 'pengaturan.dart';
import 'bantuan.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

// Fungsi memunculkan pop-up konfirmasi keluar
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Keluar Akun", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi Petani Pintar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Batal", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              // TODO: Aksi hapus session & kembali ke halaman Login/Welcome
              print("Proses Logout...");
            },
            child: const Text("Ya, Keluar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menyesuaikan warna agar seragam dengan halaman lainnya
    final Color primaryGreen = const Color(0xFF27AE60);
    final Color bgColor = const Color(0xFFF2F5F7); 

    return Scaffold(
      backgroundColor: primaryGreen, // Warna dasar paling belakang adalah hijau
      body: SafeArea(
        bottom: false, // Membiarkan warna putih bablas sampai ke paling bawah layar
        child: Column(
          children: [
            // ==========================================
            // BAGIAN 1: HEADER HIJAU (APPBAR & INFO USER)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 28), // Penyeimbang agar teks Profil benar-benar di tengah
                  const Text(
                    "Profil",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      // TODO: Aksi buka notifikasi
                    },
                    child: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // FOTO PROFIL & IDENTITAS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  // Lingkaran Foto Profil
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      // Placeholder gambar petani (Bisa diganti AssetImage kalau kamu punya file lokalnya)
                      backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/4825/4825038.png'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Teks Identitas
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Trio Sudarso",
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Petani",
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.location_on_outlined, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              "Bandar Lampung. Lampung",
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32), // Jarak sebelum lengkungan putih

            // ==========================================
            // BAGIAN 2: BODY PUTIH LENGKUNG & MENU BAWAH
            // ==========================================
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none, // Mengizinkan elemen keluar dari batas (untuk efek numpuk)
                  children: [
                    // A. DAFTAR MENU (Bisa di-scroll)
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: 130, // Memberi ruang kosong di atas agar tidak tertutup kartu ringkasan
                        left: 24,
                        right: 24,
                        bottom: 40,
                      ),
                      child: Column(
                        children: [
                          _buildMenuCard(
                            icon: Icons.person_outline,
                            title: "Profil Saya",
                            subtitle: "Lihat dan edit Informasi pribadi",
                            iconColor: primaryGreen,
                            onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ProfilSayaPage()),
                                    );
                                  },
                          ),
                          _buildMenuCard(
                            icon: Icons.grid_on_outlined, // Icon jaring-jaring mirip lahan
                            title: "Lahan Saya",
                            subtitle: "Kelola data lahan yang dimiliki",
                            iconColor: primaryGreen,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LahanPage()),
                              );
                            },
                          ),
                          _buildMenuCard(
                            icon: Icons.settings_outlined,
                            title: "Pengaturan",
                            subtitle: "Notifikasi, bahasa, dan lainnya",
                            iconColor: primaryGreen,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PengaturanPage()));
                            },
                          ),
                          _buildMenuCard(
                            icon: Icons.help_outline,
                            title: "Bantuan & Panduan",
                            subtitle: "Pusat bantuan dan cara penggunaan",
                            iconColor: primaryGreen,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const BantuanPage()));
                            },
                          ),
                          _buildMenuCard(
                            icon: Icons.logout,
                            title: "Keluar",
                            subtitle: "Keluar dari akun anda",
                            iconColor: Colors.red,
                            titleColor: Colors.red,
                            onTap: () {
                              _showLogoutDialog(context); // Panggil fungsi pop-up
                            },
                          ),                        ],
                      ),
                    ),

                    // B. KARTU "RINGKASAN AKTIVITAS" YANG MENUMPUK (OVERLAP)
                    Positioned(
                      top: -40, // Ditarik ke atas sebanyak 40 pixel menabrak area hijau
                      left: 24,
                      right: 24,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ringkasan Aktivitas",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(icon: Icons.menu_book_outlined, value: "128", label: "Catatan", color: primaryGreen),
                                _buildStatItem(icon: Icons.calendar_today_outlined, value: "23", label: "Jadwal", color: primaryGreen),
                                _buildStatItem(icon: Icons.grid_on_outlined, value: "8", label: "Lahan", color: primaryGreen),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET BANTUAN 1: ITEM ANGKA STATISTIK (CATATAN, JADWAL, LAHAN)
  Widget _buildStatItem({required IconData icon, required String value, required String label, required Color color}) {
    return Column(
      children: [
        Icon(icon, color: color, size: 36),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // WIDGET BANTUAN 2: DESAIN KARTU MENU PANJANG
  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    Color titleColor = Colors.black87,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: titleColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}