import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/app_screen_container.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  String? _registerMessage;
  bool _isErrorMessage = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return email.contains('@') && email.endsWith('.com');
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();

    setState(() {
      _registerMessage = null;
      _showPassword = false;
      _isErrorMessage = false;
    });

    _formKey.currentState?.reset();
  }

  void _clearRegisterMessage() {
    if (_registerMessage != null) {
      setState(() => _registerMessage = null);
    }
  }

  Future<void> _register() async {
    setState(() => _registerMessage = null);

    if (!_formKey.currentState!.validate()) return;

    final authVm = context.read<AuthViewModel>();

    final success = await authVm.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _registerMessage = 'Cadastro realizado com sucesso';
        _isErrorMessage = false;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      _clearFields();
      Navigator.pop(context);
    } else {
      setState(() {
        _registerMessage = authVm.errorMessage ?? 'Erro ao cadastrar usuário';
        _isErrorMessage = true;
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (!mounted) return;
        setState(() => _registerMessage = null);
      });
    }
  }

  void _backToLogin() {
    _clearFields();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AppScreenContainer(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 22,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.person_add_alt_1,
                      size: 58,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Criar Conta',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Cadastre-se para organizar suas finanças',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildBenefitsCard(),

                    const SizedBox(height: 28),

                    TextFormField(
                      controller: _nameController,
                      maxLength: 40,
                      onChanged: (_) => _clearRegisterMessage(),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-ZÀ-ÿ\s]'),
                        ),
                        LengthLimitingTextInputFormatter(40),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        counterText: '',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o nome';
                        }

                        if (value.trim().length < 3) {
                          return 'Nome deve ter pelo menos 3 caracteres';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (_) => _clearRegisterMessage(),
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o e-mail';
                        }

                        if (!_isValidEmail(value.trim())) {
                          return 'E-mail inválido';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (_) => _clearRegisterMessage(),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe a senha';
                        }

                        if (value.length < 8) {
                          return 'A senha deve possuir no mínimo 8 caracteres';
                        }

                        return null;
                      },
                    ),

                    if (_registerMessage != null) ...[
                      const SizedBox(height: 10),
                      _buildRegisterMessage(_registerMessage!),
                    ],

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2575FC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: authVm.isLoading ? null : _register,
                        child: authVm.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Cadastrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: _backToLogin,
                      child: const Text(
                        'Já possui conta? Faça login',
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

  Widget _buildBenefitsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Comece sua organização financeira',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildBenefitItem(
            Icons.check_circle,
            'Controle receitas e despesas',
          ),

          const SizedBox(height: 8),

          _buildBenefitItem(
            Icons.check_circle,
            'Saldo atualizado automaticamente',
          ),

          const SizedBox(height: 8),

          _buildBenefitItem(
            Icons.check_circle,
            'Relatórios financeiros',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: Colors.green,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _isErrorMessage ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isErrorMessage ? Colors.red : Colors.green,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isErrorMessage ? Icons.error_outline : Icons.check_circle_outline,
            color: _isErrorMessage ? Colors.red : Colors.green,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: _isErrorMessage ? Colors.red : Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}