import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller Utama & Latihan
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController(); // Latihan 1
  final _birthDateController = TextEditingController(); // Latihan 2

  // State untuk Toggle Password & Loading
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // State Latihan 3, 4, & 5
  String? _selectedGender; // Latihan 3
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];
  
  bool _agreedToTerms = false; // Latihan 4

  String _passwordStrength = ''; // Latihan 5
  Color _strengthColor = Colors.transparent; // Latihan 5

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  // Fungsi Pemilih Tanggal (Latihan 2)
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = 
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Pengecekan Kekuatan Password (Latihan 5)
  void _checkPasswordStrength(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordStrength = '';
        _strengthColor = Colors.transparent;
      } else if (value.length < 8) {
        _passwordStrength = 'Kekuatan Password: Lemah (< 8 karakter)';
        _strengthColor = Colors.red;
      } else if (value.contains(RegExp(r'[A-Z]')) && value.contains(RegExp(r'[0-9]'))) {
        if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
          _passwordStrength = 'Kekuatan Password: Kuat';
          _strengthColor = Colors.green;
        } else {
          _passwordStrength = 'Kekuatan Password: Sedang';
          _strengthColor = Colors.orange;
        }
      } else {
        _passwordStrength = 'Kekuatan Password: Lemah (Kurang huruf kapital/angka)';
        _strengthColor = Colors.red;
      }
    });
  }

  // Fungsi Validasi
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama tidak boleh kosong';
    if (value.trim().length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) return 'Format email tidak valid';
    return null;
  }

  String? _validatePhone(String? value) { // Latihan 1
    if (value == null || value.trim().isEmpty) return 'Nomor telepon wajib diisi';
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) return 'Nomor telepon hanya boleh berisi angka';
    if (value.trim().length < 10 || value.trim().length > 13) return 'Nomor telepon harus 10-13 digit';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 8) return 'Password minimal 8 karakter';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Password harus mengandung huruf kapital';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Password harus mengandung angka';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Konfirmasi password tidak boleh kosong';
    if (value != _passwordController.text) return 'Password tidak cocok';
    return null;
  }

  // Handler Submit
  void _submitForm() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus menyetujui Syarat & Ketentuan (Latihan 4)')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registrasi Berhasil'),
            content: Text(
              'Selamat, ${_nameController.text}!\n'
              'Email: ${_emailController.text}\n'
              'Telepon: ${_phoneController.text}\n'
              'Tgl Lahir: ${_birthDateController.text}\n'
              'Gender: ${_selectedGender ?? "-"}'
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetForm();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _phoneController.clear();
    _birthDateController.clear();
    setState(() {
      _selectedGender = null;
      _agreedToTerms = false;
      _passwordStrength = '';
      _strengthColor = Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi & Latihan'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person_add, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 16),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Field Nama
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap Anda',
                  prefixIcon: Icons.person,
                  validator: _validateName,
                ),

                // Field Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),

                // LATIHAN 1: Field Nomor Telepon
                CustomTextField(
                  controller: _phoneController,
                  label: 'Nomor Telepon',
                  hint: 'Contoh: 081234567890',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                ),

                // LATIHAN 2: Field Tanggal Lahir (DatePicker)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Lahir',
                      hintText: 'Pilih tanggal lahir Anda',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey,
                    ),
                    onTap: () => _selectDate(context),
                    validator: (value) => (value == null || value.isEmpty) ? 'Tanggal lahir wajib dipilih' : null,
                  ),
                ),

                // LATIHAN 3: Dropdown Jenis Kelamin
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      prefixIcon: Icon(Icons.wc),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey,
                    ),
                    items: _genderOptions.map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() => _selectedGender = newValue);
                    },
                    validator: (value) => (value == null || value.isEmpty) ? 'Jenis kelamin wajib dipilih' : null,
                  ),
                ),

                // Field Password & LATIHAN 5 (Indikator Kekuatan Password)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: _checkPasswordStrength,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Minimal 8 karakter, huruf kapital, angka',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: _validatePassword,
                  ),
                ),

                // Widget Tampilan Indikator Kekuatan Password (Latihan 5)
                if (_passwordStrength.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _passwordStrength,
                    style: TextStyle(color: _strengthColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: _strengthColor == Colors.red ? 0.33 : (_strengthColor == Colors.orange ? 0.66 : 1.0),
                    color: _strengthColor,
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                ],

                // Field Konfirmasi Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Ulangi password Anda',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: _validateConfirmPassword,
                  ),
                ),

                // LATIHAN 4: Checkbox Syarat & Ketentuan
                CheckboxListTile(
                  title: const Text('Setuju dengan Syarat & Ketentuan'),
                  value: _agreedToTerms,
                  onChanged: (bool? value) {
                    setState(() => _agreedToTerms = value ?? false);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),

                // Tombol Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Daftar', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),

                // Tombol Reset
                OutlinedButton(
                  onPressed: _isLoading ? null : _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}