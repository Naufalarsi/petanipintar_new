import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bgutama.png"), // ganti sesuai file kamu
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Judul
                const Text(
                  "Selamat Datang Petaniku",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 23, 115, 27),
                  ),
                ),
                const SizedBox(height: 25),

                // Logo Petani Pintar (di luar container putih)
                Image.asset(
                  "assets/images/appicon.png",
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 5),

                // Container putih untuk form & tombol
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Field Email (abu-abu muda)
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Field Password (abu-abu muda)
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tombol Masuk (hijau)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/dashboard');
                          },
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Link Daftar Akun Baru & Lupa Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text("Daftar Akun Baru"),
                          ),
                          TextButton(
                            onPressed: () {
                              // aksi lupa password
                            },
                            child: const Text("Lupa Password?"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Divider teks
                      const Text("atau masuk dengan"),
                      const SizedBox(height: 10),

                      // Tombol Google (putih dengan border merah)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Image.asset(
                            "assets/images/google.png", // logo Google
                            width: 24,
                            height: 24,
                          ),
                          label: const Text("Masuk dengan Google"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            // aksi login Google
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Footer
                    ],
                  ),
                ),
                // // const SizedBox(height: 17),
                // Image.asset(
                // "assets/images/iconapp.png", // ganti sesuai file logo kamu
                // width: 175,
                // height: 175,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// 