import 'package:flutter/material.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/media/icons_strings.dart';
import '../../../utils/media/text_strings.dart';
import '../../../utils/theme/colors.dart';
import 'side_bar_menu_item.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: HColors.sidebarColor,
        elevation: 8,
        shape: const RoundedRectangleBorder(),
        shadowColor: HColors.lightGrey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: HColors.primary,
              padding: EdgeInsets.only(
                top: 12,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: HColors.darkGrey, width: 1.5),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: CircleAvatar(
                  //     backgroundColor: HColors.white,
                  //     radius: 20,
                  //     child: Icon(
                  //       Icons.account_circle,
                  //       size: 30,
                  //       color: HColors.primary.withValues(alpha: 0.7),
                  //     ),
                  //   ),
                  // ),
                  Flexible(
                    child: Text(
                      "Welcome, ${HTexts.admin}",
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: HColors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  SideBarMenuItem(
                    icon: HIcons.dashboardSidebar,
                    title: HTexts.dashboard,
                    route: HRoutesName.dashboard,
                  ),
                  SideBarMenuItem(
                    icon: HIcons.employee,
                    title: HTexts.employee,
                    route: HRoutesName.employeeList,
                  ),
                  SideBarMenuItem(
                    icon: HIcons.mealMenu,
                    title: HTexts.mealsAction,
                    route: HRoutesName.mealsList,
                  ),
                  SideBarMenuItem(
                    icon: HIcons.meal,
                    title: HTexts.mealsRequest,
                    route: HRoutesName.mealsRequestList,
                  ),
                  SideBarMenuItem(
                    icon: HIcons.plantSidebar,
                    title: HTexts.plant,
                    route: HRoutesName.plantList,
                  ),
                  SideBarMenuItem(
                    icon: HIcons.membersSidebar,
                    title: HTexts.members,
                    route: HRoutesName.membersList,
                  ),
                  SideBarMenuItem(
                    icon: HIcons.addMember,
                    title: HTexts.addMember,
                    route: HRoutesName.addMembers,
                  ),
                  SideBarMenuItem(
                    icon: HIcons.reportsSidebar,
                    title: HTexts.reports,
                    route: HRoutesName.mealsReports,
                  ),
                  const Divider(thickness: 1, color: HColors.grey),
                  const Spacer(),
                  SideBarMenuItem(
                    icon: HIcons.profile,
                    title: HTexts.profile,
                    route: HRoutesName.profile,
                  ),
                  SideBarMenuItem(
                    icon: HIcons.logout,
                    title: HTexts.logout,
                    route: HRoutesName.logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
