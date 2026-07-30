import { NotificationPayload } from "../../../core/notifications/domain/NotificationInterfaces";

export type reminderType = 'reminder' | 'second-reminder' | '>day' | '>week';
export type mealType = 'breakfast' | 'lunch' | 'dinner';

export interface Meal {
    label: mealType;
    endMs: number;
}

export interface UserReminder {
    uid: string;
    last_active: number;
    last_reminder?: reminderType;
    fcm_tokens: string[];
}

export interface ReminderNotification {
    type: reminderType;
    payload: NotificationPayload;
}