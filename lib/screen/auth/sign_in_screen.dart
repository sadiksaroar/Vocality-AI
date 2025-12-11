import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/widget/custom/custom_text_field.dart';
import 'package:vocality_ai/widget/custom/sign_in_custom.dart';
import 'package:vocality_ai/widget/text/text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showPass = false;
  bool _showConfirmPass = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFC107),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isSmall ? 24 : 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),

              Assets.icons.k.image(width: 108, height: 126),
              const SizedBox(height: 8),
              Text(
                "Sign up to get started with your account",
                style: MyTextStyles.subHeading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameCtrl,
                      labelText: "Full Name",
                      labelStyle: MyTextStyles.labelText,
                      hintText: "Istiak",
                      hintStyle: MyTextStyles.userName,

                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter name" : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailCtrl,
                      labelText: "Email",
                      labelStyle: MyTextStyles.labelText,

                      hintText: "example@gmail.com",
                      hintStyle: MyTextStyles.userName,

                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Enter email";
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(v))
                          return "Invalid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordCtrl,
                      labelText: "Password",
                      labelStyle: MyTextStyles.labelText,

                      hintText: "Enter password",
                      hintStyle: MyTextStyles.userName,

                      obscureText: !_showPass,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPass ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => _showPass = !_showPass),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Enter password";
                        if (v.length < 6) return "At least 6 chars";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmCtrl,
                      labelText: "Confirm Password",
                      labelStyle: MyTextStyles.labelText,
                      hintText: "Re-enter password",
                      hintStyle: MyTextStyles.userName,
                      obscureText: !_showConfirmPass,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPass
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => setState(
                          () => _showConfirmPass = !_showConfirmPass,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Confirm password";
                        if (v != _passwordCtrl.text) return "Password mismatch";
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    SignInCustom(
                      text: "Sign Up",
                      isSmallScreen: isSmall,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Signed Up!")),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: const Color(0xFF999999),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Continue',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                        color: const Color(0xFF3D3D3D),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.70,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              // strokeAlign: BorderSide.strokeAlignCenter,
                              color: const Color(0xFF999999),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Text("Or", style: MyTextStyles.subHeading),
              const SizedBox(height: 16),
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialBtn(
                    icon: Image.asset(
                      Assets.icons.apple.path,
                      height: 24,
                      width: 24,
                    ),
                    text: "Apple",
                  ),

                  // _socialBtn(Asstes.icons.apple.p, text: "Apple"),
                  const SizedBox(height: 10),
                  _socialBtn(
                    icon: Image.asset(
                      Assets.icons.google.path,
                      height: 24,
                      width: 24,
                    ),
                    text: "Google",
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have account? ",
                    style: MyTextStyles.subHeading,
                  ),
                  GestureDetector(
                    onTap: () => context.push("/logInScreen"),
                    child: Text(
                      "Login",

                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.70,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialBtn({required Widget icon, required String text}) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: icon,
        label: Text(text, style: MyTextStyles.input),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          side: const BorderSide(color: Color(0xFF5C5C5C)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
