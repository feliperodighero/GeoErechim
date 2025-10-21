import 'package:flutter/material.dart';

class PlayerNameDialog extends StatefulWidget {
  final Function(String) onConfirm;

  const PlayerNameDialog({super.key, required this.onConfirm});

  @override
  State<PlayerNameDialog> createState() => _PlayerNameDialogState();
}

class _PlayerNameDialogState extends State<PlayerNameDialog> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1F6F3F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Qual o seu nome?',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Lilita One',
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Digite seu nome aqui",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, digite seu nome para continuar.';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E3321),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onConfirm(_nameController.text.trim());
            }
          },
          child: const Text('Jogar!', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}