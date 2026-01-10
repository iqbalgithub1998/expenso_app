// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/expense_controller.dart';
// import '../../core/theme/app_colors.dart';

// class AddExpenseSheet extends StatelessWidget {
//   AddExpenseSheet({super.key});

//   final amountCtrl = TextEditingController();
//   final descCtrl = TextEditingController();
//   final controller = Get.put(ExpenseController());

//   final categories = ["Food", "Travel", "Shopping", "Bills", "Other"];

//   final selectedCategory = "Food".obs;
//   final selectedDate = DateTime.now().obs;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         left: 20,
//         right: 20,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//       ),
//       decoration: const BoxDecoration(
//         color: AppColors.card,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Add Expense",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),

//           const SizedBox(height: 20),

//           _input("Amount", amountCtrl, TextInputType.number),
//           const SizedBox(height: 16),

//           _input("Description", descCtrl, TextInputType.text),
//           const SizedBox(height: 16),

//           const Text("Category"),
//           const SizedBox(height: 8),

//           Obx(
//             () => Wrap(
//               spacing: 10,
//               children: categories.map((cat) {
//                 final isSelected = selectedCategory.value == cat;
//                 return ChoiceChip(
//                   label: Text(cat),
//                   selected: isSelected,
//                   selectedColor: AppColors.primary,
//                   labelStyle: TextStyle(
//                     color: isSelected ? Colors.white : AppColors.textDark,
//                   ),
//                   onSelected: (_) => selectedCategory.value = cat,
//                 );
//               }).toList(),
//             ),
//           ),

//           const SizedBox(height: 16),

//           Obx(
//             () => ListTile(
//               contentPadding: EdgeInsets.zero,
//               title: const Text("Date"),
//               trailing: Text(
//                 "${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}",
//               ),
//               onTap: () async {
//                 final picked = await showDatePicker(
//                   context: context,
//                   initialDate: selectedDate.value,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime.now(),
//                 );
//                 if (picked != null) selectedDate.value = picked;
//               },
//             ),
//           ),

//           const SizedBox(height: 24),

//           SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               onPressed: () {
//                 controller.addExpense(
//                   amount: double.parse(amountCtrl.text),
//                   category: selectedCategory.value,
//                   description: descCtrl.text,
//                   date: selectedDate.value,
//                 );
//                 Get.back();
//               },
//               child: const Text("Save Expense"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _input(
//     String hint,
//     TextEditingController controller,
//     TextInputType type,
//   ) {
//     return TextField(
//       controller: controller,
//       keyboardType: type,
//       decoration: InputDecoration(
//         hintText: hint,
//         filled: true,
//         fillColor: AppColors.background,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/expense_controller.dart';
import '../../core/theme/app_colors.dart';

class AddExpenseSheet extends StatelessWidget {
  AddExpenseSheet({super.key});

  final amountCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final controller = Get.put(ExpenseController());

  final categories = [
    {'name': 'Food', 'icon': Icons.restaurant},
    {'name': 'Travel', 'icon': Icons.directions_car},
    {'name': 'Shopping', 'icon': Icons.shopping_bag},
    {'name': 'Bills', 'icon': Icons.receipt},
    {'name': 'Health', 'icon': Icons.medical_services},
    {'name': 'Entertainment', 'icon': Icons.movie},
    {'name': 'Education', 'icon': Icons.school},
    {'name': 'Other', 'icon': Icons.more_horiz},
  ];

  final selectedCategory = "Food".obs;
  final selectedDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,

            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.expense.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_circle,
                      color: AppColors.expense,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Add Expense",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Amount Input
              const Text(
                "Amount",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _input(
                hint: "Enter amount",
                controller: amountCtrl,
                type: TextInputType.number,
                prefixText: "₹ ",
              ),
              const SizedBox(height: 20),

              // Category Selection
              const Text(
                "Category",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return Obx(
                    () => _categoryChip(
                      name: category['name'] as String,
                      icon: category['icon'] as IconData,
                      isSelected: selectedCategory.value == category['name'],
                      onTap: () =>
                          selectedCategory.value = category['name'] as String,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Description Input
              const Text(
                "Description (Optional)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _input(
                hint: "Add a note",
                controller: descCtrl,
                type: TextInputType.text,
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // Date Picker
              const Text(
                "Date",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Obx(
                () => InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: AppColors.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) selectedDate.value = picked;
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              DateFormat(
                                'EEEE, MMM d, yyyy',
                              ).format(selectedDate.value),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.textLight),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.expense,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (amountCtrl.text.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter an amount',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade100,
                        colorText: Colors.red.shade900,
                      );
                      return;
                    }

                    try {
                      controller.addExpense(
                        amount: double.parse(amountCtrl.text),
                        category: selectedCategory.value,
                        description: descCtrl.text,
                        date: selectedDate.value,
                      );
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Expense added successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.shade100,
                        colorText: Colors.green.shade900,
                      );
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Please enter a valid amount',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade100,
                        colorText: Colors.red.shade900,
                      );
                    }
                  },
                  child: const Text(
                    "Save Expense",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input({
    required String hint,
    required TextEditingController controller,
    required TextInputType type,
    String? prefixText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefixText,
        prefixStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.expense,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.expense, width: 2),
        ),
      ),
    );
  }

  Widget _categoryChip({
    required String name,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.expense.withOpacity(0.15)
              : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.expense : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.expense.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.expense : AppColors.textLight,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.expense : AppColors.textLight,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
