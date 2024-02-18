import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/add_certification.dart';
import '../pages/home/admin_home.dart';
import '../pages/home/staff_home.dart';
import '../pages/home/student_home.dart';
import '../providers/user_select_provider.dart';
import '../utilities/static_data.dart';
import '../utilities/theme/size_data.dart';
import '../pages/report.dart';
import '../providers/navigation_index_provider.dart';
import '../providers/drawer_provider.dart';

import '../pages/forum.dart';
import 'sidebar.dart';

class Navigation extends ConsumerStatefulWidget {
  const Navigation({super.key});

  @override
  ConsumerState<Navigation> createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation> {
  bool canPop = false;
  late GlobalKey<ScaffoldState> scaffoldKey;
  int index = 0;

  popFunction(WidgetRef ref) async {
    if (ref.read(navigationIndexProvider) == 0) {
      return true;
    } else {
      ref.read(navigationIndexProvider.notifier).jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    scaffoldKey = ref.watch(drawerKeyProvider);
    index = ref.watch(navigationIndexProvider);
    UserRole? role = ref.watch(userRoleProvider);
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    List<Widget> WidgetList = [];
    List<Map<IconData, String>> iconNameList = [];

    if (role == UserRole.admin) {
      WidgetList = [
        const AdminHome(),
        const Report(),
        const Forum(),
        const AddCertification(),
      ];
      iconNameList = [
        {Icons.home_outlined: "Home"},
        {Icons.report: "Report"},
        {Icons.forest_outlined: "Forum"},
        {Icons.add_moderator_rounded: "Certification"},
      ];
    } else if (role == UserRole.staff) {
      WidgetList = [
        const StaffHome(),
        const Forum(),
      ];
      iconNameList = [
        {Icons.home_outlined: "Home"},
        {Icons.forest_outlined: "Forum"},
      ];
    } else {
      WidgetList = [
        const StudentHome(),
        const Forum(),
      ];
      iconNameList = [
        {Icons.home_outlined: "Home"},
        {Icons.forest_outlined: "Forum"},
      ];
    }

    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: role == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : WillPopScope(
                  onWillPop: () => popFunction(ref), child: WidgetList[index]
                  // IndexedStack(
                  //   index: index,
                  //   children: WidgetList,
                  // ),
                  ),
        ),
      ),
      drawer: SideBar(
        iconNameList: iconNameList,
      ),
      drawerScrimColor: Colors.white.withOpacity(.3),
    );
  }
}
