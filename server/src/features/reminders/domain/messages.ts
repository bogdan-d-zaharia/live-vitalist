import { mealType, reminderType } from './types';
import { NotificationPayload } from '../../../core/notifications/domain/NotificationInterfaces';

export function buildReminderMessage(type: reminderType, meal: mealType): NotificationPayload {
    switch (type) {
        case 'reminder':
            return {
                title: `How was your ${meal}?`,
                body: `Don't forget to log it to keep your day on track.`,
            };
        case 'second-reminder':
            return {
                title: `Got 5 minutes?`,
                body: `Track your ${meal}, even an approximation is better than skipping.`,
            };
        case '>day':
            return {
                title: `It's been a day,`,
                body: `but don't let this put you on a stop.\n` +
                    `What is the best decision you can make at this moment? ` +
                    `What will put you back on track?`,
            };
        case '>week':
            return {
                title: `We couldn't generate your weekly report!`,
                body: `Can you help us fix the problem? And maybe next week will be your best one yet!`,
            };
    }
}
