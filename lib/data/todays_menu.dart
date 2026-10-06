import 'package:flutter/material.dart';

import 'package:brew_lane/models/menu_item.dart';

/// Today's menu. It is hard-coded on purpose: the app showcases the AppBar,
/// so it needs no backend or network connection to run.
const List<MenuItem> todaysMenu = [
  MenuItem(
    name: 'Espresso',
    description: 'Double shot, Rwandan single origin',
    priceRwf: 1500,
    icon: Icons.coffee,
  ),
  MenuItem(
    name: 'Cappuccino',
    description: 'Espresso, steamed milk, thick foam',
    priceRwf: 2500,
    icon: Icons.local_cafe,
  ),
  MenuItem(
    name: 'Café Latte',
    description: 'Mellow espresso with silky milk',
    priceRwf: 2800,
    icon: Icons.coffee_outlined,
  ),
  MenuItem(
    name: 'African Tea',
    description: 'Black tea, milk, ginger and spices',
    priceRwf: 1800,
    icon: Icons.emoji_food_beverage,
  ),
  MenuItem(
    name: 'Passion Juice',
    description: 'Fresh-pressed, lightly sweetened',
    priceRwf: 2000,
    icon: Icons.local_drink,
  ),
  MenuItem(
    name: 'Butter Croissant',
    description: 'Flaky and baked this morning',
    priceRwf: 2200,
    icon: Icons.bakery_dining,
  ),
  MenuItem(
    name: 'Banana Bread',
    description: 'Moist slice made with local bananas',
    priceRwf: 2000,
    icon: Icons.breakfast_dining,
  ),
];
