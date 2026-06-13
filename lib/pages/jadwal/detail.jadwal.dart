import 'package:flutter/material.dart';
import '../../database/db_helper.dart';
// Sesuaikan import ini dengan lokasi file TambahJadwalPage-mu
import 'tambah_jadwal.dart'; 

class DetailJadwalPage extends StatefulWidget {
  final Map<String, dynamic> jadwalData;

  const DetailJadwalPage({Key? key, required this.jadwalData}) : super(key: key);

  @override
  State<DetailJadwalPage> createState() => _DetailJadwalPageState();
}

class _DetailJadwalPageState extends State<DetailJadwalPage> {
  final Color primaryGreen = const Color(0xFF27AE60);
  late Map<String, dynamic> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.jadwalData;
  }

  // Fungsi penentu Ikon & Warna Aktivitas
  Map<String, dynamic> _getStyle(String jenis) {
    switch (jenis) {
      case 'Penyiraman': return {'icon': Icons.water_drop, 'color': const Color(0xFF4A90E2)};
      case 'Pemupukan': return {'icon': Icons.eco, 'color': const Color(0xFF27AE60)};
      case 'Pengendalian Hama': return {'icon': Icons.bug_report, 'color': const Color(0xFFE57373)};
      case 'Penanaman': return {'icon': Icons.grass, 'color': Colors.green};
      case 'Panen': return {'icon': Icons.shopping_basket, 'color': Colors.orange};
      default: return {'icon': Icons.calendar_today, 'color': Colors.grey};
    }
  }

  // Fungsi Aksi Hapus
  void _konfirmasiHapus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Jadwal"),
        content: const Text("Apakah kamu yakin ingin menghapus jadwal aktivitas ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () async {
              await DBHelper.deleteJadwal(_currentData['id_jadwal']);
              if (mounted) {
                Navigator.pop(context); // Tutup Dialog
                Navigator.pop(context, true); // Kembali ke list & refresh
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Fungsi Mengubah Status Jadwal menjadi Selesai
  void _tandaiSelesai() async {
    Map<String, dynamic> updatedStatus = Map.from(_currentData);
    updatedStatus['status'] = 'Selesai';

    await DBHelper.updateJadwal(_currentData['id_jadwal'], updatedStatus);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jadwal telah ditandai selesai!"), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    }
  }

  // Widget Baris Detail Berikon sesuai Mockup Desain
  Widget _buildIconDetailRow(IconData icon, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var style = _getStyle(_currentData['jenis_aktivitas'] ?? '');
    String status = _currentData['status'] ?? 'Aktif';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen, size: 28),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text("Detail Jadwal", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. AVATAR ICON & TITLE
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: style['color'].withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(style['icon'], color: style['color'], size: 54),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentData['jenis_aktivitas'] ?? 'Aktivitas',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  // Badge Status (Aktif / Selesai)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: status == 'Selesai' ? Colors.grey.shade300 : primaryGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. KOTAK INFO DETAIL JADWAL (BERIKON)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildIconDetailRow(Icons.calendar_today_outlined, primaryGreen, "Tanggal", _currentData['tanggal'] ?? '-'),
                  const Divider(),
                  _buildIconDetailRow(Icons.access_time, Colors.green, "Waktu", _currentData['waktu'] ?? '-'),
                  const Divider(),
                  _buildIconDetailRow(Icons.location_on_outlined, Colors.green, "Lokasi", _currentData['lokasi'] ?? '-'),
                  const Divider(),
                  _buildIconDetailRow(Icons.refresh, Colors.green, "Pengulangan", _currentData['pengulangan'] ?? 'Jangan ulangi'),
                  const Divider(),
                  _buildIconDetailRow(Icons.notifications_none, Colors.green, "Pengingat", _currentData['waktu'] ?? '-'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. DESKRIPSI DETAIL CATATAN JADWAL
            const Text("Detail Catatan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 8),
            Text(
              _currentData['detail_catatan'] ?? _currentData['catatan'] ?? 'Tidak ada detail catatan tambahan.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
            ),
            const SizedBox(height: 24),

            // 4. KOTAK KETERANGAN AKAN DATANG (HIJAU MUDA)
            if (status != 'Selesai')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_today, color: primaryGreen, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Akan Datang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text(
                            "Kamu akan diingatkan pada ${_currentData['tanggal'] ?? '-'}, ${_currentData['waktu'] ?? '-'}",
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            const SizedBox(height: 32),

            // 5. BUTTON AKSI (EDIT & HAPUS)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: primaryGreen, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TambahJadwalPage(jadwalUntukEdit: _currentData),
                        ),
                      ).then((updatedData) {
                        if (updatedData != null && updatedData is Map<String, dynamic>) {
                          setState(() {
                            _currentData = updatedData;
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.edit_outlined, color: primaryGreen),
                    label: Text("Edit", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _konfirmasiHapus,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text("Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 6. TOMBOL UTAMA TANDAI SELESAI (Paling Bawah)
            if (status != 'Selesai')
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: _tandaiSelesai,
                  child: const Text(
                    "Tandai Selesai",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}