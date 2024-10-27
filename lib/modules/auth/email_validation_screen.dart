import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:warehouse_master_mobile/kernel/widgets/form/text_form_field_email.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class EmailValidationScreen extends StatefulWidget {
  const EmailValidationScreen({super.key});

  @override
  State<EmailValidationScreen> createState() => _EmailValidationScreenState();
}

class _EmailValidationScreenState extends State<EmailValidationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _sendVerificationCode() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Enviar código a: ${_emailController.text}');
      Navigator.pushNamed(context, '/verifyCode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/backrund.svg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.lightGray,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Introduce tu correo electrónico para recibir el código de verificación',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.deepRedAccent,
                             fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFieldEmail(
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _sendVerificationCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.rosePrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Enviar Código',
                              style: TextStyle(color: AppColors.palePinkBackground),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}