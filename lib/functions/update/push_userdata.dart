import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/console_logger.dart';
import '../firebase_auth.dart';

void pushUserData({required WidgetRef ref}) {
  String? email = AuthFB().currentUser?.email.toString();

  if (email != null) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        UserModel userModel = UserModel.fromJson(event.data()!);
        ref.read(userDataProvider.notifier).addUserData(userModel);
      } else {
        ref
            .read(userDataProvider.notifier)
            .setUserNotFound(value: "UserData not found");
      }
    }).onError((obj) {
      ConsoleLogger.error(obj.message, from: "pushUserData");
    });
  }
}
