import 'package:flutter/material.dart';
import 'tambah_lahan.dart';

class LahanPage extends StatefulWidget {
  const LahanPage({Key? key}) : super(key: key);

  @override
  State<LahanPage> createState() => _LahanPageState();
}

class _LahanPageState extends State<LahanPage> {
  final Color primaryGreen = const Color(0xFF27AE60);
  final Color bgColor = const Color(0xFFF2F5F7);

  // DATA LOCAL UNTUK MENAMPUNG DAFTAR LAHAN
  List<Map<String, dynamic>> _daftarLahan = [];

  // FUNGSI HITUNG TOTAL LUAS LAHAN SECARA OTOMATIS
  double _hitungTotalLuas() {
    double total = 0.0;
    for (var lahan in _daftarLahan) {
      // Mengubah teks luas (misal "2.5") menjadi angka double untuk dijumlahkan
      String luasClean = lahan['luas'].toString().replaceAll(RegExp(r'[^0-9.]'), '');
      total += double.tryParse(luasClean) ?? 0.0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    bool isKosong = _daftarLahan.isEmpty;
    double totalLuas = _hitungTotalLuas();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Lahan Saya", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ==========================================
          // 1. STATISTIK ATAS (KOTAK HIJAU MUDA)
          // ==========================================
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    value: "${_daftarLahan.length}",
                    label: "Lahan",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatBox(
                    value: totalLuas == 0 ? "0" : totalLuas.toString().replaceAll('.', ','),
                    label: "Total Lahan (Ha)",
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. KONDISI TAMPILAN (KOSONG VS TERISI)
          // ==========================================
          Expanded(
            child: isKosong 
                ? _buildKondisiKosong(context) 
                : _buildKondisiTerisi(context),
          ),
        ],
      ),

      // FLOATING ACTION BUTTON (Hanya muncul jika sudah ada data lahan)
      floatingActionButton: isKosong
          ? null
          : FloatingActionButton(
              backgroundColor: primaryGreen,
              shape: const CircleBorder(),
              onPressed: () => _navigasiKeTambahLahan(context),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
    );
  }

  // WIDGET BANTUAN: KOTAK STATISTIK ATAS
  Widget _buildStatBox({required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // WIDGET BANTUAN: KONDISI JIKA DATA MASIH KOSONG
  Widget _buildKondisiKosong(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.landscape_outlined, size: 120, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          const Text(
            "Belum ada Informasi\nLahan yang Tersimpan",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF27AE60), height: 1.3),
          ),
          const SizedBox(height: 12),
          Text(
            "Tambahkan informasi lahan yang Anda miliki untuk mulai mengelola data pertanian.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500, height: 1.4, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              onPressed: () => _navigasiKeTambahLahan(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Tambah Lahan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  // WIDGET BANTUAN: KONDISI JIKA DATA LAHAN SUDAH ADA
  Widget _buildKondisiTerisi(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const Text(
          "Lahan yang Dimiliki",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _daftarLahan.length,
          itemBuilder: (context, index) {
            var item = _daftarLahan[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['jenis'] ?? 'Lahan', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          "Bandar Lampung, Lampung", // Default lokasi sesuai profil utama
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${item['luas']} Ha",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // FUNGSI NAVIGASI UNTUK MENERIMA DATA BARU DARI FORM TAMBAH
  void _navigasiKeTambahLahan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahLahanPage()),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          _daftarLahan.add(result); // Menambahkan data baru ke dalam list tampilan
        });
      }
    });
  }
}