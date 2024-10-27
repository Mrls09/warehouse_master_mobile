import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({super.key});

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _code = '';

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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Introduce el código de 6 dígitos que te enviamos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.deepRedAccent,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: PinCodeTextField(
                          appContext: context,
                          length: 6,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 60,
                            fieldWidth: 50,
                            activeFillColor: AppColors.palePinkBackground,
                            inactiveFillColor: AppColors.palePinkBackground,
                            selectedFillColor: AppColors.palePinkBackground,
                            activeColor: AppColors.rosePrimary,
                            selectedColor: AppColors.deepRedAccent,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: (value) {
                            setState(() {
                              _code = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.length != 6) {
                              return 'El código debe tener 6 dígitos';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              print('Código ingresado: $_code');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.rosePrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Verificar Código',
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
        ],
      ),
    );
  }
}