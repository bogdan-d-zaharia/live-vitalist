export interface NotificationPayload {
    title: string;
    body: string;
}

export interface INotificationSender {
    send(token: string, payload: NotificationPayload): Promise<void>;
}
