import 'package:expenso/core/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/friend_controller.dart';
import '../../models/friend_model.dart';
import '../../models/transaction_model.dart';
import '../../core/theme/app_colors.dart';

class FriendDetailScreen extends StatelessWidget {
  final FriendModel friend;

  const FriendDetailScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FriendController>();
    controller.fetchTransactions(friend.id);

    return Scaffold(
      appBar: AppBar(title: Text(friend.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransaction(context, controller),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        final txns = controller.friendTransactions(friend.id);
        final fri = controller.friends.firstWhere((f) => f.id == friend.id);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.defaultPadding,
              ),
              child: _balanceCard(fri),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: txns.length,
                itemBuilder: (_, i) {
                  final t = txns[i];
                  return _transactionTile(t);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _balanceCard(FriendModel friend) {
    Color bgColor;
    String text;
    Color textColor;

    if (friend.balance > 0) {
      bgColor = Colors.green.withOpacity(0.15);
      textColor = Colors.green;
      text = "You will take ₹${friend.balance.abs()}";
    } else if (friend.balance < 0) {
      bgColor = Colors.red.withOpacity(0.15);
      textColor = Colors.red;
      text = "You will pay ₹${friend.balance.abs()}";
    } else {
      bgColor = Colors.white;
      textColor = Colors.grey;
      text = "All Settled";
    }

    return Material(
      elevation: 4.0, // The z-coordinate for the shadow size
      shadowColor: Colors.grey, // Color of the drop shadow
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: textColor.withOpacity(0.4)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _transactionTile(FriendTransactionModel t) {
    Alignment alignment;
    Color color;
    String prefix;

    if (t.type == TransactionType.lend) {
      alignment = Alignment.centerLeft;
      color = Colors.green;
      prefix = "You lent";
    } else if (t.type == TransactionType.borrow) {
      alignment = Alignment.centerRight;
      color = Colors.red;
      prefix = "You borrowed";
    } else {
      alignment = Alignment.center;
      color = Colors.grey.shade300;
      prefix = "Settlement";
    }

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8.0),
        child: Material(
          elevation: 4.0, // The z-coordinate for the shadow size
          shadowColor: Colors.grey, // Color of the drop shadow
          borderRadius: BorderRadius.circular(14.0),
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),

            constraints: t.type == TransactionType.settlement
                ? null
                : const BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: t.type == TransactionType.settlement
                  ? Colors.white
                  : color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$prefix ₹${t.amount}",
                  style: TextStyle(
                    color: t.type == TransactionType.settlement
                        ? Colors.black
                        : color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (t.note.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      t.note,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _formatTime(t.date),
                    style: const TextStyle(fontSize: 11, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  void _showAddTransaction(BuildContext context, FriendController controller) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final selectedType = TransactionType.lend.obs;
    final selectedDate = DateTime.now().obs;
    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          decoration: const BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag handle
              const Text(
                "Add Transaction",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Amount
              _input(
                controller: amountCtrl,
                hint: "Amount",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 14),

              // Note
              _input(controller: noteCtrl, hint: "Note (optional)"),

              const SizedBox(height: 20),

              const Text(
                "Transaction Type",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              // Type selector
              Obx(
                () => Row(
                  children: [
                    _typeChip(
                      label: "Lend",
                      color: AppColors.lend,
                      isSelected: selectedType.value == TransactionType.lend,
                      onTap: () => selectedType.value = TransactionType.lend,
                    ),
                    const SizedBox(width: 10),
                    _typeChip(
                      label: "Borrow",
                      color: AppColors.borrow,
                      isSelected: selectedType.value == TransactionType.borrow,
                      onTap: () => selectedType.value = TransactionType.borrow,
                    ),
                    const SizedBox(width: 10),
                    _typeChip(
                      label: "Settlement",
                      color: AppColors.settled,
                      isSelected:
                          selectedType.value == TransactionType.settlement,
                      onTap: () =>
                          selectedType.value = TransactionType.settlement,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Transation Date"),
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

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    if (amountCtrl.text.isEmpty) return;

                    controller.addTransaction(
                      friend: friend,
                      amount: double.parse(amountCtrl.text),
                      type: selectedType.value,
                      date: selectedDate.value,
                      note: noteCtrl.text,
                    );

                    Get.back();
                  },
                  child: const Text(
                    "Save Transaction",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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

  Widget _typeChip({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
