import { z } from "zod";

// ── Schema para datos de asistente ──────────────────────────────────────────

export const asistenteSchema = z.object({
	nombre: z
		.string()
		.min(2, "El nombre debe tener al menos 2 caracteres")
		.max(200, "El nombre no puede exceder 200 caracteres")
		.regex(
			/^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s'-]+$/,
			"El nombre solo puede contener letras, espacios, apóstrofes y guiones",
		)
		.transform((val) => val.trim()),

	documento: z
		.string()
		.min(7, "El DNI debe tener al menos 7 caracteres")
		.max(15, "El documento no puede exceder 15 caracteres")
		.regex(/^[a-zA-Z0-9]+$/, "El documento debe ser alfanumérico")
		.transform((val) => val.trim().toUpperCase()),
});

export type AsistenteInput = z.infer<typeof asistenteSchema>;

// ── Schema para reserva ─────────────────────────────────────────────────────

export const reservaSchema = z.object({
	evento_id: z
		.string()
		.min(1, "El evento es requerido")
		.max(50, "ID de evento inválido")
		.regex(/^[a-zA-Z0-9_-]+$/, "ID de evento inválido"),

	zona_id: z
		.string()
		.min(1, "La zona es requerida")
		.max(50, "ID de zona inválido")
		.regex(/^[a-zA-Z0-9_-]+$/, "ID de zona inválido"),

	cantidad: z
		.number()
		.int("La cantidad debe ser un número entero")
		.min(1, "Debe seleccionar al menos 1 entrada")
		.max(5, "Máximo 5 entradas por compra"),

	nombre_comprador: z
		.string()
		.min(2, "El nombre debe tener al menos 2 caracteres")
		.max(200, "El nombre no puede exceder 200 caracteres")
		.regex(
			/^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s'-]+$/,
			"El nombre solo puede contener letras, espacios, apóstrofes y guiones",
		)
		.transform((val) => val.trim()),

	email_comprador: z
		.string()
		.min(1, "El correo electrónico es requerido")
		.email("El correo electrónico no es válido")
		.transform((val) => val.trim().toLowerCase()),

	dni_comprador: z
		.string()
		.min(7, "El DNI debe tener al menos 7 caracteres")
		.max(15, "El DNI no puede exceder 15 caracteres")
		.regex(/^[0-9]+$/, "El DNI solo puede contener números")
		.transform((val) => val.trim()),
});

export type ReservaInput = z.infer<typeof reservaSchema>;

// ── Schema para crear/editar evento ─────────────────────────────────────────

export const eventoSchema = z.object({
	nombre: z
		.string()
		.min(3, "El nombre debe tener al menos 3 caracteres")
		.max(200, "El nombre no puede exceder 200 caracteres"),

	artista: z
		.string()
		.min(2, "El artista debe tener al menos 2 caracteres")
		.max(200, "El artista no puede exceder 200 caracteres"),

	venue: z
		.string()
		.min(3, "El venue debe tener al menos 3 caracteres")
		.max(300, "El venue no puede exceder 300 caracteres"),

	fecha: z.string().min(1, "La fecha es requerida"),

	categoria: z.string().min(1, "La categoría es requerida"),

	imagen_url: z
		.string()
		.url("La URL de la imagen no es válida")
		.optional()
		.or(z.literal("")),

	descripcion: z
		.string()
		.max(1000, "La descripción no puede exceder 1000 caracteres")
		.optional(),

	zonas: z
		.array(
			z.object({
				id: z.string().min(1, "ID requerido"),
				nombre: z.string().min(1, "Nombre requerido"),
				precio: z.number().min(0, "Precio debe ser positivo"),
				stock_total: z.number().int().min(0, "Stock debe ser positivo"),
			}),
		)
		.min(1, "Debe tener al menos una zona"),
});

export type EventoInput = z.infer<typeof eventoSchema>;

// ── Schema para confirmar compra ────────────────────────────────────────────

export const confirmarCompraSchema = z.object({
	reserva_id: z.string().uuid("ID de reserva inválido"),

	asistentes: z
		.array(asistenteSchema)
		.min(1, "Debe proporcionar al menos un asistente")
		.max(5, "Máximo 5 asistentes por compra"),
});

export type ConfirmarCompraInput = z.infer<typeof confirmarCompraSchema>;

// ── Helpers de validación ───────────────────────────────────────────────────

export function validateField<T extends z.ZodType>(
	schema: T,
	data: unknown,
): { success: true; data: z.infer<T> } | { success: false; error: string } {
	const result = schema.safeParse(data);

	if (result.success) {
		return { success: true, data: result.data };
	}

	const firstError = result.error.issues[0];
	return {
		success: false,
		error: firstError.message,
	};
}

export function validateForm<T extends z.ZodType>(
	schema: T,
	data: unknown,
):
	| { success: true; data: z.infer<T> }
	| { success: false; errors: Record<string, string> } {
	const result = schema.safeParse(data);

	if (result.success) {
		return { success: true, data: result.data };
	}

	const errors: Record<string, string> = {};
	for (const issue of result.error.issues) {
		const path = issue.path.join(".");
		if (!errors[path]) {
			errors[path] = issue.message;
		}
	}

	return { success: false, errors };
}
