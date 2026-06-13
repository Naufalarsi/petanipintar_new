import 'package:flutter/material.dart';
import '../../database/db_helper.dart'; // Pastikan path db_helper sudah sesuai

class TambahJadwalPage extends StatefulWidget {
  // Parameter untuk handle mode TAMBAH atau EDIT jadwal
  final Map<String, dynamic>? jadwalUntukEdit;

  const TambahJadwalPage({Key? key, this.jadwalUntukEdit}) : super(key: key);

  @override
  State<TambahJadwalPage> createState() => _TambahJadwalPageState();
}

class _TambahJadwalPageState extends State<TambahJadwalPage> {
  final Color primaryGreen = const Color(0xFF27AE60);

  // CONTROLLER INPUTAN TEKS
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _detailCatatanController = TextEditingController();

  // VARIABLE DROPDOWN AKTIVITAS
  String? _selectedAktivitas = 'Pemupukan';
  final List<String> _listAktivitas = [
    'Penanaman',
    'Penyiraman',
    'Pemupukan',
    'Pengendalian Hama',
    'Panen'
  ];

  // VARIABEL LOKAL UNTUK TAMPILAN PENGULANGAN (Tidak masuk ke DB karena tidak ada kolomnya)
  String _selectedPengulangan = 'Jangan ulangi';

  @override
  void initState() {
    super.initState();
    // JIKA DALAM MODE EDIT: Isi form otomatis dengan data lama dari database
    if (widget.jadwalUntukEdit != null) {
      var dataLama = widget.jadwalUntukEdit!;
      _tanggalController.text = dataLama['tanggal'] ?? '';
      _waktuController.text = dataLama['waktu'] ?? '';
      
      if (_listAktivitas.contains(dataLama['jenis_aktivitas'])) {
        _selectedAktivitas = dataLama['jenis_aktivitas'];
      }
      
      _catatanController.text = dataLama['catatan'] ?? '';
      _lokasiController.text = dataLama['lokasi'] ?? '';
      _detailCatatanController.text = dataLama['detail_catatan'] ?? '';
    }
  }

