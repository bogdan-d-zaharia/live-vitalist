import dotenv from 'dotenv';
import { initializeApp, cert } from 'firebase-admin/app';
import app from './api';
import { sendRemindersLoop } from './workers/send_reminders_script';

dotenv.config();
initializeApp({
    credential: cert(process.env.GOOGLE_APPLICATION_CREDENTIALS!),
    databaseURL: process.env.DATABASE_URL
});

const PORT = process.env.PORT;
const LOCAL_URL = process.env.PORT;
app.listen(PORT, () => {
    console.log(`Server running at: ${LOCAL_URL}`);
});

setInterval(() => {
    sendRemindersLoop().catch((error) => {
        console.error('Worker error:', error);
    });
}, 30 * 60 * 1000);
