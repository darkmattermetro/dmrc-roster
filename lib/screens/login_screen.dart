import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _empIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _accessCodeController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = true;
  String _accessLevel = 'crewcontroller';
  String? _error;

  @override
  void dispose() {
    _empIdController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _accessCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildErrorBox(),
              if (_isLogin) _buildLoginForm() else _buildRegisterForm(),
              const SizedBox(height: 16),
              _buildToggleButton(),
              const SizedBox(height: 20),
              _buildAccessLevelSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF00d4ff),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text('🚇', style: TextStyle(fontSize: 40)),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'DMRC LINE 7',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00d4ff),
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isLogin ? 'Sign In' : 'Create Account',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBox() {
    if (_error == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextField(
          controller: _empIdController,
          textCapitalization: TextCapitalization.characters,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Emp ID',
            labelStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.badge, color: Color(0xFF00d4ff)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.lock, color: Color(0xFF00d4ff)),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00d4ff),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'LOGIN',
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        TextField(
          controller: _empIdController,
          textCapitalization: TextCapitalization.characters,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Emp ID',
            labelStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.badge, color: Color(0xFF00d4ff)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Full Name',
            labelStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.person, color: Color(0xFF00d4ff)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.lock, color: Color(0xFF00d4ff)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _accessCodeController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Access Code',
            labelStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.key, color: Color(0xFF00d4ff)),
            hintText: 'Enter admin/CC access code',
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00d4ff),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'REGISTER',
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
          _error = null;
        });
      },
      child: Text(
        _isLogin
            ? 'New staff? Register here'
            : 'Already registered? Login',
        style: const TextStyle(
          color: Color(0xFF00d4ff),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildAccessLevelSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Access Level: ${_accessLevel.toUpperCase()}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAccessChip('crewcontroller', 'Crew Controller'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAccessChip('admin', 'Admin'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccessChip(String value, String label) {
    final isSelected = _accessLevel == value;
    return GestureDetector(
      onTap: () => setState(() => _accessLevel = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00d4ff) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF00d4ff) : Colors.white30,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final authService = AuthService();
    final result = await authService.login(
      _empIdController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.success && result.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: result.user!)),
      );
    } else {
      setState(() => _error = result.error);
    }
  }

  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    if (_empIdController.text.isEmpty || 
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _accessCodeController.text.isEmpty) {
      setState(() {
        _error = 'Please fill all fields';
        _isLoading = false;
      });
      return;
    }

    final authService = AuthService();
    final result = await authService.register(
      empId: _empIdController.text.trim(),
      name: _nameController.text.trim(),
      password: _passwordController.text,
      accessCode: _accessCodeController.text,
      accessLevel: _accessLevel,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please login.'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _isLogin = true;
        _passwordController.clear();
        _accessCodeController.clear();
        _nameController.clear();
      });
    } else {
      setState(() => _error = result.error);
    }
  }
}
