// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   bool isLoading = false;
//   final formKey = GlobalKey<FormState>();

//   // Function for login
//   Future<void> loginUser() async {
//     if (!formKey.currentState!.validate()) return;

//     setState(() => isLoading = true);

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Login Successful!')),
//       );

//       // Navigate to home page (example)
//       Navigator.of(context).pushReplacementNamed('/home');
//     } on FirebaseAuthException catch (e) {
//       String message = 'Login error';
//       if (e.code == 'user-not-found') {
//         message = 'No user found for this email.';
//       } else if (e.code == 'wrong-password') {
//         message = 'Incorrect password.';
//       } else if (e.message != null) {
//         message = e.message!;
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Form(
//           key: formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Email field
//               SizedBox(
//                 width: 350,
//                 child: TextFormField(
//                   // put email in the variable
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Enter Email',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.blue),
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                   ),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter your email' : null,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Password field
//               SizedBox(
//                 width: 350,
//                 child: TextFormField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Enter Password',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.blue),
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                   ),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter your password' : null,
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // Login Button
//               ElevatedButton(
//                 onPressed: isLoading ? null : loginUser,
//                 child: isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : const Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:chatApp/cubits/login_cubit.dart';
import 'package:chatApp/cubits/login_states.dart';
import 'package:chatApp/widgets/curved_header.dart';
import 'package:chatApp/widgets/custom_button.dart';
import 'package:chatApp/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    //كنا عاملين كده علي اساس لو مش هتغير حاجه في ال ui
    //لكن هنغير عشان ال loading
    // مش هيحصل مشكله بس علامه اللود مش هتبان
    //return BlocListener<LoginCubit, LoginState>

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushReplacementNamed('/home');
          // Navigator.pushNamed(context, chatpage.id);
        } else if (state is LoginFail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const CurvedHeader(
                  title: "Welcome Back 👋",
                  subtitle: "Sign in to continue chatting",
                  icon: Icons.chat_bubble_rounded,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Email field
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Enter Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your email' : null,
                        ),

                        const SizedBox(height: 20),

                        // Password field
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Enter Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your password'
                              : null,
                        ),

                        const SizedBox(height: 35),

                        state is LoginLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: 'LOGIN',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    String email = emailController.text;
                                    String password = passwordController.text;

                                    BlocProvider.of<LoginCubit>(context)
                                        .LoginUser(
                                      email: email,
                                      password: password,
                                    );
                                  }
                                },
                              ),

                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(fontSize: 15),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/register');
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
