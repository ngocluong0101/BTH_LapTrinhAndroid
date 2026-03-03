import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';

enum DataState { loading, success, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataState _state = DataState.loading;
  List<Meal> _meals = [];
  String? _errorMessage;

  final _api = ApiService();

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  void _loadMeals() async {
    setState(() {
      _state = DataState.loading;
      _errorMessage = null;
    });
    try {
      final items = await _api.fetchMeals();
      setState(() {
        _meals = items;
        _state = DataState.success;
      });
    } catch (e) {
      setState(() {
        _state = DataState.error;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: change to your own name and student ID
        title: const Text('TH3 - Trần Ngọc Lương - 2351170604'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case DataState.loading:
        return const Center(child: CircularProgressIndicator());
      case DataState.success:
        if (_meals.isEmpty) {
          return const Center(child: Text('Không có món nào')); // no meals
        }
        return ListView.builder(
          itemCount: _meals.length,
          itemBuilder: (c, i) => MealCard(meal: _meals[i]),
        );
      case DataState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Lỗi: $_errorMessage'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadMeals,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        );
    }
  }
}
