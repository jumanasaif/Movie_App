import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/data/models/user_model.dart';
import 'package:movie_app/providers/user_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final countryController = TextEditingController();
  final ageController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final user = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      country: countryController.text.trim(),
      age: int.parse(ageController.text.trim()),
      password: passwordController.text.trim(),
    );

    final success = await ref.read(userProvider.notifier).register(user);

    setState(() => _loading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      if (mounted) context.go('/login');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create account')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Lottie.asset('assets/lotties/Register.json'),
              Text(
                "Create Account",
                style: theme.textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter your email" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: countryController,
                decoration: const InputDecoration(labelText: "Country"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter your country" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter your age";
                  if (int.tryParse(v) == null) return "Age must be a number";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter your password" : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _loading ? null : _signup,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up"),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
