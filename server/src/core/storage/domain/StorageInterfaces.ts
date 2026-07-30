export interface IStorageHandler {
    saveJson(path: string, json: any): Promise<boolean>;
    loadJson(path: string): Promise<any>;
}
