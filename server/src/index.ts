import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { initializeApp, cert } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';
import { getDatabase } from 'firebase-admin/database';
// import { readDaysFromDatabase } from './DatabaseUtils';

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

app.get('/api/:userId/load-latest-week-report', async (req: Request, res: Response) => {
    try {
        // const userId = req.params.userId as string;

        // const now = new Date();
        // const offset = now.getDay(); // Sunday is 0, Monday is 1, ... // Current - Sunday = Current day //
        // const sunday = subtractFromDate(now, offset);
        // const monday = subtractFromDate(sunday, 6);

        // const db = getDatabase();
        // const days = await readDaysFromDatabase(monday, sunday, userId, db);
        // if (!days) {
        //     res.status(200).json(null);
        //     return;
        // }

        // const path = `users/${userId}/aliment_bank`;
        // const snapshot = await db.ref(path).get();
        // if (!snapshot.exists()) {
        //     res.status(200).json(null);
        //     return;
        // }

        // const aliment_bank: { [k: string]: [v: AlimentData] } = snapshot.val();
        // const day_list = Object.values(days) as Day[]
        // const calorieAverage = getAverageCalories(day_list, aliment_bank);

        res.status(200).json({
            number: 11,
            averageCalories: 2411.0,
        });
    } catch (error) {
        console.error('FCM Error:', error);
        res.status(500).json({ error: 'An error has occurred when sending the report notification.' });
    }
});

const PORT = process.env.PORT;
app.listen(PORT, () => {
    console.log(`Server running at: http://localhost:${PORT}`);
});
