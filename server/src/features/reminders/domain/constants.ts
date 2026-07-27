import { Meal } from './types';

export const reminderMs = 60 * 60 * 1000;
export const secondReminderMs = 2 * 60 * 60 * 1000;
export const dayMs = 24 * 60 * 60 * 1000;
export const weekMs = 7 * dayMs;

export const romaniaOffsetMs = 3 * 60 * 60 * 1000;

export const meals: Meal[] = [
    { label: 'breakfast', endMs: 11 * 60 * 60 * 1000 },
    { label: 'lunch', endMs: 16 * 60 * 60 * 1000 },
    { label: 'dinner', endMs: 22 * 60 * 60 * 1000 },
];
