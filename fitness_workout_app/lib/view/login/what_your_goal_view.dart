import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_workout_app/view/login/welcome_view.dart';
import 'package:flutter/material.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../../services/auth.dart';
import 'activate_account.dart';

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key});

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  CarouselSliderController buttonCarouselController = CarouselSliderController();
  String selectedGoal = "Weight Loss";
  int currentIndex = 0;

  List goalArr = [
    {
      "image": "assets/img/goal_1.png",
      "title": "Weight Loss",
      "subtitle":
      "I want to lose weight to improve \nmy health and have \na healthier body."
    },
    {
      "image": "assets/img/goal_2.png",
      "title": "Increase Fitness",
      "subtitle":
      "I want to combine weight loss with \nincreasing endurance and strength \nfor a more active lifestyle."
    },
    {
      "image": "assets/img/goal_3.png",
      "title": "Fat Loss & Toning",
      "subtitle":
      "I want to focus on reducing fat,\nespecially in the abdominal area, \nand improving my body shape."
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: CarouselSlider(
                  items: goalArr.map((gObj) =>
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: TColor.primaryG,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: media.width * 0.1, horizontal: 25),
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Column(
                              children: [
                                Image.asset(
                                  gObj["image"].toString(),
                                  width: media.width * 0.5,
                                  fit: BoxFit.fitWidth,
                                ),
                                SizedBox(
                                  height: media.width * 0.1,
                                ),
                                Text(
                                  gObj["title"].toString(),
                                  style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  width: media.width * 0.1,
                                  height: 1,
                                  color: TColor.white,
                                ),
                                SizedBox(
                                  height: media.width * 0.02,
                                ),
                                Text(
                                  gObj["subtitle"].toString(),
                                  textAlign: TextAlign.center,
                                  style:
                                  TextStyle(
                                      color: TColor.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ).toList(),
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 0.7,
                    aspectRatio: 0.74,
                    initialPage: currentIndex,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index; // Cập nhật chỉ số hiện tại
                        selectedGoal = goalArr[index]["title"]; // Cập nhật selectedGoal
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                width: media.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Text(
                      "What is your goal?",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "It will help us to choose a best\nprogram for you",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: TColor.gray, fontSize: 12),
                    ),
                    const Spacer(),
                    RoundButton(
                        title: "Confirm",
                        onPressed:() async {
                          await AuthService().updateUserLevel(
                              FirebaseAuth.instance.currentUser!.uid, selectedGoal);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeView(),
                            ),
                          );
                        }),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

