import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/expense_controller.dart';
import '../../core/theme/app_colors.dart';

class AddExpenseSheet extends StatelessWidget {
  AddExpenseSheet({super.key});

  final amountCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final controller = Get.put(ExpenseController());

  final categories = ["Food", "Travel", "Shopping", "Bills", "Other"];

  final selectedCategory = "Food".obs;
  final selectedDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Expense",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          _input("Amount", amountCtrl, TextInputType.number),
          const SizedBox(height: 16),

          _input("Description", descCtrl, TextInputType.text),
          const SizedBox(height: 16),

          const Text("Category"),
          const SizedBox(height: 8),

          Obx(
            () => Wrap(
              spacing: 10,
              children: categories.map((cat) {
                final isSelected = selectedCategory.value == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textDark,
                  ),
                  onSelected: (_) => selectedCategory.value = cat,
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          Obx(
            () => ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Date"),
              trailing: Text(
                "${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) selectedDate.value = picked;
              },
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                controller.addExpense(
                  amount: double.parse(amountCtrl.text),
                  category: selectedCategory.value,
                  description: descCtrl.text,
                  date: selectedDate.value,
                );
                Get.back();
              },
              child: const Text("Save Expense"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    String hint,
    TextEditingController controller,
    TextInputType type,
  ) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
