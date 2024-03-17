import { ipcRenderer } from "electron";
import log from "electron-log";

export function logToDisk(logLine: string) {
    log.info(logLine);
}

export function openLogDirectory() {
    ipcRenderer.invoke("open-log-dir");
}

export function logError(error: Error, message: string, info?: string): void {
    ipcRenderer.invoke("log-error", error, message, info);
}
