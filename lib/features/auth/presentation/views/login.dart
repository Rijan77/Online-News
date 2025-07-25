import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/common/widgets/button_widget.dart';
import 'package:news_app/core/common/widgets/text_field_widget.dart';
import 'package:news_app/features/auth/data/models/signin_google.dart';

import '../blocs/auth_cubit/login_cubit.dart';
import '../blocs/auth_cubit/login_state.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Successful")),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: isPortrait ? screenHeight * 0.14 : 0.02),
                  child: Center(
                    child: Icon(Icons.newspaper_outlined,
                        size: isPortrait ? 130 : 80, color: Colors.blueGrey),
                  ),
                ),
                Text(
                  "Online News",
                  style: TextStyle(
                      fontSize: isPortrait ? 30 : 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: screenHeight * 0.1),
                TextFieldWidget(
                  firstIcon: const Icon(Icons.email_rounded),
                  textLabel: "Email Address",
                  editingController: emailController,
                ),
                SizedBox(height: screenHeight * 0.04),
                TextFieldWidget(
                  firstIcon: const Icon(Icons.lock),
                  textLabel: "Password",
                  lastIcon: const Icon(Icons.remove_red_eye_rounded),
                  editingController: passwordController,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.4, top: screenHeight * 0.01),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.07),

                // Login Button with Cubit State
                ButtonWidget(
                  buttonText: "Login",
                  styleText: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w600),
                  isLoading: isLoading,
                  onTap: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    context.read<LoginCubit>().login(email, password);
                  },
                ),

                SizedBox(height: screenHeight * 0.01),
                const Text("OR",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600)),
                SizedBox(height: screenHeight * 0.01),

                // Google Sign-In Button
                ButtonWidget(
                  buttonText: "Continue with Google",
                  styleText: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                  imagePath: "Assets/googlelogo.png",
                  onTap: () {
                    GoogleSignIn().loginWithGoogle(context);
                  },
                  isLoading: false,
                ),

                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not Register Yet?",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/second');
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
