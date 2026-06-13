import 'package:flutter/material.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({Key? key}) : super(key: key);

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final Color primaryGreen = const Color(0xFF27AE60);

  // CONTROLLER INPUTAN (Sudah diisi dengan data awal)
  final TextEditingController _namaController = TextEditingController(text: "Trio Sudarso");
  final TextEditingController _teleponController = TextEditingController(text: "0858-4298-7774");
  final TextEditingController _emailController = TextEditingController(text: "trio.sudarso@gmail.com");
  final TextEditingController _alamatController = TextEditingController(text: "Bandar Lampung, Lampung");
  final TextEditingController _luasLahanController = TextEditingController(text: "2.5 Ha");
  final TextEditingController _jenisLahanController = TextEditingController(text: "Sawah");
  final TextEditingController _tentangSayaController = TextEditingController(
      text: "Saya Petani Padi yang ingin meningkatkan hasil panen.");

  String _selectedPeran = 'Petani';

  // WIDGET BANTUAN: Label Teks
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
    );
  }

  // WIDGET BANTUAN: TextField
  Widget _buildTextField(TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryGreen)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Edit Profil", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. FOTO PROFIL DENGAN ICON KAMERA
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryGreen, width: 2)),
                        child: const CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/4825/4825038.png'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFF27AE60), shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text("Klik foto untuk mengganti", style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. FORM INPUT DATA
            _buildLabel("Nama Lengkap"),
            _buildTextField(_namaController),

            _buildLabel("Peran"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPeran,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  items: ['Petani', 'Pengepul', 'Penyuluh'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPeran = newValue!;
                    });
                  },
                ),
              ),
            ),

            _buildLabel("Nomor Telepon"),
            _buildTextField(_teleponController),

            _buildLabel("Email"),
            _buildTextField(_emailController),

            _buildLabel("Alamat"),
            _buildTextField(_alamatController),

            // ROW UNTUK LUAS LAHAN & JENIS LAHAN
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Luas Lahan"),
                      _buildTextField(_luasLahanController),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Jenis Lahan"),
                      _buildTextField(_jenisLahanController),
                    ],
                  ),
                ),
              ],
            ),

            _buildLabel("Tentang Saya"),
            _buildTextField(_tentangSayaController, maxLines: 4),

            const SizedBox(height: 40),

            // 3. TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  // Aksi pura-pura menyimpan dan kembali ke halaman sebelumnya
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save_outlined, color: Colors.white, size: 24),
                label: const Text("Simpan Perubahan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}