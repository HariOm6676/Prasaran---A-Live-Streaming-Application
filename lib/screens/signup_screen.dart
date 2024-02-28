import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_conferencing/resources/auth_methods.dart';
import 'package:video_conferencing/responsive/responsive.dart';
import 'package:video_conferencing/screens/home_screen.dart';
import 'package:video_conferencing/widgets/custom_button.dart';
import 'package:video_conferencing/widgets/custom_text_field.dart';
import 'package:video_conferencing/widgets/loadin_indicator.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  bool _isLoading = false;
  void signUpUser() async {
    setState(() {
      _isLoading = false;
    });
    bool res = await _authMethods.signUpUser(_emailController.text,
        _usernameController.text, _passwordController.text, context);
    setState(() {
      _isLoading = false;
    });
    if (res) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Sign Up',
      )),
      body: _isLoading
          ? const LoadingIndicator()
          : Responsive(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      Text(
                        "Email",
                        style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomTextFeild(controller: _emailController),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "UserName",
                        style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomTextFeild(controller: _usernameController),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Password",
                        style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomTextFeild(controller: _passwordController),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(onTap: signUpUser, text: "SIGN UP")
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
