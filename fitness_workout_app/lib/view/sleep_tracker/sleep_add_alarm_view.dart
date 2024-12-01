import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common/common.dart';
import '../../common_widget/icon_title_next_row.dart';
import '../../common_widget/repetition_row.dart';
import '../../common_widget/round_button.dart';

class SleepAddAlarmView extends StatefulWidget {
  final DateTime date;
  const SleepAddAlarmView({super.key, required this.date});

  @override
  State<SleepAddAlarmView> createState() => _SleepAddAlarmViewState();
}

class _SleepAddAlarmViewState extends State<SleepAddAlarmView> {
  final TextEditingController selectedRepetition = TextEditingController();
  bool isBedEnabled = true;
  bool isWakeupEnabled = true;
  String selectedTimeBed = "09:00 PM";
  String selectedTimeWakeup = "06:00 AM";

  @override
  void initState() {
    super.initState();
    selectedRepetition.text = "no";
  }

  @override
  void dispose() {
    super.dispose();
    selectedRepetition.dispose();
  }

  Future<void> _selectTimeBed(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      // Cập nhật thời gian khi chọn
      setState(() {
        selectedTimeBed = pickedTime.format(context);
      });
    }
  }

  Future<void> _selectTimeWakeup(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      // Cập nhật thời gian khi chọn
      setState(() {
        selectedTimeWakeup = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Add Alarm",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Image.asset(
                "assets/img/date.png",
                width: 21,
                height: 21,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                dateToString(widget.date, formatStr: "E, dd MMMM yyyy"),
                style: TextStyle(color: TColor.gray, fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: media.width * 0.04,
          ),
          IconTitleNextRow(
            icon: "assets/img/Bed_Add.png",
            title: "Bedtime",
            time: selectedTimeBed,
            color: TColor.lightGray,
            onPressed: () => _selectTimeBed(context),
          ),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
              icon: "assets/img/HoursTime.png",
              title: "Hours of sleep",
              time: selectedTimeWakeup,
              color: TColor.lightGray,
              onPressed: () => _selectTimeWakeup(context)),
          const SizedBox(
            height: 10,
          ),
          RepetitionsRow(
            icon: "assets/img/Repeat.png",
            title: "Custom Repetitions",
            color: TColor.lightGray,
            repetitionController: selectedRepetition,
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enable Notifications Bedtime",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Switch(
                value: isBedEnabled,
                activeColor: TColor.primaryColor1,
                onChanged: (value) {
                  setState(() {
                    isBedEnabled = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enable Notifications Wakeup",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Switch(
                value: isWakeupEnabled,
                activeColor: TColor.primaryColor1,
                onChanged: (value) {
                  setState(() {
                    isWakeupEnabled = value;
                  });
                },
              ),
            ],
          ),
          const Spacer(),
          RoundButton(title: "Add", onPressed: () {}),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}