  // Fungsi Pemilih Tanggal Kalender
  Future<void> _pilihTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        List<String> banyuanBulan = [
          'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ];
        _tanggalController.text = "${picked.day} ${banyuanBulan[picked.month - 1]} ${picked.year}";
      });
    }
  }

  // Fungsi Pemilih Waktu Jam
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

  // Fungsi Aksi Klik Pengulangan (Hanya UI BottomSheet)
  void _pilihPengulangan() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        List<String> opsi = ['Jangan ulangi', 'Setiap hari', 'Setiap minggu', 'Setiap bulan'];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: opsi.map((String value) {
              return ListTile(
                title: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  setState(() {
                    _selectedPengulangan = value;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          );
        },
      );
    }
  
    // Fungsi Simpan ke SQLite (Menyesuaikan dengan kolom tabel Jadwal di DBHelper)
  Future<void> _simpanJadwal() async {
    if (_tanggalController.text.isEmpty || _catatanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal dan Judul Catatan Jadwal wajib diisi!')),
      );
      return;
    }
  
    Map<String, dynamic> dataJadwal = {
      'id_user': 1, 
      'jenis_aktivitas': _selectedAktivitas,
      'catatan': _catatanController.text,
      'detail_catatan': _detailCatatanController.text,
      'lokasi': _lokasiController.text,
      'tanggal': _tanggalController.text,
      'waktu': _waktuController.text,
      'status': widget.jadwalUntukEdit != null 
          ? widget.jadwalUntukEdit!['status'] 
          : 'Belum Selesai', 
      'created_at': widget.jadwalUntukEdit != null 
          ? widget.jadwalUntukEdit!['created_at'] 
          : DateTime.now().toString(),
    };
  
    // Tampilkan loading dialog sederhana agar user tahu proses sedang berjalan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  
    try {
      if (widget.jadwalUntukEdit != null) {
        int idJadwal = widget.jadwalUntukEdit!['id_jadwal'];
        await DBHelper.updateJadwal(idJadwal, dataJadwal); 
      } else {
        await DBHelper.insertJadwal(dataJadwal);
      }
  
      // Tutup loading dialog
      if (mounted) Navigator.pop(context);
  
      // Beri jeda 100 milidetik agar thread database selesai memproses data sepenuhnya
      await Future.delayed(const Duration(milliseconds: 100));
  
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.jadwalUntukEdit != null ? 'Jadwal berhasil diperbarui!' : 'Jadwal berhasil dijadwalkan!'), 
            backgroundColor: Colors.green
          ),
        );
        Navigator.pop(context, true); // Kembali ke halaman utama dengan membawa sinyal refresh
      }
    } catch (e) {
      // Tutup loading dialog jika error
      if (mounted) Navigator.pop(context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal operasi database: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // WIDGET BANTUAN: Label Form
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        text, 
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black)
      ),
    );
  }

  // WIDGET BANTUAN: Input Text Field
  Widget _buildTextField({
    required TextEditingController controller, 
    String? hintText, 
    int maxLines = 1, 
    int? maxLength, 
    bool readOnly = false, 
    VoidCallback? onTap,
    Widget? prefixIcon
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        counterText: "", 
        hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.w400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: primaryGreen, width: 1.5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEditMode = widget.jadwalUntukEdit != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen, size: 28), 
          onPressed: () => Navigator.pop(context)
        ),
        title: Text(
          isEditMode ? "Edit Jadwal" : "Tambah Jadwal", 
          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. JENIS AKTIVITAS
            _buildLabel("Jenis Aktivitas"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200, width: 1.5), 
                borderRadius: BorderRadius.circular(14)
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAktivitas,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 28),
                  items: _listAktivitas.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                            child: const Icon(Icons.eco, color: Colors.white, size: 14), 
                          ),
                          const SizedBox(width: 12),
                          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
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

            // 2. CATATAN
            _buildLabel("Catatan"),
            _buildTextField(controller: _catatanController, hintText: "Misal: Urea 50 kg/ha"),

            // 3. ROW TANGGAL & WAKTU
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Tanggal"),
                      _buildTextField(
                        controller: _tanggalController, 
                        hintText: "Pilih Tanggal", 
                        readOnly: true, 
                        onTap: _pilihTanggal,
                        prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Waktu"),
                      _buildTextField(
                        controller: _waktuController, 
                        hintText: "Pilih Waktu", 
                        readOnly: true, 
                        onTap: _pilihWaktu,
                        prefixIcon: const Icon(Icons.access_time, size: 20, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 4. LOKASI
            _buildLabel("Lokasi"),
            _buildTextField(
              controller: _lokasiController, 
              hintText: "Misal: Sawah Blok B",
              prefixIcon: Icon(Icons.location_on, color: primaryGreen, size: 22),
            ),

            // 5. DETAIL CATATAN
            _buildLabel("Detail Catatan"),
            Stack(
              children: [
                _buildTextField(
                  controller: _detailCatatanController, 
                  hintText: "Ceritakan detail aktivitasmu di sini...", 
                  maxLines: 4, 
                  maxLength: 200
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _detailCatatanController,
                    builder: (context, value, child) {
                      return Text(
                        "${value.text.length}/200",
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                      );
                    },
                  ),
                ),
              ],
            ),

            // 6. PENGULANGAN
            _buildLabel("Pengulangan"),
            InkWell(
              onTap: _pilihPengulangan,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedPengulangan, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                  ],
                ),
              ),
            ),

            // 7. TOMBOL SIMPAN JADWAL UTAMA
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: _simpanJadwal, 
                child: Text(
                  isEditMode ? "Simpan Perubahan" : "Simpan Jadwal", 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}