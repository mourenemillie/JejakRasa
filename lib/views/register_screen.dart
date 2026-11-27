import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';
import '../theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(RegisterViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    await vm.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      passwordConfirmation: _confirmCtrl.text.trim(),
    );

    if (!mounted) return;

    if (vm.state == RegisterState.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil! Silakan login.'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else if (vm.state == RegisterState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage), backgroundColor: AppColors.accent),
      );
      vm.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: Consumer<RegisterViewModel>(
        builder: (context, vm, _) => Scaffold(
          appBar: AppBar(title: const Text('Registrasi Akun', style: TextStyle(fontWeight: FontWeight.bold))),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Buat Akun Baru', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const Text('Lengkapi data diri Anda di bawah ini', style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.person_outline)),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                      validator: (v) => (v == null || !v.contains('@') || !v.contains('.')) ? 'Format email tidak valid' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Nomor HP', hintText: 'Contoh: 081234567890', prefixIcon: Icon(Icons.phone_outlined)),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nomor HP wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passCtrl,
                      obscureText: vm.obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(vm.obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: vm.togglePasswordVisibility,
                        ),
                      ),
                      validator: (v) => (v == null || v.length < 8) ? 'Password minimal 8 karakter' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: vm.obscureConfirm,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Password',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(vm.obscureConfirm ? Icons.visibility_off : Icons.visibility),
                          onPressed: vm.toggleConfirmVisibility,
                        ),
                      ),
                      validator: (v) => (v != _passCtrl.text) ? 'Password tidak sama' : null,
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: vm.isLoading ? null : () => _submit(vm),
                        child: vm.isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Daftar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}