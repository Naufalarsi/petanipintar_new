import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Untuk cek platform web
import 'dart:io' as io; // Untuk handle file di mobile
import 'package:image_picker/image_picker.dart'; // Import package image_picker
import '../../database/db_helper.dart'; // Pastikan path ini benar mengarah ke db_helper.dart

class TambahCatatanPage extends StatefulWidget {
  // Parameter ini menentukan apakah halaman dibuka untuk MENAMBAH atau MENGEDIT
  final Map<String, dynamic>? catatanUntukEdit; 

  const TambahCatatanPage({Key? key, this.catatanUntukEdit}) : super(key: key);

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final Color primaryGreen = const Color(0xFF27AE60);

  // CONTROLLER INPUTAN TEKS
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();       
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _detailCatatanController = TextEditingController(); 

  // VARIABLE UNTUK IMAGE PICKER
  XFile? _imageFile; // Menyimpan file gambar yang dipilih
  final ImagePicker _picker = ImagePicker(); // Instance dari ImagePicker

  // VARIABLE DROPDOWN AKTIVITAS
  String? _selectedAktivitas = 'Pemupukan'; 
  final List<String> _listAktivitas = [
    'Penanaman', 
    'Penyiraman', 
    'Pemupukan', 
    'Pengendalian Hama', 
    'Panen'
  ];

  @override
  void initState() {
    super.initState();
    // JIKA DALAM MODE EDIT: Isi otomatis semua form dengan data lama yang dikirimkan
    if (widget.catatanUntukEdit != null) {
      var dataLama = widget.catatanUntukEdit!;
      _tanggalController.text = dataLama['tanggal'] ?? '';
      _waktuController.text = dataLama['waktu'] ?? '';
      
      // Pastikan jenis aktivitas yang lama ada di dalam daftar list pilihan
      if (_listAktivitas.contains(dataLama['jenis_aktivitas'])) {
        _selectedAktivitas = dataLama['jenis_aktivitas'];
      }
      
      _catatanController.text = dataLama['catatan'] ?? '';
      _lokasiController.text = dataLama['lokasi'] ?? '';
      _detailCatatanController.text = dataLama['detail_catatan'] ?? '';
      
      if (dataLama['foto'] != null && dataLama['foto'].toString().isNotEmpty) {
        _imageFile = XFile(dataLama['foto']);
      }
    }
  }

