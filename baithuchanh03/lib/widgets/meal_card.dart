import 'package:flutter/material.dart';

import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Image.network(
          meal.thumbnail,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) =>
              const Icon(Icons.broken_image),
        ),
        title: Text(meal.name, overflow: TextOverflow.ellipsis),
        subtitle: meal.description.isNotEmpty
            ? Text(
                meal.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
      ),
    );
  }
}
