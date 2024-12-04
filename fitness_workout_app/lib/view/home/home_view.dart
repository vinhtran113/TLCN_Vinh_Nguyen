import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../../common/colo_extension.dart';
import '../../services/alarm.dart';
import '../../services/workout_tracker.dart';
import 'notification_view.dart';
import 'package:fitness_workout_app/model/user_model.dart';

class HomeView extends StatefulWidget {
  final UserModel user;

  const HomeView({super.key, required this.user});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AlarmService _alarmService = AlarmService();
  final WorkoutService _workoutService = WorkoutService();
  String totalTime = '0 hours 0 minutes';
  List<FlSpot> calorieSpots= [];
  List<FlSpot> durationSpots= [];
  double BMI = 0.0;
  int caloToday = 0;

  @override
  void initState() {
    super.initState();
    _loadTimeSleepLastNight();
    _loadFLSpot();
    _calculateBMI();
    _calculateTodayCalories();
  }

  void _loadTimeSleepLastNight() async {
    int total = await _alarmService.calculateTotalSleepTime(
        uid: widget.user.uid);

    setState(() {
      int hours = total ~/ 60;
      int minutes = total % 60;
      totalTime = '$hours hours $minutes minutes';
    });
  }

  void _loadFLSpot() async {
    Map<String, List<FlSpot>> data = await _workoutService.generateWeeklyData(
        uid: widget.user.uid);
    setState(() {
      calorieSpots = data['calories']!;
      durationSpots = data['duration']!;
    });
  }

  void _calculateBMI() async {
    try {
      // Chuyển đổi height và weight từ String sang double
      double height = double.parse(widget.user.height);
      double weight = double.parse(widget.user.weight);

      // Kiểm tra nếu giá trị hợp lệ
      if (height <= 0 || weight <= 0) {
        throw Exception("Height and weight must be greater than zero.");
      }
      // Công thức tính BMI: weight (kg) / (height (m) ^ 2)
      height = height / 100;
      double bmi = weight / (height * height);
      bmi = double.parse(bmi.toStringAsFixed(1));
      print("calculating BMI: $bmi");
      setState(() {
        BMI =  bmi;
      });
    } catch (e) {
      print("Error calculating BMI: $e");
    }
  }

  String _getStatus(double bmi){
    String bmiStatus;

    if (bmi < 18.5) {
      bmiStatus = "You are underweight";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      bmiStatus = "You have a normal weight";
    } else if (bmi >= 25 && bmi < 29.9) {
      bmiStatus = "You are overweight";
    } else if (bmi >= 30 && bmi < 34.9) {
      bmiStatus = "You are level 1 obese";
    } else {
      bmiStatus = "You are obese level 2 or higher";
    }
    return bmiStatus;
  }

  String _calculateCalories() {
    // Tính BMR
    double bmr;
    int age = widget.user.getAge();
    double height = double.parse(widget.user.height);
    double weight = double.parse(widget.user.weight);
    if (widget.user.gender == "Male") {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }

    // Tính TDEE
    double tdee = bmr * 1.55;

    // Cân nặng lý tưởng
    double idealWeight = 21 * (height / 100) * (height / 100);

    // Chênh lệch cân nặng
    double weightDiff = weight - idealWeight;

    // Lượng calo cần thâm hụt mỗi ngày (300-1000 kcal tùy tốc độ mong muốn)
    double caloricDeficitPerDay = weightDiff > 0 ? 500 : 0;

    // Lượng calo hàng ngày
    double adjustedCalories = tdee - caloricDeficitPerDay;

    adjustedCalories = double.parse(adjustedCalories.toStringAsFixed(1));

    String calo = '  Today target ${adjustedCalories.toString()} KCal';

    return calo;
  }

