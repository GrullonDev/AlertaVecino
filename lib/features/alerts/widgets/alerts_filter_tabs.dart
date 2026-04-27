import 'package:flutter/material.dart';

class AlertsFilterTabs extends StatelessWidget {
  const AlertsFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab('All Notifications', isSelected: true),
          const SizedBox(width: 8),
          _buildTab('Emergency Broadcasts', isSelected: false),
          const SizedBox(width: 8),
          _buildTab('Maintenance', isSelected: false),
        ],
      ),
    );
  }

  Widget _buildTab(String text, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade700 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
