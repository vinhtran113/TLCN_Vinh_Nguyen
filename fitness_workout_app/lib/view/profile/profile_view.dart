import 'package:fitness_workout_app/view/login/login_view.dart';
import 'package:fitness_workout_app/view/profile/change_goal_view.dart';
import 'package:fitness_workout_app/view/profile/edit_profile_view.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';
import '../../common_widget/title_subtitle_cell.dart';
import 'package:fitness_workout_app/model/user_model.dart';

import '../../services/auth.dart';
import '../../services/notification.dart';
import '../setting/ContactUs_View.dart';
import '../setting/PrivacyPolicy_and_TermOfUse_View.dart';
import '../setting/Statistics_Chart_View.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../tips/tips_view.dart';
import '../workout_tracker/all_history_workout_view.dart';

class ProfileView extends StatefulWidget {
  final UserModel user;
  const ProfileView({super.key, required this.user});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> _enableNotifications() async {
    // Yêu cầu quyền gửi thông báo nếu cần
    await NotificationServices().initNotifications();
    String res = await NotificationServices().loadAllNotifications();
    if(res != "success"){
      print(res);
    }
    print("Notifications enabled");
  }

  Future<void> _disableNotifications() async {
    // Hủy tất cả thông báo
    await NotificationServices().cancelAllNotifications();
    print("Notifications disabled");
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Không"),
            ),
            TextButton(
              onPressed: () async {
                // Xóa thông báo và đăng xuất
                await _localNotifications.cancelAll();
                await NotificationServices().clearNotificationArr();
                await AuthService().logOut();
                // Điều hướng đến LoginView và xóa lịch sử
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                      (route) => false, // Xóa toàn bộ route cũ
                );
              },
              child: const Text("Có"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        leading: const SizedBox(),
        title: Text(
          "Profile",
          style: TextStyle(
              color: TColor.black, fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: widget.user.pic.isNotEmpty
                        ? Image.network(
                      widget.user.pic,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      "assets/img/u2.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.user.fname} ${widget.user.lname}",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileView(user: widget.user)));
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "${widget.user.height}cm",
                      subtitle: "Height",
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "${widget.user.weight}kg",
                      subtitle: "Weight",
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "${widget.user.getAge()}yo",
                      subtitle: "Age",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SettingRow(
                      icon: "assets/img/p_activity.png",
                      title: "Activity History",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (
                                context) => const AllHistoryWorkoutView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    SettingRow(
                      icon: "assets/img/p_workout.png",
                      title: "Workout Progress",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatisticsChartView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    SettingRow(
                      icon: "assets/img/p_workout.png",
                      title: "Change Goal",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeGoalView(user: widget.user),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Other",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SettingRow(
                      icon: "assets/img/p_document.png",
                      title: "Tips",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TipsView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SettingRow(
                      icon: "assets/img/p_contact.png",
                      title: "Contact Us",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const ContactUsView()));
                      },
                    ),
                    const SizedBox(height: 8),
                    SettingRow(
                      icon: "assets/img/p_privacy.png",
                      title: "Privacy Policy",
                      onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const PrivacyPolicyandTermOfUseView()));
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SettingRow(
                      icon: "assets/img/logout.png",
                      title: "Logout",
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}