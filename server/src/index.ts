import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { initializeApp, cert } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';
import { getDatabase } from 'firebase-admin/database';

dotenv.config();
initializeApp({
    credential: cert(process.env.GOOGLE_APPLICATION_CREDENTIALS!),
    databaseURL: process.env.DATABASE_URL
});

const app = express();
app.use(cors());
app.use(express.json());

app.post('/api/save-token', async (req: Request, res: Response) => {
    try {
        const { fcmToken, userId } = req.body;
        await getDatabase().ref(`users/${userId}/server/fcm`).set({ fcmToken: fcmToken });
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

const PORT = process.env.PORT;
app.listen(PORT, () => {
    console.log(`Server running at: http://localhost:${PORT}`);
});
