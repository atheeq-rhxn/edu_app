import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'auth.dart';
import 'package:edu_app/shared/widgets/auth_components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
      AuthSignInRequested(
        _emailController.text.trim(),
        _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) context.go('/');
        if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.authenticating;

        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: _validatePassword,
                      enabled: !isLoading,
                      onFieldSubmitted: (_) => _submitForm(),
                    ),
                    const SizedBox(height: 24),
                    AuthButton(
                      label: 'Log In',
                      isLoading: isLoading,
                      onPressed: _submitForm,
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    SocialAuthButton.google(
                      onPressed:
                          () => context.read<AuthBloc>().add(
                            AuthGoogleSignInRequested(),
                          ),
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 32),
                    AuthFooterLink(
                      prompt: 'Don\'t have an account? ',
                      action: 'Sign Up',
                      onAction: () => context.pushNamed('signup'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String? _validateEmail(String? value) =>
      value == null ||
              !RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              ).hasMatch(value)
          ? 'Valid email required'
          : null;
  String? _validatePassword(String? value) =>
      (value?.length ?? 0) < 6 ? 'Minimum 6 characters' : null;
}
