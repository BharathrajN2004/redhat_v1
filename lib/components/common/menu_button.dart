import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';
import '../../providers/drawer_provider.dart';

import 'icon.dart';

class MenuButton extends ConsumerWidget {
  const MenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalKey<ScaffoldState> scaffoldKey = ref.read(drawerKeyNotifier);
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double aspectRatio = sizeData.aspectRatio;
    return GestureDetector(
      onTap: () => scaffoldKey.currentState?.openDrawer(),
      child: Container(
        padding: EdgeInsets.all(aspectRatio * 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(aspectRatio * 14),
          color: colorData.primaryColor(1),
        ),
        child: CustomIcon(
          icon: Icons.menu_rounded,
          color: colorData.sideBarTextColor(.85),
          size: aspectRatio * 40,
        ),
      ),
    );
  }
}
