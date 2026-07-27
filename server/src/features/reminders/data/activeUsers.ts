import { getDatabase } from 'firebase-admin/database';
import { reminderType, UserReminder } from '../domain/types';

async function readPage(
    lastKey: string | undefined,
    pageSize: number
): Promise<{ users: UserReminder[]; nextKey?: string }> {
    let ref = getDatabase()
        .ref('server/active_users')
        .orderByChild('last_active')
        .limitToFirst(pageSize);
    if (lastKey) ref = ref.startAfter(lastKey);

    const snapshot = await ref.get();
    const users: UserReminder[] = [];
    snapshot.forEach((child) => {
        const raw = child.val();
        users.push({
            uid: child.key!,
            last_active: raw.last_active,
            last_reminder: raw.last_reminder,
            fcm_tokens: Object.keys(raw.fcm_tokens ?? {}),
        });
    });

    const nextKey = users.length ? users.at(-1)?.uid : undefined;
    return { users, nextKey };
}

export async function* iterateActiveUsers(pageSize = 20): AsyncGenerator<UserReminder> {
    let lastKey: string | undefined;
    do {
        const { users, nextKey } = await readPage(lastKey, pageSize);
        for (const user of users) yield user;
        lastKey = users.length ? nextKey : undefined;
    } while (lastKey);
}

export async function saveLastReminder(uid: string, type: reminderType): Promise<void> {
    await getDatabase().ref(`server/active_users/${uid}/last_reminder`).set(type);
}
