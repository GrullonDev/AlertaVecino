import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/home/widgets/home_action_card.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: const [
            HomeActionCard(
              title: 'Reportar\nIncidente',
              icon: Icons.report_problem_outlined,
              color: Colors.orange,
            ),
            HomeActionCard(
              title: 'Mapa de\nIncidentes',
              icon: Icons.map_outlined,
              color: Colors.blue,
            ),
            HomeActionCard(
              title: 'Directorio\nLocal',
              icon: Icons.contact_phone_outlined,
              color: Colors.teal,
            ),
            HomeActionCard(
              title: 'Mis\nReportes',
              icon: Icons.history_outlined,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
}
