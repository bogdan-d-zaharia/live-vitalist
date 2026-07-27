import { getMessaging } from 'firebase-admin/messaging';
import { INotificationSender, NotificationPayload } from '../domain/NotificationInterfaces';

export class FcmNotificationSender implements INotificationSender {
    public async send(token: string, payload: NotificationPayload): Promise<void> {
        await getMessaging().send({
            token,
            notification: {
                title: payload.title,
                body: payload.body,
            },
        });
    }
}
