/**
 * API Client para TicketPass Backend
 *
 * Centraliza todas las llamadas a la API REST.
 * En producción, las peticiones pasan por Nginx proxy.
 * En desarrollo, usa la variable de entorno API_URL.
 */

const API_BASE = import.meta.env.PUBLIC_API_URL || "/api/v1";

// ── Tipos ──────────────────────────────────────────────────────────────────

export interface Evento {
	id: string;
	nombre: string;
	artista: string;
	venue: string;
	fecha: string;
	estado: string;
	imagen_url: string;
	categoria?: string;
	zonas: Zona[];
}

export interface Zona {
	id: string;
	nombre: string;
	precio: number;
	stock_total: number;
	stock_disponible: number;
}

export interface Reserva {
	reserva_id: string;
	evento_id: string;
	zona_id: string;
	cantidad: number;
	precio_unitario: number;
	precio_total: number;
	expira_en_segundos: number;
	estado: string;
}

export interface Ticket {
	ticket_id: string;
	reserva_id: string;
	evento_id: string;
	zona_id: string;
	nombre_asistente: string;
	documento_asistente: string;
	precio: number;
	fecha_compra: string;
}

export interface Compra {
	id: string;
	evento_id: string;
	evento_nombre: string;
	comprador_nombre: string;
	comprador_email: string;
	comprador_dni: string;
	zona: string;
	cantidad: number;
	total: number;
	estado: string;
	fecha: string;
	asistentes: { nombre: string; documento: string }[];
}

export interface Stats {
	total_eventos: number;
	total_compras: number;
	total_asistentes: number;
	ingresos_totales: number;
}

export interface Asistente {
	id: string;
	nombre: string;
	documento: string;
	evento_id: string;
	zona: string;
	ticket_id: string;
	precio: number;
}

// ── Helpers ────────────────────────────────────────────────────────────────

async function fetchApi<T>(path: string, options?: RequestInit): Promise<T> {
	const res = await fetch(`${API_BASE}${path}`, {
		headers: { "Content-Type": "application/json" },
		...options,
	});

	if (!res.ok) {
		const error = await res
			.json()
			.catch(() => ({ error: "Error desconocido" }));
		throw new Error(error.error || `HTTP ${res.status}`);
	}

	return res.json();
}

// ── API Methods ────────────────────────────────────────────────────────────

// Eventos
export const eventosApi = {
	listar: () => fetchApi<Evento[]>("/eventos"),
	obtener: (id: string) => fetchApi<Evento>(`/eventos/${id}`),
	crear: (data: Partial<Evento>) =>
		fetchApi<{ id: string; mensaje: string }>("/admin/eventos", {
			method: "POST",
			body: JSON.stringify(data),
		}),
	actualizar: (id: string, data: Partial<Evento>) =>
		fetchApi<{ mensaje: string }>(`/admin/eventos/${id}`, {
			method: "PUT",
			body: JSON.stringify(data),
		}),
	eliminar: (id: string) =>
		fetchApi<{ mensaje: string }>(`/admin/eventos/${id}`, {
			method: "DELETE",
		}),
};

// Compras
export const comprasApi = {
	reservar: (data: {
		evento_id: string;
		zona_id: string;
		cantidad: number;
		nombre_comprador: string;
		email_comprador: string;
		dni_comprador: string;
	}) =>
		fetchApi<Reserva>("/compras/reservar", {
			method: "POST",
			body: JSON.stringify(data),
		}),

	confirmar: (data: {
		reserva_id: string;
		asistentes: { nombre: string; documento: string }[];
	}) =>
		fetchApi<{
			estado: string;
			compra_id: string;
			tickets: Ticket[];
			mensaje: string;
		}>("/compras/confirmar", { method: "POST", body: JSON.stringify(data) }),

	estadoCola: () => fetchApi<{ longitud: number }>("/compras/cola/estado"),
};

// Admin
export const adminApi = {
	stats: () => fetchApi<Stats>("/admin/stats"),
	compras: () => fetchApi<Compra[]>("/admin/compras"),
	asistentes: () => fetchApi<Asistente[]>("/admin/asistentes"),
};
