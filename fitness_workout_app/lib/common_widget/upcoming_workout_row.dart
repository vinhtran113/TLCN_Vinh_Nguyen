import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:fitness_workout_app/common/colo_extension.dart';
import 'package:flutter/material.dart';

class UpcomingWorkoutRow extends StatefulWidget {
  final Map wObj;
  const UpcomingWorkoutRow({super.key, required this.wObj});

  @override
  State<UpcomingWorkoutRow> createState() => _UpcomingWorkoutRowState();
}

class _UpcomingWorkoutRowState extends State<UpcomingWorkoutRow> {
  bool positive = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              widget.wObj["image"].toString(),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.wObj["title"].toString(),
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.wObj["time"].toString(),
                  style: TextStyle(
                    color: TColor.gray,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
                child: PopupMenuButton<String>(
                  icon: Image.asset(
                    "assets/img/More_V.png",
                    width: 20,
                    height: 20,
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Hành động Edit
                    } else if (value == 'remove') {
                      // Hành động Remove
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'remove',
                      child: Text('Remove'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
                child: Transform.scale(
                  scale: 0.7,
                  child: CustomAnimatedToggleSwitch<bool>(
                    current: positive,
                    values: [false, true],

                    indicatorSize: Size.square(30.0),
                    animationDuration:
                    const Duration(milliseconds: 200),
                    animationCurve: Curves.linear,
                    onChanged: (b) => setState(() => positive = b),
                    iconBuilder: (context, local, global) {
                      return const SizedBox();
                    },
                    iconsTappable: true,
                    wrapperBuilder: (context, global, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                              left: 10.0,
                              right: 10.0,

                              height: 30.0,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: TColor.thirdG),
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(50.0)),
                                ),
                              )),
                          child,
                        ],
                      );
                    },
                    foregroundIndicatorBuilder: (context, global) {
                      return SizedBox.fromSize(
                        size: const Size(10, 10),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(50.0)),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black38,
                                  spreadRadius: 0.05,
                                  blurRadius: 1.1,
                                  offset: Offset(0.0, 0.8))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
