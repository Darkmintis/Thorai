import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_view_model.dart';
import '../../core/services/navigation_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                ),
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
                    onChanged: vm.setEmail,
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
                      errorBorder: (vm.attemptedSubmit && vm.emailError != null)
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                      focusedErrorBorder: (vm.attemptedSubmit && vm.emailError != null)
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                            ),
                      errorText: vm.attemptedSubmit ? vm.emailError : null,
                      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 12),
                  
                  // Password Field
                  TextField(
                    onChanged: vm.setPassword,
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
                      errorBorder: (vm.attemptedSubmit && vm.passwordError != null)
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                      focusedErrorBorder: (vm.attemptedSubmit && vm.passwordError != null)
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                            ),
                      errorText: vm.attemptedSubmit ? vm.passwordError : null,
                      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(vm.obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: vm.togglePasswordVisibility,
                      ),
                    ),
                    obscureText: vm.obscurePassword,
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
                            try {
                              await vm.login();
                              if (context.mounted) {
                                NavigationService().replaceWith('/books');
                              }
                            } catch (_) {
                              // Error handled by view model
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
}
