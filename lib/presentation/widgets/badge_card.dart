import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class BadgeCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isUnlocked;

  const BadgeCard({
    super.key,
    required this.name,
    required this.icon,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsetsDirectional.only(end: 16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isUnlocked 
                      ? AppColors.gold.withOpacity(0.1) 
                      : Colors.grey.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUnlocked ? AppColors.gold : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: ColorFiltered(
                  colorFilter: isUnlocked 
                      ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                      : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  child: Opacity(
                    opacity: isUnlocked ? 1.0 : 0.3,
                    child: Icon(
                      icon,
                      color: isUnlocked ? AppColors.gold : Colors.grey,
                      size: 30,
                    ),
                  ),
                ),
              ),
              if (!isUnlocked)
                const Positioned(
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                    size: 16,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? AppColors.emerald : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
