import 'package:expenso/models/category_items.dart';
import 'package:flutter/material.dart';

final categories = <CategoryItem>[
  // MOST USED (Top 5)
  const CategoryItem(icon: Icons.restaurant_outlined, label: 'Food'),
  const CategoryItem(icon: Icons.directions_bus_outlined, label: 'Travel'),
  const CategoryItem(icon: Icons.shopping_bag_outlined, label: 'Shopping'),
  const CategoryItem(icon: Icons.home_outlined, label: 'Bills'),
  const CategoryItem(icon: Icons.movie_outlined, label: 'Entertainment'),

  // DAILY LIFE
  const CategoryItem(
    icon: Icons.local_grocery_store_outlined,
    label: 'Groceries',
  ),
  const CategoryItem(icon: Icons.fastfood_outlined, label: 'Snacks'),
  const CategoryItem(icon: Icons.coffee_outlined, label: 'Coffee'),
  const CategoryItem(icon: Icons.medical_services_outlined, label: 'Health'),
  const CategoryItem(icon: Icons.fitness_center_outlined, label: 'Fitness'),
  const CategoryItem(icon: Icons.spa_outlined, label: 'Beauty'),
  const CategoryItem(icon: Icons.checkroom_outlined, label: 'Clothing'),
  const CategoryItem(
    icon: Icons.shopping_cart_outlined,
    label: 'Online Shopping',
  ),

  // HOME & UTILITIES
  const CategoryItem(icon: Icons.lightbulb_outline, label: 'Electricity'),
  const CategoryItem(icon: Icons.water_drop_outlined, label: 'Water Bill'),
  const CategoryItem(icon: Icons.wifi_outlined, label: 'Internet'),
  const CategoryItem(
    icon: Icons.phone_android_outlined,
    label: 'Mobile Recharge',
  ),
  const CategoryItem(icon: Icons.tv_outlined, label: 'OTT & Subscriptions'),
  const CategoryItem(icon: Icons.chair_outlined, label: 'Furniture'),
  const CategoryItem(icon: Icons.build_outlined, label: 'Maintenance'),

  // TRANSPORT
  const CategoryItem(icon: Icons.local_taxi_outlined, label: 'Taxi'),
  const CategoryItem(icon: Icons.directions_car_outlined, label: 'Fuel'),
  const CategoryItem(icon: Icons.train_outlined, label: 'Train'),
  const CategoryItem(icon: Icons.flight_outlined, label: 'Flights'),
  const CategoryItem(icon: Icons.two_wheeler_outlined, label: 'Bike'),
  const CategoryItem(icon: Icons.local_parking_outlined, label: 'Parking'),

  // FINANCE
  const CategoryItem(icon: Icons.account_balance_wallet_outlined, label: 'EMI'),
  const CategoryItem(icon: Icons.credit_card_outlined, label: 'Credit Card'),
  const CategoryItem(icon: Icons.payments_outlined, label: 'Loan'),
  const CategoryItem(icon: Icons.savings_outlined, label: 'Savings'),
  const CategoryItem(icon: Icons.currency_rupee_outlined, label: 'Investment'),
  const CategoryItem(icon: Icons.receipt_long_outlined, label: 'Tax'),
  const CategoryItem(icon: Icons.security_outlined, label: 'Insurance'),

  // FAMILY & PERSONAL
  const CategoryItem(icon: Icons.school_outlined, label: 'Education'),
  const CategoryItem(icon: Icons.child_care_outlined, label: 'Kids'),
  const CategoryItem(icon: Icons.pets_outlined, label: 'Pets'),
  const CategoryItem(icon: Icons.card_giftcard_outlined, label: 'Gifts'),
  const CategoryItem(icon: Icons.favorite_outline, label: 'Donation'),

  // WORK & BUSINESS
  const CategoryItem(icon: Icons.work_outline, label: 'Office'),
  const CategoryItem(icon: Icons.laptop_mac_outlined, label: 'Software'),
  const CategoryItem(icon: Icons.print_outlined, label: 'Stationery'),
  const CategoryItem(icon: Icons.business_center_outlined, label: 'Business'),

  // LEISURE
  const CategoryItem(icon: Icons.sports_esports_outlined, label: 'Gaming'),
  const CategoryItem(icon: Icons.music_note_outlined, label: 'Music'),
  const CategoryItem(icon: Icons.book_outlined, label: 'Books'),
  const CategoryItem(icon: Icons.beach_access_outlined, label: 'Vacation'),

  // OTHER
  const CategoryItem(icon: Icons.more_horiz, label: 'Miscellaneous'),
];
