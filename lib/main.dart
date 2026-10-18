import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Registrasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RegisterPage(),
    );
  }
}

// Halaman registrasi memakai StatefulWidget
// karena ada data yang berubah (radio, dropdown, checkbox)
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Kunci untuk mengakses dan memvalidasi Form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil teks dari TextFormField
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // FocusNode untuk memindahkan fokus antar field
  final _namaFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  // Data pilihan
  String _gender = 'Laki-laki';
  String _prodi = 'Teknik Informatika';
  bool _setuju = false;

  final List<String> _listProdi = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Manajemen',
  ];

  // Bersihkan controller dan focus node saat halaman ditutup
  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _namaFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // Dipanggil saat tombol Daftar ditekan
  void _daftar() {
    // 1. Cek validasi semua field
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Cek checkbox syarat & ketentuan
    if (!_setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 3. Semua lolos -> tampilkan dialog konfirmasi
    _tampilkanDialog();
  }

  void _tampilkanDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Data'),
          content: Text(
            'Nama: ${_namaController.text}\n'
                'Email: ${_emailController.text}\n'
                'Password: ${'*' * _passwordController.text.length}\n'
                'Jenis Kelamin: $_gender\n'
                'Program Studi: $_prodi',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pendaftaran berhasil!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Ya, Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Registrasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Nama Lengkap =====
              TextFormField(
                controller: _namaController,
                focusNode: _namaFocus,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                // Tombol "next" -> pindah ke Email
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocus);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ===== Email =====
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                // Tombol "next" -> pindah ke Password
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocus);
                },
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Email harus mengandung @';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ===== Password =====
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ===== Jenis Kelamin (Radio) =====
              const Text('Jenis Kelamin'),
              RadioListTile<String>(
                title: const Text('Laki-laki'),
                value: 'Laki-laki',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Perempuan'),
                value: 'Perempuan',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              const SizedBox(height: 8),

              // ===== Program Studi (DropdownButton) =====
              const Text('Program Studi'),
              DropdownButton<String>(
                value: _prodi,
                isExpanded: true,
                items: _listProdi.map((prodi) {
                  return DropdownMenuItem<String>(
                    value: prodi,
                    child: Text(prodi),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _prodi = value!;
                  });
                },
              ),
              const SizedBox(height: 8),

              // ===== Checkbox Syarat & Ketentuan =====
              CheckboxListTile(
                title: const Text('Saya setuju dengan Syarat & Ketentuan'),
                value: _setuju,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() {
                    _setuju = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // ===== Tombol Daftar =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _daftar,
                  child: const Text('Daftar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}