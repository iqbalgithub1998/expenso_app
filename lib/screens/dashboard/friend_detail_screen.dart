// import 'package:expenso/core/constants/sizes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/friend_controller.dart';
// import '../../models/friend_model.dart';
// import '../../models/transaction_model.dart';
// import '../../core/theme/app_colors.dart';

// class FriendDetailScreen extends StatelessWidget {
//   final FriendModel friend;

//   const FriendDetailScreen({super.key, required this.friend});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<FriendController>();
//     controller.fetchTransactions(friend.id);

//     return Scaffold(
//       appBar: AppBar(title: Text(friend.name)),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddTransaction(context, controller),
//         child: const Icon(Icons.add),
//       ),
//       body: Obx(() {
//         final txns = controller.friendTransactions(friend.id);
//         final fri = controller.friends.firstWhere((f) => f.id == friend.id);
//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: TSizes.defaultPadding,
//               ),
//               child: _balanceCard(fri),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: txns.length,
//                 itemBuilder: (_, i) {
//                   final t = txns[i];
//                   return _transactionTile(t);
//                 },
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   Widget _balanceCard(FriendModel friend) {
//     Color bgColor;
//     String text;
//     Color textColor;

//     if (friend.balance > 0) {
//       bgColor = Colors.green.withOpacity(0.15);
//       textColor = Colors.green;
//       text = "You will take ₹${friend.balance.abs()}";
//     } else if (friend.balance < 0) {
//       bgColor = Colors.red.withOpacity(0.15);
//       textColor = Colors.red;
//       text = "You will pay ₹${friend.balance.abs()}";
//     } else {
//       bgColor = Colors.white;
//       textColor = Colors.grey;
//       text = "All Settled";
//     }

//     return Material(
//       elevation: 4.0, // The z-coordinate for the shadow size
//       shadowColor: Colors.grey, // Color of the drop shadow
//       borderRadius: BorderRadius.circular(20.0),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: textColor.withOpacity(0.4)),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: textColor,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _transactionTile(FriendTransactionModel t) {
//     Alignment alignment;
//     Color color;
//     String prefix;

//     if (t.type == TransactionType.lend) {
//       alignment = Alignment.centerLeft;
//       color = Colors.green;
//       prefix = "You lent";
//     } else if (t.type == TransactionType.borrow) {
//       alignment = Alignment.centerRight;
//       color = Colors.red;
//       prefix = "You borrowed";
//     } else {
//       alignment = Alignment.center;
//       color = Colors.grey.shade300;
//       prefix = "Settlement";
//     }

//     return Align(
//       alignment: alignment,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8.0),
//         child: Material(
//           elevation: 4.0, // The z-coordinate for the shadow size
//           shadowColor: Colors.grey, // Color of the drop shadow
//           borderRadius: BorderRadius.circular(14.0),
//           child: Container(
//             // margin: const EdgeInsets.symmetric(vertical: 6),
//             padding: const EdgeInsets.all(12),

//             constraints: t.type == TransactionType.settlement
//                 ? null
//                 : const BoxConstraints(maxWidth: 250),
//             decoration: BoxDecoration(
//               color: t.type == TransactionType.settlement
//                   ? Colors.white
//                   : color.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: color.withOpacity(0.4)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "$prefix ₹${t.amount}",
//                   style: TextStyle(
//                     color: t.type == TransactionType.settlement
//                         ? Colors.black
//                         : color,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 if (t.note.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4),
//                     child: Text(
//                       t.note,
//                       style: const TextStyle(fontSize: 12, color: Colors.black),
//                     ),
//                   ),
//                 const SizedBox(height: 4),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: Text(
//                     _formatTime(t.date),
//                     style: const TextStyle(fontSize: 11, color: Colors.black),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatTime(DateTime date) {
//     final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
//     final minute = date.minute.toString().padLeft(2, '0');
//     final period = date.hour >= 12 ? 'PM' : 'AM';
//     return "$hour:$minute $period";
//   }

//   void _showAddTransaction(BuildContext context, FriendController controller) {
//     final amountCtrl = TextEditingController();
//     final noteCtrl = TextEditingController();
//     final selectedType = TransactionType.lend.obs;
//     final selectedDate = DateTime.now().obs;
//     Get.bottomSheet(
//       Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//           decoration: const BoxDecoration(
//             color: AppColors.card,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // drag handle
//               const Text(
//                 "Add Transaction",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),

//               const SizedBox(height: 20),

//               // Amount
//               _input(
//                 controller: amountCtrl,
//                 hint: "Amount",
//                 keyboardType: TextInputType.number,
//               ),

//               const SizedBox(height: 14),

//               // Note
//               _input(controller: noteCtrl, hint: "Note (optional)"),

//               const SizedBox(height: 20),

//               const Text(
//                 "Transaction Type",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),

//               const SizedBox(height: 10),

//               // Type selector
//               Obx(
//                 () => Row(
//                   children: [
//                     _typeChip(
//                       label: "Lend",
//                       color: AppColors.lend,
//                       isSelected: selectedType.value == TransactionType.lend,
//                       onTap: () => selectedType.value = TransactionType.lend,
//                     ),
//                     const SizedBox(width: 10),
//                     _typeChip(
//                       label: "Borrow",
//                       color: AppColors.borrow,
//                       isSelected: selectedType.value == TransactionType.borrow,
//                       onTap: () => selectedType.value = TransactionType.borrow,
//                     ),
//                     const SizedBox(width: 10),
//                     _typeChip(
//                       label: "Settlement",
//                       color: AppColors.settled,
//                       isSelected:
//                           selectedType.value == TransactionType.settlement,
//                       onTap: () =>
//                           selectedType.value = TransactionType.settlement,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 28),

//               Obx(
//                 () => ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: const Text("Transation Date"),
//                   trailing: Text(
//                     "${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}",
//                   ),
//                   onTap: () async {
//                     final picked = await showDatePicker(
//                       context: context,
//                       initialDate: selectedDate.value,
//                       firstDate: DateTime(2020),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null) selectedDate.value = picked;
//                   },
//                 ),
//               ),

//               // Save button
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   onPressed: () {
//                     if (amountCtrl.text.isEmpty) return;

//                     controller.addTransaction(
//                       friend: friend,
//                       amount: double.parse(amountCtrl.text),
//                       type: selectedType.value,
//                       date: selectedDate.value,
//                       note: noteCtrl.text,
//                     );

//                     Get.back();
//                   },
//                   child: const Text(
//                     "Save Transaction",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//     );
//   }

//   Widget _input({
//     required TextEditingController controller,
//     required String hint,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
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

//   Widget _typeChip({
//     required String label,
//     required Color color,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: isSelected ? color : Colors.grey.shade300,
//             ),
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? color : Colors.grey,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:expenso/core/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with friend info
          SliverAppBar(
            expandedHeight: 210,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      children: [
                        // Avatar
                        Hero(
                          tag: 'friend_${friend.id}',
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: Center(
                              child: Text(
                                friend.name.isNotEmpty
                                    ? friend.name[0].toUpperCase()
                                    : "?",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          friend.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Balance Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                final fri = controller.friends.firstWhere(
                  (f) => f.id == friend.id,
                  orElse: () => friend,
                );
                return _balanceCard(fri);
              }),
            ),
          ),

          // Transactions Header
          SliverToBoxAdapter(
            child: Obx(() {
              final txns = controller.friendTransactions(friend.id);
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Transactions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${txns.length} total",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          // Transactions List
          Obx(() {
            final txns = controller.friendTransactions(friend.id);

            if (txns.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "No transactions yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Add your first transaction below",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Group transactions by date
            final grouped = _groupTransactionsByDate(txns);

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final date = grouped.keys.elementAt(index);
                final dateTxns = grouped[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                      child: Text(
                        _formatDateHeader(date),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                    // Transactions for this date
                    ...dateTxns.map((t) => _transactionTile(t)),
                    const SizedBox(height: 8),
                  ],
                );
              }, childCount: grouped.length),
            );
          }),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddTransaction(context, controller),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Transaction',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Map<DateTime, List<FriendTransactionModel>> _groupTransactionsByDate(
    List<FriendTransactionModel> transactions,
  ) {
    final Map<DateTime, List<FriendTransactionModel>> grouped = {};

    for (var txn in transactions) {
      final dateOnly = DateTime(txn.date.year, txn.date.month, txn.date.day);
      if (grouped[dateOnly] == null) {
        grouped[dateOnly] = [];
      }
      grouped[dateOnly]!.add(txn);
    }

    // Sort by date descending
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }

  Widget _balanceCard(FriendModel friend) {
    Color color;
    String text;
    IconData icon;

    if (friend.balance > 0) {
      color = AppColors.lend;
      text = "will give you";
      icon = Icons.arrow_downward;
    } else if (friend.balance < 0) {
      color = AppColors.borrow;
      text = "you owe";
      icon = Icons.arrow_upward;
    } else {
      color = Colors.green;
      text = "settled up";
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: color.withOpacity(0.1),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  friend.balance == 0
                      ? "₹0"
                      : "₹${friend.balance.abs().toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionTile(FriendTransactionModel t) {
    Color color;
    String label;
    IconData icon;

    if (t.type == TransactionType.lend) {
      color = AppColors.lend;
      label = "You lent";
      icon = Icons.arrow_downward;
    } else if (t.type == TransactionType.borrow) {
      color = AppColors.borrow;
      label = "You borrowed";
      icon = Icons.arrow_upward;
    } else {
      color = AppColors.settled;
      label = "Settlement";
      icon = Icons.check_circle;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _formatTime(t.date),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${t.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (t.note.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      t.note,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  void _showAddTransaction(BuildContext context, FriendController controller) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final selectedType = TransactionType.lend.obs;
    final selectedDate = DateTime.now().obs;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Add Transaction",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Amount
                const Text(
                  "Amount",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                _input(
                  controller: amountCtrl,
                  hint: "Enter amount",
                  keyboardType: TextInputType.number,
                  prefixText: "₹ ",
                ),
                const SizedBox(height: 20),

                // Note
                const Text(
                  "Note (Optional)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                _input(controller: noteCtrl, hint: "Add a note", maxLines: 2),
                const SizedBox(height: 20),

                // Transaction Type
                const Text(
                  "Transaction Type",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Row(
                    children: [
                      _typeChip(
                        label: "Lend",
                        color: AppColors.lend,
                        icon: Icons.arrow_downward,
                        isSelected: selectedType.value == TransactionType.lend,
                        onTap: () => selectedType.value = TransactionType.lend,
                      ),
                      const SizedBox(width: 10),
                      _typeChip(
                        label: "Borrow",
                        color: AppColors.borrow,
                        icon: Icons.arrow_upward,
                        isSelected:
                            selectedType.value == TransactionType.borrow,
                        onTap: () =>
                            selectedType.value = TransactionType.borrow,
                      ),
                      const SizedBox(width: 10),
                      _typeChip(
                        label: "Settle",
                        color: AppColors.settled,
                        icon: Icons.check_circle,
                        isSelected:
                            selectedType.value == TransactionType.settlement,
                        onTap: () =>
                            selectedType.value = TransactionType.settlement,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Date Picker
                Obx(
                  () => InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.value,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
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
                              const Text(
                                "Transaction Date",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat(
                              'MMM d, yyyy',
                            ).format(selectedDate.value),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
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
                      backgroundColor: AppColors.primary,
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
                        );
                        return;
                      }

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
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefixText,
        prefixStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _typeChip({
    required String label,
    required Color color,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? color : Colors.grey, size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
