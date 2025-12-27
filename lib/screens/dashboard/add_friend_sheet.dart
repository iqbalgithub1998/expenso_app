import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/friend_controller.dart';
import '../../core/theme/app_colors.dart';

class AddFriendSheet extends StatelessWidget {
  AddFriendSheet({super.key});

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final controller = Get.find<FriendController>();

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
            "Add Friend",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          _input("Friend Name", nameCtrl),
          const SizedBox(height: 16),
          _input("Phone Number", phoneCtrl, keyboardType: TextInputType.phone),

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
                if (nameCtrl.text.isEmpty) return;

                controller.addFriend(nameCtrl.text, phoneCtrl.text);
                Get.back();
              },
              child: const Text("Add Friend"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    String hint,
    TextEditingController controller, {
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
}
