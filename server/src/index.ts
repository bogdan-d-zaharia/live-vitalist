import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { initializeApp, cert } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';
import { getDatabase } from 'firebase-admin/database';
import { addToDate, getISOWeek } from './core/utils/DateUtils';
import { FirebaseStorageHandler } from './core/storage/data/FirebaseHandler';
import { IStorageHandler } from './core/storage/domain/StorageInterfaces';
import { Day } from './features/day/domain/Day';
import { AlimentBankState } from './features/aliment/domain/AlimentBankState';
import { averageDays, readDayIntake } from './features/day/domain/DayExtensions';

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
        const userId = req.params.userId as string;

        const now = new Date();
        const offset = now.getDay(); // Sunday is 0, Monday is 1, ... // Current - Sunday = Current day //
        const sunday = addToDate(now, -offset);

        const fbh: IStorageHandler = new FirebaseStorageHandler();
        const recordsPath = `users/${userId}/records`;
        const paths = Array
            .from({ length: 7 }, (_, i) => addToDate(sunday, i - 6))
            .map(date =>
                `${recordsPath}/` +
                `${date.getDate()}_` +
                `${date.getMonth() + 1}_` +
                `${date.getFullYear()}`);
        const daysPromise = paths.map(path => fbh.loadJson(path));
        const days = (await Promise.all(daysPromise)) as (Day | null)[];
        const bank = await fbh.loadJson(`users/${userId}/aliment_bank`) as AlimentBankState;

        const strictDays = days.filter(Boolean) as Day[];
        const averageDay = averageDays(strictDays);
        const intake = readDayIntake(averageDay, bank);
        const completedDays = days.map(Boolean);
        const weekNumber = getISOWeek(sunday);

        res.status(200).json({
            number: weekNumber,
            averageIntake: intake,
            completedDays: completedDays,
            // tips: ['Eat more protein'],
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
