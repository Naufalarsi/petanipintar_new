import 'package:flutter/material.dart';

class TambahLahanPage extends StatefulWidget {
  const TambahLahanPage({Key? key}) : super(key: key);

  @override
  State<TambahLahanPage> createState() => _TambahLahanPageState();
}

class _TambahLahanPageState extends State<TambahLahanPage> {
  final Color primaryGreen = const Color(0xFF27AE60);

  // CONTROLLER INPUT FORM
  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _luasController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
        title: Text("Tambah Lahan", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Jenis Lahan"),
            _buildTextField(_jenisController, "Misal: Sawah, Perkebunan, Ladang"),

            _buildLabel("Luas Lahan (Ha)"),
            _buildTextField(_luasController, "Misal: 2.5"),

            _buildLabel("Jumlah Lahan"),
            _buildTextField(_jumlahController, "Misal: 1"),

            const SizedBox(height: 48),

            // TOMBOL SIMPAN DATA FORM
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_jenisController.text.isEmpty || _luasController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Jenis dan Luas Lahan wajib diisi!')),
                    );
                    return;
                  }

                  // Mengirimkan map data kembali ke LahanPage
                  Navigator.pop(context, {
                    'jenis': _jenisController.text,
                    'luas': _luasController.text,
                    'jumlah': _jumlahController.text,
                  });
                },
                child: const Text("Simpan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}