import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _syncFields(ProfileViewModel vm) {
    if (vm.user != null) {
      _nameCtrl.text = vm.user!.name;
      _phoneCtrl.text = vm.user!.phone;
    }
  }

  Future<void> _save(ProfileViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await vm.updateProfile(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );
    if (!mounted) return;

    if (ok) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil diperbarui!'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage), backgroundColor: AppColors.accent),
      );
      vm.reset();
    }
  }

  Future<void> _logout(ProfileViewModel vm) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await vm.logout();
      if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadProfile(),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          if (vm.state == ProfileState.loaded && !_isEditing) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _syncFields(vm));
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold)),
              actions: [
                if (vm.state == ProfileState.loaded)
                  IconButton(
                    icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined),
                    onPressed: () {
                      _syncFields(vm);
                      setState(() => _isEditing = !_isEditing);
                    },
                  ),
              ],
            ),
            body: SafeArea(child: _buildBody(vm)),
          );
        },
      ),
    );
  }

  Widget _buildBody(ProfileViewModel vm) {
    if (vm.isLoading) return const Center(child: CircularProgressIndicator());

    if (vm.state == ProfileState.error && vm.user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: AppColors.accent),
            const SizedBox(height: 12),
            Text(vm.errorMessage, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: vm.loadProfile,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final user = vm.user;
    if (user == null) return const SizedBox();
    final initials = user.name.trim().isNotEmpty
        ? user.name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primary,
              child: Text(initials, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF121212))),
            ),
            const SizedBox(height: 12),
            Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(user.email, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 28),

            // Card Info / Form Edit
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                children: [
                  _isEditing
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: TextFormField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.person_outline)),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                          ),
                        )
                      : ListTile(
                          leading: const Icon(Icons.person_outline, color: AppColors.primary),
                          title: const Text('Nama Lengkap', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          subtitle: Text(user.name, style: const TextStyle(fontSize: 15, color: AppColors.textPrimary)),
                        ),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  ListTile(
                    leading: const Icon(Icons.email_outlined, color: AppColors.primary),
                    title: const Text('Email', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    subtitle: Text(user.email, style: const TextStyle(fontSize: 15, color: AppColors.textPrimary)),
                  ),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  _isEditing
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(labelText: 'Nomor HP', prefixIcon: Icon(Icons.phone_outlined)),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Nomor HP wajib diisi' : null,
                          ),
                        )
                      : ListTile(
                          leading: const Icon(Icons.phone_outlined, color: AppColors.primary),
                          title: const Text('Nomor HP', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          subtitle: Text(user.phone.isNotEmpty ? user.phone : '-', style: const TextStyle(fontSize: 15, color: AppColors.textPrimary)),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: _isEditing
                  ? ElevatedButton.icon(
                      onPressed: vm.isUpdating ? null : () => _save(vm),
                      icon: vm.isUpdating
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save_outlined),
                      label: Text(vm.isUpdating ? 'Menyimpan...' : 'Simpan Perubahan'),
                    )
                  : OutlinedButton.icon(
                      onPressed: () => _logout(vm),
                      icon: const Icon(Icons.logout, color: AppColors.accent),
                      label: const Text('Logout', style: TextStyle(color: AppColors.accent)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.accent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}