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
    Color _balanceColor(double balance) {
      if (balance > 0) return Colors.green; // you will take
      if (balance < 0) return Colors.red; // you will pay
      return Colors.grey;
    }

    Color _avatarColor(double balance) {
      if (balance > 0) return Colors.green;
      if (balance < 0) return Colors.red;
      return Colors.grey;
    }

    String _balanceLabel(double balance) {
      if (balance > 0) return "You will take";
      if (balance < 0) return "You will pay";
      return "Settled";
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.secondary,
        onPressed: _showAddFriendSheet,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Friends",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Obx(() {
                  if (controller.friends.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No friends added",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.friends.length,
                    itemBuilder: (_, i) {
                      final f = controller.friends[i];
                      final color = f.balance > 0
                          ? AppColors.lend
                          : f.balance < 0
                          ? AppColors.borrow
                          : AppColors.textLight;

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () =>
                            Get.to(() => FriendDetailScreen(friend: f)),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.04),
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // 👤 Avatar
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: _avatarColor(f.balance),
                                child: Text(
                                  f.name.isNotEmpty
                                      ? f.name[0].toUpperCase()
                                      : "?",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              // 📛 Name + status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      f.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _balanceLabel(f.balance),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _balanceColor(f.balance),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // 💰 Amount
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    f.balance == 0
                                        ? "₹0"
                                        : "₹${f.balance.abs()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _balanceColor(f.balance),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
