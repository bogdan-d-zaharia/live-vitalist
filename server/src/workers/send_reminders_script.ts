import { iterateActiveUsers, saveLastReminder } from '../features/reminders/data/activeUsers';
import { buildReminderNotification } from '../features/reminders/data/reminderNotification';
import { FcmNotificationSender } from '../core/notifications/data/FcmNotificationSender';
import { INotificationSender } from '../core/notifications/domain/NotificationInterfaces';

export async function sendRemindersLoop() {
    const now = Date.now();
    const sender: INotificationSender = new FcmNotificationSender();

    for await (const user of iterateActiveUsers()) {
        const notification = buildReminderNotification(user, now);
        if (!notification) continue;

        for (const token of user.fcm_tokens) {
            await sender.send(token, notification.payload);
        }
        await saveLastReminder(user.uid, notification.type);
    }
}
