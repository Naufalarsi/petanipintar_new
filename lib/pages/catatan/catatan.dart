import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;
import '../../database/db_helper.dart'; 
import 'tambah_catatan.dart';
import 'detail_catatan.dart';

class CatatanPage extends StatefulWidget {
  const CatatanPage({Key? key}) : super(key: key);

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  final Color primaryGreen = const Color(0xFF27AE60);
  final Color bgColor = const Color(0xFFF2F5F7);

  // ========================================================
  // 1. STATE MANAGEMENT UNTUK SEARCH & FILTER
  // ========================================================
  List<Map<String, dynamic>> _allCatatan = [];      // Menyimpan SEMUA data asli dari database
  List<Map<String, dynamic>> _filteredCatatan = []; // Menyimpan data yang SUDAH di-filter/dicari
  
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'Semua Aktivitas'; // Default filter

  final List<String> _kategoriAktivitas = [
    'Semua Aktivitas',
    'Penanaman', 
    'Penyiraman', 
    'Pemupukan', 
    'Pengendalian Hama', 
    'Panen'
  ];

  @override
  void initState() {
    super.initState();
    _loadData(); // Ambil data saat halaman dibuka
  }

  // FUNGSI 1: AMBIL DATA DARI DATABASE
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Jangan load db jika di web, karena sqflite tidak support web
    final data = kIsWeb ? <Map<String, dynamic>>[] : await DBHelper.getCatatan();
    
    setState(() {
      _allCatatan = data;
      _filteredCatatan = data; // Awalnya tampilkan semua
      _isLoading = false;
    });
    
