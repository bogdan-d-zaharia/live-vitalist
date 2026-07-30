import { getDatabase } from 'firebase-admin/database';
import { IStorageHandler } from '../domain/StorageInterfaces';

export class FirebaseStorageHandler implements IStorageHandler {
    private readonly db = getDatabase();

    async saveJson(path: string, json: any): Promise<boolean> {
        await this.db.ref(path).update(json);
        return true;
    }

    async loadJson(path: string): Promise<any> {
        const snapshot = await this.db.ref(path).get();
        if (snapshot.exists()) {
            return snapshot.val();
        }
        return null;
    }
}