import 'package:flutter/material.dart';

class OutputScreen extends StatefulWidget {
  const OutputScreen({super.key});

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  @override
  Widget build(BuildContext context) {
   return const Scaffold(
      body: Center(
        child: Text('Pantalla de salidas'),
     ),
   );
  }
}