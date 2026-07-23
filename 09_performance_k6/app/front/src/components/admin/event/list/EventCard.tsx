import { Clock, MapPin, Pencil } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import type { Evento } from "@/lib/api";
import { EventPreviewDialog } from "../preview/EventPreviewDialog";
import { EventDeleteDialog } from "./EventDeleteDialog";

interface EventCardProps {
	evento: Evento;
	onEdit: (evento: Evento) => void;
	onDelete: (id: string) => void;
}

export function EventCard({ evento, onEdit, onDelete }: EventCardProps) {
	const fecha = new Date(evento.fecha);
	const dia = fecha.getDate();
	const mes = fecha
		.toLocaleDateString("es-PE", { month: "short" })
		.toUpperCase();
	const hora = fecha.toLocaleTimeString("es-PE", {
		hour: "2-digit",
		minute: "2-digit",
	});
	const fechaCompleta = fecha.toLocaleDateString("es-PE", {
		weekday: "long",
		year: "numeric",
		month: "long",
		day: "numeric",
	});
	const precioDesde = Math.min(...(evento.zonas?.map((z) => z.precio) ?? [0]));
	const categoria = evento.categoria ?? "conciertos";

	return (
		<Card className="overflow-hidden p-0">
			{/* Image */}
			<div className="relative aspect-video overflow-hidden">
				<img
					src={evento.imagen_url}
					alt={evento.nombre}
					className="h-full w-full object-cover"
				/>
				<Badge className="absolute top-2 right-2 bg-[var(--teal)] text-[var(--deep-purple)]">
					{categoria}
				</Badge>
				<div className="absolute top-2 left-2 flex flex-col items-center rounded-md bg-primary px-2 py-1 text-primary-foreground">
					<span className="text-[0.6rem] font-bold leading-none">{mes}</span>
					<span className="text-sm font-bold leading-none">{dia}</span>
				</div>
			</div>

			<CardContent className="space-y-3 p-4">
				<div>
					<h3 className="font-heading font-semibold text-card-foreground line-clamp-1">
						{evento.nombre}
					</h3>
					<p className="text-sm text-primary">{evento.artista}</p>
				</div>

				<div className="flex flex-col gap-1 text-xs text-muted-foreground">
					<span className="flex items-center gap-1">
						<MapPin className="h-3 w-3" />
						{evento.venue}
					</span>
					<span className="flex items-center gap-1">
						<Clock className="h-3 w-3" />
						{fechaCompleta} - {hora}
					</span>
				</div>

				<div className="flex items-center justify-between pt-2 border-t border-border">
					<span className="text-lg font-bold text-card-foreground">
						S/ {precioDesde.toFixed(2)}
					</span>

					<div className="flex gap-1">
						<EventPreviewDialog evento={evento} />
						<Button
							variant="ghost"
							size="icon-sm"
							onClick={() => onEdit(evento)}
						>
							<Pencil className="h-4 w-4" />
						</Button>
						<EventDeleteDialog
							eventoNombre={evento.nombre}
							onDelete={() => onDelete(evento.id)}
						/>
					</div>
				</div>
			</CardContent>
		</Card>
	);
}
