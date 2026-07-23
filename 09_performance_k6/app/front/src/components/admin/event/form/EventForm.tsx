import { ArrowLeft, Save } from "lucide-react";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { eventoSchema } from "@/lib/validations";
import { EventBasicInfo } from "./EventBasicInfo";
import { EventFormPreviewDialog } from "./EventFormPreviewDialog";
import { EventMedia } from "./EventMedia";
import { EventZones } from "./EventZones";

interface Zona {
	id: string;
	nombre: string;
	precio: number;
	stock_total: number;
}

interface EventFormProps {
	mode: "create" | "edit";
	initialData?: {
		nombre: string;
		artista: string;
		venue: string;
		fecha: string;
		categoria: string;
		imagen_url: string;
		descripcion: string;
	};
	onSubmit: (data: any) => void;
	onCancel: () => void;
}

export function EventForm({
	mode,
	initialData,
	onSubmit,
	onCancel,
}: EventFormProps) {
	const [form, setForm] = useState(
		initialData || {
			nombre: "",
			artista: "",
			venue: "",
			fecha: "",
			categoria: "conciertos",
			imagen_url: "",
			descripcion: "",
		},
	);

	const [zonas, setZonas] = useState<Zona[]>([
		{ id: "vip", nombre: "VIP", precio: 0, stock_total: 0 },
		{ id: "pref", nombre: "Preferencial", precio: 0, stock_total: 0 },
		{ id: "gen", nombre: "General", precio: 0, stock_total: 0 },
	]);

	const [errors, setErrors] = useState<Record<string, string>>({});

	const updateForm = (field: string, value: string) => {
		setForm((prev) => ({ ...prev, [field]: value }));
		if (errors[field]) {
			setErrors((prev) => {
				const n = { ...prev };
				delete n[field];
				return n;
			});
		}
	};

	const updateZona = (index: number, field: string, value: string | number) => {
		setZonas((prev) => {
			const n = [...prev];
			n[index] = { ...n[index], [field]: value };
			return n;
		});
	};

	const addZona = () =>
		setZonas((prev) => [
			...prev,
			{ id: `zona-${prev.length + 1}`, nombre: "", precio: 0, stock_total: 0 },
		]);

	const removeZona = (index: number) => {
		if (zonas.length > 1)
			setZonas((prev) => prev.filter((_, i) => i !== index));
	};

	const handleSubmit = () => {
		const result = eventoSchema.safeParse({ ...form, zonas });

		if (!result.success) {
			const newErrors: Record<string, string> = {};
			for (const issue of result.error.issues) {
				const path = issue.path.join(".");
				if (!newErrors[path]) newErrors[path] = issue.message;
			}
			setErrors(newErrors);
			return;
		}

		setErrors({});
		onSubmit({ ...form, zonas });
	};

	return (
		<div className="mx-auto max-w-3xl space-y-6">
			{/* Header */}
			<div className="flex items-center gap-4">
				<Button variant="outline" size="icon" onClick={onCancel}>
					<ArrowLeft className="h-4 w-4" />
				</Button>
				<div>
					<h1 className="font-heading text-2xl font-bold text-foreground">
						{mode === "edit" ? "Editar Evento" : "Nuevo Evento"}
					</h1>
					<p className="text-sm text-muted-foreground">
						{mode === "edit"
							? "Modifica los datos del evento"
							: "Completa los datos del evento"}
					</p>
				</div>
			</div>

			{/* Info */}
			<Card>
				<CardHeader>
					<CardTitle>Información del evento</CardTitle>
				</CardHeader>
				<CardContent>
					<EventBasicInfo
						nombre={form.nombre}
						artista={form.artista}
						venue={form.venue}
						fecha={form.fecha}
						errors={errors}
						onChange={updateForm}
					/>
				</CardContent>
			</Card>

			{/* Media */}
			<Card>
				<CardHeader>
					<CardTitle>Imagen y categoría</CardTitle>
				</CardHeader>
				<CardContent>
					<EventMedia
						categoria={form.categoria}
						imagen_url={form.imagen_url}
						descripcion={form.descripcion}
						errors={errors}
						onChange={updateForm}
					/>
				</CardContent>
			</Card>

			{/* Zonas */}
			<Card>
				<CardHeader>
					<CardTitle>Zonas y precios</CardTitle>
				</CardHeader>
				<CardContent>
					<EventZones
						zonas={zonas}
						error={errors.zonas}
						onUpdate={updateZona}
						onAdd={addZona}
						onRemove={removeZona}
					/>
				</CardContent>
			</Card>

			{/* Actions */}
			<div className="flex items-center justify-between">
				<Button variant="outline" onClick={onCancel}>
					Cancelar
				</Button>
				<div className="flex gap-3">
					<EventFormPreviewDialog form={form} zonas={zonas} />
					<Button onClick={handleSubmit}>
						<Save className="h-4 w-4" />
						{mode === "edit" ? "Guardar Cambios" : "Crear Evento"}
					</Button>
				</div>
			</div>
		</div>
	);
}
