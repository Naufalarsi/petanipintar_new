import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF27AE60);
    const Color bgColor = Color(0xFFF2F5F7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // Panah back (leading) sengaja tidak ditambahkan karena ini halaman utama dari Bottom Navbar
        title: const Text(
          'Tips Pertanian',
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HERO BANNER (Tips Hari Ini)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // Gradasi hijau sebagai fallback jika gambar aset belum ada
                gradient: const LinearGradient(
                  colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // TODO: Jika kamu sudah punya gambar padi, aktifkan kodingan image di bawah ini
                /*
                image: const DecorationImage(
                  image: AssetImage('assets/images/bg_padi.jpg'), 
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken), // Efek gelap agar teks terbaca
                ),
                */
                boxShadow: [
                  BoxShadow(
                    color: primaryGreen.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Tips Hari ini",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Rekomendasi otomatis\nberdasarkan kondisi\ncuaca dan aktivitas pertanian\nAnda.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10), // Memberikan ruang ekstra di bawah seperti desain
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. JUDUL SECTION
            const Text(
              "Rekomendasi untuk anda",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // 3. LIST CARD REKOMENDASI TIPS
            _buildTipCard(
              icon: Icons.eco,
              iconBgColor: primaryGreen,
              iconColor: Colors.white,
              title: "Waktu Pemupukan",
              description: "Waktu ideal pemupukkan adalah pagi atau sore hari agar penyerapan lebih optimal",
              onTap: () {
                // TODO: Navigasi ke halaman detail tips pemupukan
                print("Buka detail pemupukan");
              },
            ),
            
            _buildTipCard(
              icon: Icons.cloudy_snowing,
              iconBgColor: Colors.lightBlue.shade50,
              iconColor: Colors.blue,
              title: "Prediksi Hujan",
              description: "Hari ini diprediksi hujan. Disarankan menunda penyiraman tanaman.",
              onTap: () {
                // TODO: Navigasi ke halaman detail cuaca
                print("Buka detail hujan");
              },
            ),
            
            _buildTipCard(
              icon: Icons.wb_sunny,
              iconBgColor: Colors.orange.shade50,
              iconColor: Colors.orange,
              title: "Cuaca Panas",
              description: "Suhu mencapai 32 C. lakukan penyiraman tambahan pada sore hari.",
              onTap: () {
                // TODO: Navigasi ke halaman detail suhu panas
                print("Buka detail panas");
              },
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET BANTUAN: CARD REKOMENDASI
  Widget _buildTipCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Kotak Ikon Kiri
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 30),
              ),
              const SizedBox(width: 16),
              
              // Teks Tengah (Judul & Deskripsi)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // Ikon Panah Kanan
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF27AE60), // Hijau panah
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}