import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_view_model.dart';
import '../book/books_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePassword = true;
  bool _attemptedSubmit = false; // Track if user attempted to submit

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
                  
                  // Email Field
                  TextField(
                    controller: _userController,
                    onChanged: (value) {
                      // Clear email error when user starts typing
                      if (_attemptedSubmit && vm.emailError != null) {
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                      // Only show red border if attempted submit AND there's an error
                      errorBorder: (_attemptedSubmit && vm.emailError != null)
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                      focusedErrorBorder: (_attemptedSubmit && vm.emailError != null)
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                            ),
                      errorText: _attemptedSubmit ? vm.emailError : null,
                      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 12),
                  
                  // Password Field
                  TextField(
                    controller: _passController,
                    onChanged: (value) {
                      // Clear password error when user starts typing
                      if (_attemptedSubmit && vm.passwordError != null) {
                        
                      }
                    },
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
                      // Only show red border if attempted submit AND there's an error
                      errorBorder: (_attemptedSubmit && vm.passwordError != null)
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                      focusedErrorBorder: (_attemptedSubmit && vm.passwordError != null)
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                            ),
                      errorText: _attemptedSubmit ? vm.passwordError : null,
                      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                 
                  const SizedBox(height: 14),
                  
                  // General error message
                  if (vm.error != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(vm.error!, style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  
                  const SizedBox(height: 14),
                  
                  // Login Button
                  ElevatedButton(
                    onPressed: vm.loading
                        ? null
                        : () async {
                            // Mark that user attempted to submit
                            setState(() {
                              _attemptedSubmit = true;
                            });
                            
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