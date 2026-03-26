import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/login_view_model.dart';
import '../../books/views/books_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Login to Thorai',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                )
              ),
              centerTitle: true,
              ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_library, size: 100, color: Color.fromARGB(255, 25, 96, 154)),
                  const SizedBox(height: 50), 
                  TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder( 
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder( 
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical:16),
                      ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder( 
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder( 
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical:16),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 14),
                  if (vm.error != null)
                    Text(vm.error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: vm.loading
                        ? null
                        : () async {
                            try {
                              await vm.login(_userController.text.trim(), _passController.text.trim());
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const BooksScreen()),
                                );
                              }
                            } catch (_) {
                              // error shown by view model
                            }
                          },
                    child: vm.loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                          'Login',
                          style: TextStyle( 
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }
}