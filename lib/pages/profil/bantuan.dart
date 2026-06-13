import 'package:flutter/material.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF27AE60);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Bantuan & Panduan", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.headset_mic_outlined, color: primaryGreen, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Butuh Bantuan Langsung?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text("Hubungi penyuluh pertanian via WhatsApp", style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text("Pertanyaan yang Sering Diajukan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 12),
          
          _buildFAQItem("Bagaimana cara menambah catatan?", "Pergi ke menu Dashboard atau Catatan, lalu klik tombol '+' hijau di pojok kanan bawah. Isi form aktivitas lalu tekan simpan."),
          _buildFAQItem("Apakah aplikasi ini butuh internet?", "Aplikasi bisa digunakan untuk mencatat secara offline (tanpa internet). Namun, fitur ramalan cuaca dan tips terbaru memerlukan koneksi internet."),
          _buildFAQItem("Bagaimana cara mengubah profil?", "Masuk ke menu Profil di navigasi bawah, klik 'Profil Saya', lalu pilih tombol 'Edit Profil'."),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: TextStyle(color: Colors.grey.shade600, height: 1.4, fontSize: 13)),
          )
        ],
      ),
    );
  }
}