import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'notification.dart';

class AlarmService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationServices notificationServices = NotificationServices();

  Future<String> addAlarmSchedule({
    required String day,
    required String hourWakeup,
    required String hourBed,
    required String repeatInterval,
    required String uid,
    required bool notify_Bed,
    required bool notify_Wakeup,
  }) async {
    String res = "Có lỗi gì đó xảy ra";

    try {
      // Chuyển đổi chuỗi ngày và giờ thành DateTime
      final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      final DateFormat hourFormat = DateFormat('hh:mm a');
      DateTime selectedDay = dateFormat.parse(day);
      DateTime selectedHourBed = hourFormat.parse(hourBed);
      DateTime selectedHourWakeup = hourFormat.parse(hourWakeup);

      DateTime selectedDateTimeBed = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
        selectedHourBed.hour,
        selectedHourBed.minute,
      );

      DateTime selectedDateTimeWakeup = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
        selectedHourWakeup.hour,
        selectedHourWakeup.minute,
      );
      // Kiểm tra nếu thời gian đã chọn là quá khứ so với thời gian hiện tại
      if (selectedDateTimeBed.isBefore(DateTime.now())) {
        return "Error: The selected date and time cannot be in the past.";
      }
      if (selectedDateTimeWakeup.isBefore(selectedDateTimeBed)) {
        selectedDateTimeWakeup = selectedDateTimeWakeup.add(const Duration(days: 1));
      }
      CollectionReference alarmRef = _firestore.collection('Alarm');
      Map<String, dynamic> alarmData = {
        'day': day,
        'hourBed': hourBed,
        'hourWakeup': hourWakeup,
        'repeat_interval': repeatInterval,
        'uid': uid,
        'notify_Bed': notify_Bed,
        'notify_Wakeup': notify_Bed,
      };
      DocumentReference docRef = await alarmRef.add(alarmData);
      await docRef.update({
        'id': docRef.id,
      });
      if(notify_Bed) {
        // Đặt lịch thông báo
        String id_notify = await notificationServices
            .scheduleBedtimeNotification(
          id: docRef.id,
          bedtime: selectedDateTimeBed,
          repeatInterval: repeatInterval,
        );
        await docRef.update({
          'id_notify': id_notify,
        });
      }
      if(notify_Wakeup) {
        String id_notify = await notificationServices.scheduleWakeUpNotification(
            id: docRef.id,
            wakeUpTime: selectedDateTimeWakeup,
            repeatInterval: repeatInterval
        );
        await docRef.update({
          'id_notify': id_notify,
        });
      }
      res = "success";
    } catch (e) {
      return "Error adding workout schedule: $e";
    }
    return res;
  }

}