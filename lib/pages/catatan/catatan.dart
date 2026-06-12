import 'package:flutter/material.dart';

class CatatanPage extends StatefulWidget {
  const CatatanPage({Key? key}) : super(key: key);

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
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
          onPressed: () {
            Navigator.pop(context); // Fungsi kembali ke Dashboard
          },
        ),
        title: const Text(
          "Tambah Harian",
          style: TextStyle(
            color: Color(0xFF27AE60),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar 3D Clipboard
            Image.asset(
              'assets/images/clipboard.png', // TODO: Siapkan aset gambar ini
              height: 220,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.assignment, 
                size: 150, 
                color: Colors.grey[300]
              ),
            ),
            const SizedBox(height: 32),
            
            // Teks Judul
            Text(
              "Belum ada catatan",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 12),
            
            // Teks Deskripsi
            Text(
              "Mulai catat setiap aktivitas\npertanianmu untuk hasil panen\nyang lebih optimal",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            
            // Tombol Tambah Catatan
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // TODO: Aksi untuk membuka form pengisian ke database
                  print("Buka form pengisian catatan");
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 28),
                label: const Text(
                  "Tambah Catatan",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60), // Spasi bawah agar tidak terlalu mentok
          ],
        ),
      ),
    );
  }
}