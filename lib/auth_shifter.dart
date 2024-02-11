import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase/firebase_auth.dart';

import 'layout/navigation.dart';
import 'pages/auth.dart';
import 'providers/user_detail_provider.dart';
import 'providers/user_select_provider.dart';
import 'utilities/static_data.dart';

class AuthShifter extends ConsumerWidget {
  const AuthShifter({super.key});

  void pushUserData({required WidgetRef ref}) {
    String email = AuthFB().currentUser!.email.toString();

    UserRole? role = ref.watch(userRoleProvider);
    if (role == null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(email)
          .snapshots()
          .listen((event) {
        String role = event.data()!.entries.first.value.toString();
        ref.read(userRoleProvider.notifier).setUserRole(
              role == UserRole.admin.name
                  ? UserRole.admin
                  : role == UserRole.staff.name
                      ? UserRole.staff
                      : UserRole.student,
            );
      });
    } else {
      FirebaseFirestore.instance
          .collection('${role.name}s')
          .doc(email)
          .snapshots()
          .listen((event) {
        Map<String, dynamic> userDataMap = {
          "email": email,
          "role": role.name.toString()
        };
        for (var e in event.data()!.entries) {
          userDataMap.addAll({e.key: e.value});
        }
        ref.read(userDataProvider.notifier).addUserData(userDataMap);
      }).onError((obj) {
        print(obj.message);
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: AuthFB().authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          pushUserData(ref: ref);
          return const Navigation();
        } else {
          return const MainAuthPage();
        }
      },
    );
  }
}
