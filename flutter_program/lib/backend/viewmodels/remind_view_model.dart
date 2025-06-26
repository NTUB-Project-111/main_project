import 'package:drw/backend/models/reminder.dart';
import 'package:drw/backend/services/remind_service.dart';
import 'package:drw/frontend/utility/remind_util.dart';

class RemindViewModel {
  Future<bool> updateRemind(List<Reminder> reminds) async {
    RemindService remindService = RemindService();
    for (Reminder remind in reminds) {
      if (remind.isDelete) {
        bool success = await remindService.deleteRemind(remind.userId, remind.recordId);
        if (!success) {
          return false; // 任一筆失敗就整體失敗
        }
      } else if (remind.initialFreq != remind.selectedFreq) {
        //刪除提醒
        bool success = await remindService.deleteRemind(remind.userId, remind.recordId);
        if (!success) {
          return false; // 任一筆失敗就整體失敗
        }
        //新增提醒
        final remindList = RemindUtil.createRemindList(
            remind.oktime, remind.date, remind.selectedFreq, remind.selectedTime);
        for (var userRemind in remindList) {
          success = await remindService.addRemind(
              remind.userId.toString(),
              remind.recordId.toString(),
              userRemind['day'],
              remind.selectedTime,
              remind.selectedFreq);
          if (!success) {
            return false; // 任一筆失敗就整體失敗
          }
        }

        return true;
      } else {
        bool success = await remindService.updateRemindTime(
            remind.recordId, remind.userId, remind.selectedTime.toString());

        if (!success) {
          return false; // 任一筆失敗就整體失敗
        }
      }
    }

    return true;
  }
}
