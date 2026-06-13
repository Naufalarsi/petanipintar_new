import 'package:flutter/material.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({Key? key}) : super(key: key);

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final Color primaryGreen = const Color(0xFF27AE60);
  
  // State untuk toggle button
  bool _notifikasiAktif = true;
  bool _suaraAktif = true;

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
        title: Text("Pengaturan", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          const Text("Notifikasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeColor: primaryGreen,
            title: const Text("Notifikasi Jadwal & Cuaca", style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text("Beritahu saya saat ada peringatan cuaca"),
            value: _notifikasiAktif,
            onChanged: (bool value) {
              setState(() => _notifikasiAktif = value);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeColor: primaryGreen,
            title: const Text("Suara Aplikasi", style: TextStyle(fontWeight: FontWeight.w500)),
            value: _suaraAktif,
            onChanged: (bool value) {
              setState(() => _suaraAktif = value);
            },
          ),
          const Divider(height: 32),
          
          const Text("Umum", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Bahasa", style: TextStyle(fontWeight: FontWeight.w500)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Indonesia", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Kebijakan Privasi", style: TextStyle(fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}