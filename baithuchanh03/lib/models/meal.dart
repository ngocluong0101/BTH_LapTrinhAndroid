class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String description; // instructions or short description

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbnail: json['strMealThumb'] as String,
      description: json['strInstructions'] as String? ?? '',
    );
  }
}
