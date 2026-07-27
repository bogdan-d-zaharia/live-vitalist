import { ReminderNotification, UserReminder } from '../domain/types';
import { calculateReminderType, calculateMealType } from '../domain/calculations';
import { buildReminderMessage } from '../domain/messages';

export function buildReminderNotification(user: UserReminder, nowMs: number): ReminderNotification | null {
    const type = calculateReminderType(nowMs - user.last_active);
    if (!type || type === user.last_reminder) return null;

    const meal = calculateMealType(nowMs);
    return { type, payload: buildReminderMessage(type, meal) };
}