  Future<void> _calculateTodayCalories() async {
    int calo = await  _workoutService.calculateTodayCalories(widget.user.uid);
    setState(() {
      caloToday = calo;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back,",
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                        Text(
                          "${widget.user.fname} ${widget.user.lname}",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationView(),
                          ),
                        );
                      },
                      icon: Image.asset(
                            "assets/img/notification_inactive.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                  height: media.width * 0.4,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG),
                      borderRadius: BorderRadius.circular(media.width * 0.075)),
                  child: Stack(alignment: Alignment.center, children: [
                    Image.asset(
                      "assets/img/bg_dots.png",
                      height: media.width * 0.4,
                      width: double.maxFinite,
                      fit: BoxFit.fitHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: media.width * 0.025,
                              ),
                              Text(
                                "BMI (Body Mass Index)",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                _getStatus(BMI),
                                style: TextStyle(
                                    color: TColor.white.withOpacity(0.7),
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {},
                                ),
                                startDegreeOffset: 250,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius: 0,
                                sections: showingSections(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Activity Status",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sleep Card
                      Container(
                        width: double.infinity,
                        height: media.width * 0.45,
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 2),
                          ],
                          image: DecorationImage(
                            image: AssetImage("assets/img/sleep_grap.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "  Sleep",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 96,
                            ),
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: TColor.secondaryG,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                              },
                              child: Text(
                                totalTime,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      // Calories Card
                      Container(
                        width: double.infinity,
                        height: media.width * 0.45,
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 2),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "  Calories",
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: TColor.primaryG,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                              },
                              child: Text(
                                _calculateCalories(),
                                style: TextStyle(
                                  color: TColor.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Center(
                              child: SizedBox(
                                width: media.width * 0.2,
                                height: media.width * 0.2,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Circular Progress Indicator Background
                                    Container(
                                      width: media.width * 0.15,
                                      height: media.width * 0.15,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: TColor.primaryG),
                                        shape: BoxShape.circle,
                                      ),
                                      child: FittedBox(
                                        child: Text(
                                          "$caloToday kCal\nleft",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: TColor.white,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Circular Progress Bar
                                    SimpleCircularProgressBar(
                                      progressStrokeWidth: 10,
                                      backStrokeWidth: 10,
                                      progressColors: TColor.primaryG,
                                      backColor: Colors.grey.shade100,
                                      valueNotifier: ValueNotifier(100),
                                      startAngle: -180,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Workout Progress",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 15),
                    height: media.width * 0.5,
                    width: double.maxFinite,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          enabled: true,
                          handleBuiltInTouches: true,
                          touchTooltipData: LineTouchTooltipData(
                            tooltipRoundedRadius: 10,
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((spot) {
                                // Xác định loại dữ liệu (calo hoặc thời gian)
                                String valueSuffix;
                                String valueLabel;

                                // Nếu là calo
                                if (spot.barIndex == 0) {
                                  valueSuffix = 'KCal';
                                  valueLabel = 'Calo: ${spot.y.toStringAsFixed(2)} $valueSuffix';
                                }
                                // Nếu là thời gian, chia cho 60 để có phút
                                else {
                                  valueSuffix = 'Mins';
                                  double minutes = spot.y / 60;
                                  valueLabel = 'Time: ${minutes.toStringAsFixed(2)} $valueSuffix';
                                }

                                return LineTooltipItem(
                                  valueLabel,
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        lineBarsData: lineBarsData1,
                        minY: -0.5,
                        maxY: 3000,
                        titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(),
                            topTitles: AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: bottomTitles,
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: rightTitles,
                            )),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 25,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: TColor.white.withOpacity(0.15),
                              strokeWidth: 2,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),),
                SizedBox(
                  height: media.width * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
          (i) {
        var color0 = TColor.secondaryColor1;

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color0,
                value: BMI,
                title: '',
                radius: 55,
                titlePositionPercentageOffset: 0.55,
                badgeWidget: Text(
                  BMI.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ));
          case 1:
            return PieChartSectionData(
              color: Colors.white,
              value: 100 - BMI,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
            );

          default:
            throw Error();
        }
      },
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedBarSpot) => Colors.blueGrey.withOpacity(0.8),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,
  ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(colors: [
      TColor.primaryColor2.withOpacity(0.5),
      TColor.primaryColor1.withOpacity(0.5),
    ]),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: calorieSpots
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(colors: [
      TColor.secondaryColor2.withOpacity(0.5),
      TColor.secondaryColor1.withOpacity(0.5),
    ]),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
    ),
    spots: durationSpots
  );

  SideTitles get rightTitles => SideTitles(
    getTitlesWidget: rightTitleWidgets,
    showTitles: true,
    interval: 20,
    reservedSize: 40,
  );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0 KCal';
        break;
      case 500:
        text = '500';
        break;
      case 1000:
        text = '10k';
        break;
      case 1500:
        text = '15k';
        break;
      case 2000:
        text = '20k';
        break;
      case 2500:
        text = '25k';
        break;
      case 3000:
        text = '30k';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: TColor.gray,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Mon', style: style);
        break;
      case 2:
        text = Text('Tue', style: style);
        break;
      case 3:
        text = Text('Wed', style: style);
        break;
      case 4:
        text = Text('Thu', style: style);
        break;
      case 5:
        text = Text('Fri', style: style);
        break;
      case 6:
        text = Text('Sat', style: style);
        break;
      case 7:
        text = Text('Sun', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}