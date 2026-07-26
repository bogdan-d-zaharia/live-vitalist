import { expect, test } from 'vitest';
import { getISOWeek } from '../src/core/utils/DateUtils';

test('ISO week: 29 Dec 2025 - 4 Jan 2026 +- 1', () => {
    expect(getISOWeek(new Date(2025, 11, 28))).toBe(52);
    expect(getISOWeek(new Date(2025, 11, 30))).toBe(1);
    expect(getISOWeek(new Date(2025, 11, 31))).toBe(1);
    expect(getISOWeek(new Date(2026, 0, 1))).toBe(1);
    expect(getISOWeek(new Date(2026, 0, 2))).toBe(1);
    expect(getISOWeek(new Date(2026, 0, 3))).toBe(1);
    expect(getISOWeek(new Date(2026, 0, 4))).toBe(1);
    expect(getISOWeek(new Date(2026, 0, 5))).toBe(2);
});

test('ISO week: 12-18 Oct 2026 +- 1', () => {
    expect(getISOWeek(new Date(2026, 9, 11))).toBe(41);
    expect(getISOWeek(new Date(2026, 9, 12))).toBe(42);
    expect(getISOWeek(new Date(2026, 9, 13))).toBe(42);
    expect(getISOWeek(new Date(2026, 9, 13))).toBe(42);
    expect(getISOWeek(new Date(2026, 9, 14))).toBe(42);
    expect(getISOWeek(new Date(2026, 9, 15))).toBe(42);
    expect(getISOWeek(new Date(2026, 9, 16))).toBe(42);
    expect(getISOWeek(new Date(2026, 9, 17))).toBe(42);
    expect(getISOWeek(new Date(2026, 9, 18))).toBe(42);
    expect(getISOWeek(new Date(2026, 9, 19))).toBe(43);
});

test('ISO week: Random', () => {
    expect(getISOWeek(new Date(2026, 9, 11))).toBe(41);
    expect(getISOWeek(new Date(2026, 9, 19))).toBe(43);
    expect(getISOWeek(new Date(2025, 0, 1))).toBe(1);
    expect(getISOWeek(new Date(2025, 11, 28))).toBe(52);
    expect(getISOWeek(new Date(2026, 0, 1))).toBe(1);
    expect(getISOWeek(new Date(2027, 0, 1))).toBe(53);
    expect(getISOWeek(new Date(2020, 11, 31))).toBe(53);
    expect(getISOWeek(new Date(2026, 9, 15))).toBe(42);
    expect(getISOWeek(new Date(2026, 5, 30))).toBe(27);
    expect(getISOWeek(new Date(2026, 2, 9))).toBe(11);
});
