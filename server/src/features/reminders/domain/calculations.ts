import { weekMs, dayMs, secondReminderMs, reminderMs, romaniaOffsetMs, meals } from './constants';
import { mealType, reminderType } from './types';

export function calculateReminderType(diff: number): reminderType | undefined {
    if (diff > weekMs) return '>week';
    if (diff > dayMs) return '>day';
    if (diff > secondReminderMs) return 'second-reminder';
    if (diff > reminderMs) return 'reminder';
    return undefined;
}

export function calculateMealType(nowMs: number): mealType {
    const localMs = (nowMs + romaniaOffsetMs) % dayMs;
    const meal = meals.find(m => localMs < m.endMs);
    return (meal ?? meals.at(-1)!).label;
}
