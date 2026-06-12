import 'package:expenso/models/friend.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendsRepository extends GetxController {
  static FriendsRepository get instance => Get.find();

  final _client = Supabase.instance.client;

  String get _currentUserId => _client.auth.currentUser!.id;

  // ── Fetch all friends for the current user ──────────────────────────────────
  Future<List<Friends>> fetchFriends() async {
    final response = await _client
        .from('friends')
        .select()
        .eq('owner_id', _currentUserId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((e) => Friends.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Check if a friend with [phone] already exists ───────────────────────────
  Future<bool> friendExistsByPhone(String phone) async {
    final response = await _client
        .from('friends')
        .select('id')
        .eq('owner_id', _currentUserId)
        .eq('phone', phone)
        .maybeSingle();

    return response != null;
  }

  // ── Insert a new friend and return the created row ──────────────────────────
  Future<Friends> addFriend({
    required String name,
    required String phone,
    String? linkedUserId,
  }) async {
    final response = await _client
        .from('friends')
        .insert({
          'owner_id': _currentUserId,
          'name': name,
          'phone': phone,
          if (linkedUserId != null) 'linked_user_id': linkedUserId,
          'closing_balance': 0.00,
        })
        .select()
        .single();

    return Friends.fromJson(response as Map<String, dynamic>);
  }

  // ── Look up a registered user by phone (for linked_user_id) ─────────────────
  Future<String?> findLinkedUserId(String phone) async {
    final response = await _client
        .from('user_profile')
        .select('id')
        .eq('number', phone)
        .maybeSingle();

    return response != null ? response['id'] as String? : null;
  }

  Future<void> updateClosingBalance(
    String friendId,
    double amount,
    String type,
  ) async {
    final response = await _client
        .from('friends')
        .select()
        .eq('id', friendId)
        .single();

    final friend = Friends.fromJson(response as Map<String, dynamic>);
    var newClosingBalance = 0.0;
    if (type == "lent") {
      newClosingBalance = friend.closingBalance + amount;
    } else if (type == "borrow") {
      newClosingBalance = friend.closingBalance - amount;
    } else {
      if (friend.closingBalance > 0) {
        newClosingBalance = friend.closingBalance - amount;
      } else {
        newClosingBalance = friend.closingBalance + amount;
      }
    }
    await _client
        .from('friends')
        .update({'closing_balance': newClosingBalance})
        .eq('id', friendId);
  }

  // ── Fetch transactions for a specific friend with pagination and sorting ──
  Future<List<Map<String, dynamic>>> fetchTransactionsByFriendId({
    required String friendId,
    required int limit,
    required int offset,
  }) async {
    final response = await _client
        .from('lend_borrow_transaction')
        .select()
        .eq('friend_id', friendId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return List<Map<String, dynamic>>.from(response as List<dynamic>);
  }
}

