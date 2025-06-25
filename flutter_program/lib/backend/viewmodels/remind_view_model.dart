import 'package:drw/backend/models/reminder.dart';
import 'package:drw/backend/services/remind_service.dart';

class RemindViewModel {
  Future<bool> updateRemind(List<Reminder> reminds) async {
    RemindService remindService = RemindService();
    for (Reminder remind in reminds) {
      if (remind.initialFreq != remind.selectedFreq) {
        // 後端刪除再新增提醒（你可以在這裡加上相應邏輯）
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
