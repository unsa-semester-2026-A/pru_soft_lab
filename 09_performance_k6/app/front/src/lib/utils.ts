import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}

/**
 * Helper para generar URLs relativas que mantienen el puerto actual.
 * Soluciona el problema en desarrollo donde /eventos va al puerto 80.
 */
export function resolvePath(path: string): string {
	if (typeof window === "undefined") return path;
	return `${window.location.origin}${path}`;
}
