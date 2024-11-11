import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   final String email = "usuario@ejemplo.com";
  final String fullName = "Juan Pérez";
  final String role = "Administrador"; 
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
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 SizedBox(height: 100),
                 CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/profile_pic.jpg'), // Imagen de perfil
                ),
                SizedBox(height: 20),
                Text(
                  'Username',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      )
   );
  }
}