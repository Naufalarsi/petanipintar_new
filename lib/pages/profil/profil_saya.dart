import 'package:flutter/material.dart';
import 'edit_profil.dart';

class ProfilSayaPage extends StatelessWidget {
  const ProfilSayaPage({Key? key}) : super(key: key);

  final Color primaryGreen = const Color(0xFF27AE60);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen, size: 28),
          onPressed: () => Navigator.pop(context), // Aksi kembali ke menu utama
        ),
        title: Text(
          "Profil Saya",
          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: primaryGreen, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 1. FOTO PROFIL & NAMA
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryGreen, width: 2)),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/4825/4825038.png'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Trio Sudarso", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(width: 8),
                      Icon(Icons.edit_outlined, size: 20, color: Colors.grey.shade600),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text("Petani", style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. LIST INFORMASI
            _buildInfoItem(icon: Icons.person_outline, title: "Nama Lengkap", value: "Trio Sudarso"),
            const Divider(height: 24),
            _buildInfoItem(icon: Icons.phone_outlined, title: "Nomor Telepon", value: "0858 4298 7774"),
            const Divider(height: 24),
            _buildInfoItem(icon: Icons.email_outlined, title: "Email", value: "trio.sudarso@gmail.com"),
            const Divider(height: 24),
            _buildInfoItem(icon: Icons.location_on_outlined, title: "Lokasi", value: "Bandar Lampung, Lampung"),
            const Divider(height: 24),
            _buildInfoItem(icon: Icons.calendar_today_outlined, title: "Tanggal Bergabung", value: "18 Mei 2026"),
            const SizedBox(height: 32),

            // 3. CARD TENTANG SAYA & TOMBOL EDIT
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9), // Warna hijau sangat muda (light green)
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tentang Saya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                      Icon(Icons.edit_outlined, size: 20, color: primaryGreen),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Saya Petani Padi yang ingin meningkatkan hasil panen.",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfilPage()),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                      label: const Text("Edit Profil", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET BANTUAN UNTUK BARIS INFORMASI
  Widget _buildInfoItem({required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Icon(icon, color: primaryGreen, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ],
    );
  }
}