    _applyFilter(); // Terapkan filter jika ada state tersimpan
  }

  // FUNGSI 2: LOGIKA PINTAR SEARCH + FILTER (Gak Kerja 2 Kali!)
  void _applyFilter() {
    setState(() {
      _filteredCatatan = _allCatatan.where((item) {
        // Cek Filter Kategori
        bool matchFilter = _selectedFilter == 'Semua Aktivitas' || item['jenis_aktivitas'] == _selectedFilter;
        
        // Cek Pencarian (Search by catatan, lokasi, atau jenis aktivitas)
        String searchLower = _searchQuery.toLowerCase();
        bool matchSearch = _searchQuery.isEmpty || 
            (item['catatan']?.toString().toLowerCase().contains(searchLower) ?? false) ||
            (item['jenis_aktivitas']?.toString().toLowerCase().contains(searchLower) ?? false) ||
            (item['lokasi']?.toString().toLowerCase().contains(searchLower) ?? false);

        // Hanya tampilkan jika KEDUANYA cocok
        return matchFilter && matchSearch;
      }).toList();
    });
  }

  // FUNGSI 3: MEMUNCULKAN BOTTOM SHEET FILTER (Sesuai Desainmu)
  void _showFilterBottomSheet() {
    // Variable sementara agar tampilan di bottom sheet bisa berubah tanpa menutup sheet
    String tempFilter = _selectedFilter; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder( // StatefulBuilder agar setstate di dalam bottom sheet bekerja
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HEADER FILTER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Filter Aktivitas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // LIST PILIHAN FILTER
                  ..._kategoriAktivitas.map((kategori) {
                    bool isSelected = tempFilter == kategori;
                    var style = _getAktivitasStyle(kategori);
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () {
                          setModalState(() {
                            tempFilter = kategori; // Ubah pilihan sementara
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryGreen.withOpacity(0.1) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? primaryGreen : Colors.transparent),
                          ),
                          child: Row(
                            children: [
                              Icon(kategori == 'Semua Aktivitas' ? Icons.list : style['icon'], 
                                   color: isSelected ? primaryGreen : Colors.grey),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(kategori, style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? primaryGreen : Colors.black87,
                                )),
                              ),
                              if (isSelected)
                                Icon(Icons.check_circle, color: primaryGreen),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  
                  const SizedBox(height: 24),
                  
                  // TOMBOL TERAPKAN FILTER
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        // Terapkan filter ke variabel utama, panggil fungsi pintar, lalu tutup
                        setState(() {
                          _selectedFilter = tempFilter;
                        });
                        _applyFilter();
                        Navigator.pop(context);
                      },
                      child: const Text("Terapkan Filter", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  // Fungsi bantuan untuk icon & warna
  Map<String, dynamic> _getAktivitasStyle(String jenis) {
    switch (jenis) {
      case 'Penanaman': return {'icon': Icons.grass, 'color': Colors.green};
      case 'Penyiraman': return {'icon': Icons.water_drop, 'color': const Color(0xFF4A90E2)};
      case 'Pemupukan': return {'icon': Icons.eco, 'color': const Color(0xFF27AE60)};
      case 'Pengendalian Hama': return {'icon': Icons.bug_report, 'color': const Color(0xFFE57373)};
      case 'Panen': return {'icon': Icons.gavel, 'color': Colors.orange}; 
      default: return {'icon': Icons.assignment, 'color': Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Jika database benar-benar kosong (Belum ada catatan sama sekali)
    if (_allCatatan.isEmpty) {
      return _buildBlankState(context);
    }

    // Jika sudah ada data, tampilkan layar dengan fitur search & filter
    return _buildListState(context); 
  }

  // =======================================================================
  // LAYAR 1: TAMPILKAN KONDISI BLANK
  // =======================================================================
  Widget _buildBlankState(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        title: const Text("Tambah Harian", style: TextStyle(color: Color(0xFF27AE60), fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/clipboard.png', height: 220, errorBuilder: (c, e, s) => Icon(Icons.assignment, size: 150, color: Colors.grey[300])),
            const SizedBox(height: 32),
            Text("Belum ada catatan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: primaryGreen)),
            const SizedBox(height: 12),
            Text("Mulai catat setiap aktivitas\npertanianmu untuk hasil panen\nyang lebih optimal", textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.4, fontWeight: FontWeight.w500)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahCatatanPage())).then((_) => _loadData());
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 28),
                label: const Text("Tambah Catatan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // =======================================================================
  // LAYAR 3: TAMPILKAN DAFTAR RIWAYAT (DENGAN SEARCH & FILTER)
  // =======================================================================
  Widget _buildListState(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        title: const Text("Catatan Harian", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // KOMPONEN ATAS: SEARCH BAR & FILTER
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          // Memicu pencarian setiap kali huruf diketik
                          onChanged: (value) {
                            _searchQuery = value;
                            _applyFilter();
                          },
                          decoration: const InputDecoration(
                            hintText: "Cari Aktivitas",
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // TOMBOL CORONG FILTER
                    InkWell(
                      onTap: _showFilterBottomSheet, // Panggil Bottom Sheet saat diklik
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedFilter != 'Semua Aktivitas' ? primaryGreen : Colors.grey.shade100, 
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Icon(Icons.tune, color: _selectedFilter != 'Semua Aktivitas' ? Colors.white : Colors.grey),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                // PILIHAN FILTER DROPDOWN MINI (Dibuat otomatis update labelnya)
                Row(
                  children: [
                    _buildMiniDropdown(_selectedFilter, onTap: _showFilterBottomSheet),
                    const SizedBox(width: 10),
                    _buildMiniDropdown("Bulan Ini"), // Placeholder untuk filter bulan jika diperlukan nanti
                  ],
                ),
              ],
            ),
          ),

          // CARD SUMMARY RINGKASAN
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.analytics_outlined, color: primaryGreen, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedFilter == 'Semua Aktivitas' ? "Ringkasan Bulan Ini" : "Insight: $_selectedFilter", 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)
                        ),
                        const SizedBox(height: 2),
                        Text("${_filteredCatatan.length} Aktivitas ditemukan", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: primaryGreen)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // LIST DATA AKTIVITAS HASIL FILTER
          Expanded(
            child: _filteredCatatan.isEmpty 
              ? Center(
                  child: Text("Tidak ada aktivitas yang sesuai pencarian.", 
                  style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                )
              : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: _filteredCatatan.length,
              itemBuilder: (context, index) {
                var item = _filteredCatatan[index];
                var style = _getAktivitasStyle(item['jenis_aktivitas'] ?? '');

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell( 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailCatatanPage(catatanData: item)),
                      ).then((value) {
                        if (value == true) _loadData(); // Load data lagi jika kembali dari hapus/edit
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: style['color'].withOpacity(0.1), shape: BoxShape.circle),
                            child: Icon(style['icon'], color: style['color'], size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['jenis_aktivitas'] ?? 'Aktivitas', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 2),
                                Text(item['catatan'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                                const SizedBox(height: 2),
                                Text(item['lokasi'] ?? '', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey.shade400)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(item['waktu'] ?? '', style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(item['tanggal'] ?? '', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen, elevation: 4, shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahCatatanPage())).then((_) => _loadData());
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  // WIDGET BANTUAN: PILIHAN FILTER MINI (Bisa di-klik)
  Widget _buildMiniDropdown(String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}