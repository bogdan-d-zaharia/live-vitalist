import express, { Request, Response } from 'express';
import cors from 'cors';
import { getMessaging } from 'firebase-admin/messaging';
import { getDatabase } from 'firebase-admin/database';
import { buildReminderMessage } from '../features/reminders/domain/messages';
import { FcmNotificationSender } from '../core/notifications/data/FcmNotificationSender';
import { INotificationSender } from '../core/notifications/domain/NotificationInterfaces';
import { loadWeekReport } from '../features/reports/data/loadWeekReport';

const app = express();
app.use(cors());
app.use(express.json());

app.post('/api/save-token', async (req: Request, res: Response) => {
    try {
        const { fcmToken, userId } = req.body;
        await getDatabase().ref(`server/active_users/${userId}/fcm_tokens/${fcmToken}`).set(true);
        res.status(200).json({ success: true, message: 'Token sent!' });
    } catch (error) {
        console.error('FCM Error:', error);
        res.status(500).json({ error: 'An error has occurred when sending the FCM token.' });
    }
});

app.post('/api/trigger-report', async (req: Request, res: Response) => {
    try {
        const { fcmToken, userId } = req.body;

        const message = {
            token: fcmToken,
            notification: {
                title: 'Weekly Nutritional Report',
                body: 'Your statistics for this week are ready!',
            },
        };

        await getMessaging().send(message);

        res.status(200).json({ success: true, message: 'Weekly report sent!' });
    } catch (error) {
        console.error('FCM Error:', error);
        res.status(500).json({ error: 'An error has occurred when sending the report notification.' });
    }
});

app.get('/api/load-legal-versions', async (req: Request, res: Response) => {
    try {
        res.status(200).json({
            termsOfUse: "2025_04_15",
            privacyPolicy: "2025_04_15",
        });
    } catch (error) {
        console.error('API Error:', error);
        res.status(500).json({ error: 'An error has occurred while sending the legal versions.' });
    }
});

app.get('/api/:userId/load-latest-week-report', async (req: Request, res: Response) => {
    try {
        const userId = req.params.userId as string;
        const wr = await loadWeekReport(userId);
        res.status(200).json(wr);
    } catch (error) {
        console.error('API Error:', error);
        res.status(500).json({ error: 'An error has occurred while sending the latest week report.' });
    }
});

app.post('/api/trigger-reminder', async (req: Request, res: Response) => {
    try {
        const { fcmToken, meal } = req.body;

        const payload = buildReminderMessage('reminder', meal);
        const sender: INotificationSender = new FcmNotificationSender();
        await sender.send(fcmToken, payload);

        res.status(200).json({ success: true, message: 'Reminder sent!' });
    } catch (error) {
        console.error('FCM Error:', error);
        res.status(500).json({ error: 'An error has occurred when sending the reminder notification.' });
    }
});

export default app;
