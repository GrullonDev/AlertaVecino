import 'package:flutter/material.dart';

class OptionsLogin extends StatelessWidget {
  const OptionsLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.g_mobiledata,
              color: Colors.redAccent,
              size: 32,
            ),
            label: const Text(
              'Google',
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.fingerprint, color: Colors.grey, size: 24),
            label: const Text(
              'Passkey',
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
