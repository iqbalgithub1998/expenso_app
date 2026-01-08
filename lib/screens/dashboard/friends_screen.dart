// import 'package:expenso/core/constants/colors.dart';
// import 'package:expenso/screens/dashboard/add_friend_sheet.dart';
// import 'package:expenso/screens/dashboard/friend_detail_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/friend_controller.dart';
// import '../../core/theme/app_colors.dart';

// class FriendsScreen extends StatelessWidget {
//   FriendsScreen({super.key});

//   final controller = Get.put(FriendController());

//   void _showAddFriendSheet() {
//     Get.bottomSheet(
//       AddFriendSheet(),
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Color _balanceColor(double balance) {
//       if (balance > 0) return Colors.green; // you will take
//       if (balance < 0) return Colors.red; // you will pay
//       return Colors.grey;
//     }

//     Color _avatarColor(double balance) {
//       if (balance > 0) return Colors.green;
//       if (balance < 0) return Colors.red;
//       return Colors.grey;
//     }

//     String _balanceLabel(double balance) {
//       if (balance > 0) return "You will take";
//       if (balance < 0) return "You will pay";
//       return "Settled";
//     }

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: TColors.secondary,
//         onPressed: _showAddFriendSheet,
//         child: const Icon(Icons.person_add, color: Colors.white),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Friends",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),

//               Expanded(
//                 child: Obx(() {
//                   if (controller.friends.isEmpty) {
//                     return Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: const [
//                           Icon(
//                             Icons.people_outline,
//                             size: 64,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(height: 12),
//                           Text(
//                             "No friends added",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   return ListView.builder(
//                     itemCount: controller.friends.length,
//                     itemBuilder: (_, i) {
//                       final f = controller.friends[i];
//                       final color = f.balance > 0
//                           ? AppColors.lend
//                           : f.balance < 0
//                           ? AppColors.borrow
//                           : AppColors.textLight;

//                       return InkWell(
//                         borderRadius: BorderRadius.circular(18),
//                         onTap: () =>
//                             Get.to(() => FriendDetailScreen(friend: f)),
//                         child: Container(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: AppColors.card,
//                             borderRadius: BorderRadius.circular(18),
//                             boxShadow: [
//                               BoxShadow(
//                                 blurRadius: 10,
//                                 color: Colors.black.withOpacity(0.04),
//                                 offset: const Offset(0, 6),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               // 👤 Avatar
//                               CircleAvatar(
//                                 radius: 22,
//                                 backgroundColor: _avatarColor(f.balance),
//                                 child: Text(
//                                   f.name.isNotEmpty
//                                       ? f.name[0].toUpperCase()
//                                       : "?",
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),

//                               const SizedBox(width: 14),

//                               // 📛 Name + status
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       f.name,
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       _balanceLabel(f.balance),
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: _balanceColor(f.balance),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               // 💰 Amount
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     f.balance == 0
//                                         ? "₹0"
//                                         : "₹${f.balance.abs()}",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: _balanceColor(f.balance),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   const Icon(
//                                     Icons.chevron_right,
//                                     size: 18,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:expenso/core/constants/colors.dart';
import 'package:expenso/screens/dashboard/add_friend_sheet.dart';
import 'package:expenso/screens/dashboard/friend_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/friend_controller.dart';
import '../../core/theme/app_colors.dart';

class FriendsScreen extends StatelessWidget {
  FriendsScreen({super.key});

  final controller = Get.put(FriendController());

  void _showAddFriendSheet() {
    Get.bottomSheet(
      AddFriendSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: TColors.secondary,
        onPressed: _showAddFriendSheet,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'Add Friend',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Friends",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Summary cards
                  Obx(() {
                    final summary = controller.getBalanceSummary();
                    return Row(
                      children: [
                        // You'll get
                        Expanded(
                          child: _buildSummaryCard(
                            label: "You'll get",
                            amount: summary['toReceive'] ?? 0,
                            color: AppColors.lend,
                            icon: Icons.arrow_downward,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // You owe
                        Expanded(
                          child: _buildSummaryCard(
                            label: "You owe",
                            amount: summary['toPay'] ?? 0,
                            color: AppColors.borrow,
                            icon: Icons.arrow_upward,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            // Friends list
            Expanded(
              child: Obx(() {
                if (controller.friends.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "No friends added yet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tap the button below to add your first friend",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Separate friends by balance status
                final toReceive =
                    controller.friends.where((f) => f.balance > 0).toList()
                      ..sort((a, b) => b.balance.compareTo(a.balance));

                final toPay =
                    controller.friends.where((f) => f.balance < 0).toList()
                      ..sort((a, b) => a.balance.compareTo(b.balance));

                final settled = controller.friends
                    .where((f) => f.balance == 0)
                    .toList();

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // To Receive Section
                    if (toReceive.isNotEmpty) ...[
                      _buildSectionHeader(
                        "To Receive",
                        toReceive.length,
                        AppColors.lend,
                      ),
                      const SizedBox(height: 12),
                      ...toReceive.map((f) => _buildFriendCard(f)),
                      const SizedBox(height: 20),
                    ],

                    // To Pay Section
                    if (toPay.isNotEmpty) ...[
                      _buildSectionHeader(
                        "To Pay",
                        toPay.length,
                        AppColors.borrow,
                      ),
                      const SizedBox(height: 12),
                      ...toPay.map((f) => _buildFriendCard(f)),
                      const SizedBox(height: 20),
                    ],

                    // Settled Section
                    if (settled.isNotEmpty) ...[
                      _buildSectionHeader(
                        "Settled",
                        settled.length,
                        Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      ...settled.map((f) => _buildFriendCard(f)),
                    ],

                    const SizedBox(height: 80), // Space for FAB
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendCard(dynamic friend) {
    final color = friend.balance > 0
        ? AppColors.lend
        : friend.balance < 0
        ? AppColors.borrow
        : AppColors.textLight;

    final balanceLabel = friend.balance > 0
        ? "will give you"
        : friend.balance < 0
        ? "you owe"
        : "settled up";

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Get.to(() => FriendDetailScreen(friend: friend)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: friend.balance == 0
                ? Colors.grey.withOpacity(0.2)
                : color.withOpacity(0.2),
            width: 1,
          ),
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
            // Avatar with status indicator
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.7), color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      friend.name.isNotEmpty
                          ? friend.name[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (friend.balance == 0)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Name and status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    balanceLabel,
                    style: TextStyle(
                      fontSize: 13,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Amount and arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (friend.balance != 0)
                  Text(
                    "₹${friend.balance.abs().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Settled",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
