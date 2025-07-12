import 'package:absensi_app/api/user_api.dart';
import 'package:absensi_app/models/list_batch.dart';
import 'package:absensi_app/models/list_training.dart';
import 'package:absensi_app/view/auth_page/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String id = "/register_page";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedGender;
  String? _selectedBatchId;
  String? _selectedTrainingId;

  List<Datum> availableTrainings = [];
  bool _isLoadingTrainings = true;

  List<ListBatchResponseData> availableBatch = [];
  bool _isLoadingBatch = true;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchBatch();
    _fetchTrainings();
    _isPasswordVisible = false;
  }

  Future<void> _fetchTrainings() async {
    setState(() {
      _isLoadingTrainings = true;
    });

    try {
      final response = await ApiService().getTrainings();

      setState(() {
        availableTrainings = response.data ?? [];
        _isLoadingTrainings = false;
      });
    } catch (e) {
      print('Error fetching trainings: $e');
      setState(() {
        _isLoadingTrainings = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data training: $e')),
        );
      }
    }
  }

  Future<void> _fetchBatch() async {
    setState(() {
      _isLoadingBatch = true;
    });

    try {
      final response = await ApiService().getBatches();

      setState(() {
        availableBatch = response.data ?? [];
        _isLoadingBatch = false;
      });
    } catch (e) {
      print('Error fetching Batch: $e');
      setState(() {
        _isLoadingBatch = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data batch: $e')));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String? gender = _selectedGender;
      String? batchId = _selectedBatchId;
      String? trainingId = _selectedTrainingId;

      print('Registering with:');
      print('Name: $name');
      print('Email: $email');
      print('Password: $password');
      print('Gender: $gender');
      print('Batch ID: $batchId');
      print('Training ID: $trainingId');

      if (gender == null || batchId == null || trainingId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap lengkapi semua pilihan dropdown.'),
          ),
        );
        return;
      }

      final response = await ApiService().register(
        name: name,
        email: email,
        jenisKelamin: gender,
        batchId: batchId,
        trainingId: trainingId,
        password: password,
        profilePhotoBase64: null,
      );

      print('API Response: $response');
      print('API Message: ${response?.message}');

      if (response?.data != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response?.message ?? 'Registrasi Berhasil!'),
            ),
          );
          Navigator.pushNamed(context, LoginPage.id);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response?.message ?? 'Registrasi gagal')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Akun'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [Color(0xFFE0BBE4), Color(0xFFADD8E6), Color(0xFF957DAD)],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: AppBar().preferredSize.height + 20),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  prefixIcon: const Icon(Icons.person, color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  prefixIcon: const Icon(Icons.email, color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  prefixIcon: const Icon(
                    Icons.transgender,
                    color: Colors.white70,
                  ),
                ),
                dropdownColor: const Color(0xFF624F82),
                style: const TextStyle(color: Colors.white),
                value: _selectedGender,
                items: const [
                  DropdownMenuItem(
                    value: 'L',
                    child: Text(
                      'Laki-laki',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'P',
                    child: Text(
                      'Perempuan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih jenis kelamin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Batch',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  prefixIcon: const Icon(Icons.group, color: Colors.white70),
                ),
                dropdownColor: const Color(0xFF624F82),
                style: const TextStyle(color: Colors.white),
                value: _selectedBatchId, // Menggunakan _selectedBatchId
                // Tambahkan isExpanded agar dropdown mengambil lebar penuh
                isExpanded: true,
                items: availableBatch.map((batch) {
                  return DropdownMenuItem<String>(
                    value: batch.id.toString(), // Menggunakan ID batch
                    child: Text(
                      batch.batchKe ?? 'N/A',
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis, // Tambahkan ini
                      maxLines: 1, // Tambahkan ini
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBatchId = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih batch';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Perbaikan di sini untuk DropdownButtonFormField Training
              _isLoadingTrainings
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Training',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        prefixIcon: const Icon(
                          Icons.school,
                          color: Colors.white70,
                        ),
                      ),
                      dropdownColor: const Color(0xFF624F82),
                      style: const TextStyle(color: Colors.white),
                      value:
                          _selectedTrainingId, // Menggunakan _selectedTrainingId
                      // Penting: Tambahkan isExpanded agar dropdown mengambil lebar penuh
                      isExpanded: true,
                      items: availableTrainings.map((trainingDatum) {
                        return DropdownMenuItem<String>(
                          value: trainingDatum.id
                              .toString(), // Menggunakan ID training
                          child: Text(
                            trainingDatum.title ?? 'N/A',
                            style: const TextStyle(color: Colors.white),
                            overflow:
                                TextOverflow.ellipsis, // Penting: Tambahkan ini
                            maxLines: 1, // Penting: Tambahkan ini
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTrainingId = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih training';
                        }
                        return null;
                      },
                    ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF624F82),
                ),
                child: const Text('Daftar', style: TextStyle(fontSize: 18.0)),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Sudah punya akun? ',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC0A4E3),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('Teks Login diklik!');
                            Navigator.pushNamed(context, LoginPage.id);
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