  // Fungsi untuk memunculkan pemilih kamera / galeri
  Future<void> _ambilFoto() async {
    // Kamu bisa mengganti ImageSource.gallery menjadi ImageSource.camera jika ingin langsung buka kamera
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, 
      maxWidth: 1080, // Membatasi resolusi agar ukuran file tidak terlalu bengkak di database
      maxHeight: 1080,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  // Fungsi untuk memunculkan pemilih Tanggal kalender
  Future<void> _pilihTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  // Fungsi untuk memunculkan pemilih Waktu jam
  Future<void> _pilihWaktu() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _waktuController.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  // Fungsi Utama Menyimpan atau Memperbarui Data ke SQLite
  Future<void> _simpanData() async {
    // Validasi pencegahan error: Jangan biarkan form penting kosong
    if (_tanggalController.text.isEmpty || _catatanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal dan Judul Catatan harus diisi!')),
      );
      return;
    }

    // Bungkus semua inputan ke dalam Map untuk dikirim ke SQLite
    Map<String, dynamic> dataCatatan = {
      'jenis_aktivitas': _selectedAktivitas,
      'catatan': _catatanController.text,
      'detail_catatan': _detailCatatanController.text,
      'lokasi': _lokasiController.text,
      'tanggal': _tanggalController.text, 
      'waktu': _waktuController.text,
      'foto': _imageFile != null ? _imageFile!.path : '', 
      'created_at': widget.catatanUntukEdit != null 
          ? widget.catatanUntukEdit!['created_at'] // Jika edit, pertahankan tanggal buat aslinya
          : DateTime.now().toString(),
    };

    // LOGIKA PERCABANGAN: Simpan Baru ATAU Update Lama
    if (widget.catatanUntukEdit != null) {
      // PROSES EDIT DATA
      int idCatatan = widget.catatanUntukEdit!['id_catatan'];
      await DBHelper.updateCatatan(idCatatan, dataCatatan);
      
      // Suntikkan kembali ID ke dalam map data untuk dikembalikan ke layar Detail
      dataCatatan['id_catatan'] = idCatatan;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan berhasil diperbarui!'), backgroundColor: Colors.green),
        );
        // Kembali ke layar Detail membawa data yang baru saja di-update
        Navigator.pop(context, dataCatatan); 
      }
    } else {
      // PROSES TAMBAH DATA BARU
      await DBHelper.insertCatatan(dataCatatan);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan berhasil disimpan!'), backgroundColor: Colors.green),
        );
        // Kembali ke layar Daftar Catatan
        Navigator.pop(context);
      }
    }
  }

  // WIDGET BANTUAN: Label Teks Form
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
    );
  }

  // WIDGET BANTUAN: Kotak Input Teks
  Widget _buildTextField({required TextEditingController controller, String? hintText, int maxLines = 1, int? maxLength, bool readOnly = false, VoidCallback? onTap}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryGreen)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan judul halaman berdasarkan Mode (Edit / Tambah)
    bool isEditMode = widget.catatanUntukEdit != null;
    String appBarTitle = isEditMode ? "Edit Catatan" : "Tambah Catatan";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: primaryGreen, size: 28), onPressed: () => Navigator.pop(context)),
        title: Text(appBarTitle, style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. INPUT TANGGAL & WAKTU
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Tanggal"),
                      _buildTextField(controller: _tanggalController, hintText: "Pilih Tanggal", readOnly: true, onTap: _pilihTanggal),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Waktu"),
                      _buildTextField(controller: _waktuController, hintText: "Pilih Waktu", readOnly: true, onTap: _pilihWaktu),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. INPUT AKTIVITAS (Dropdown)
            _buildLabel("Aktivitas"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAktivitas,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  items: _listAktivitas.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                            child: const Icon(Icons.eco, color: Colors.white, size: 16), 
                          ),
                          const SizedBox(width: 12),
                          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAktivitas = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. INPUT CATATAN SINGKAT
            _buildLabel("Catatan"),
            _buildTextField(controller: _catatanController, hintText: "Misal: Urea 50 kg/ha"),
            const SizedBox(height: 20),

            // 4. INPUT LOKASI
            _buildLabel("Lokasi"),
            _buildTextField(controller: _lokasiController, hintText: "Misal: Sawah Blok B"),
            const SizedBox(height: 20),

            // 5. INPUT DETAIL CATATAN (Teks Panjang)
            _buildLabel("Detail Catatan"),
            _buildTextField(controller: _detailCatatanController, hintText: "Ceritakan detail aktivitasmu di sini...", maxLines: 4, maxLength: 200),
            const SizedBox(height: 20),

            // 6. INPUT FOTO
            _buildLabel("Foto"),
            Row(
              children: [
                InkWell(
                  onTap: _ambilFoto, 
                  child: Container(
                    height: 80, width: 120,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, color: primaryGreen, size: 32),
                        const SizedBox(height: 4),
                        Text(isEditMode ? "Ganti Foto" : "Tambah Foto", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 80, width: 120, color: Colors.grey.shade200,
                    // Logika render foto Web vs Mobile
                    child: _imageFile == null
                        ? const Icon(Icons.image, color: Colors.grey, size: 40)
                        : kIsWeb
                            ? Image.network(_imageFile!.path, fit: BoxFit.cover, width: 120, height: 80)
                            : Image.file(io.File(_imageFile!.path), fit: BoxFit.cover, width: 120, height: 80),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 7. TOMBOL SIMPAN / UPDATE
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: _simpanData, 
                child: Text(
                  isEditMode ? "Simpan Perubahan" : "Simpan Catatan", 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}