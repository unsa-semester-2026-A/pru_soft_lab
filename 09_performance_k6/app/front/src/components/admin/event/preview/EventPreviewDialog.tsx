import { Calendar, Clock, Eye, MapPin } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
	Dialog,
	DialogClose,
	DialogContent,
	DialogFooter,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "@/components/ui/dialog";
import { Separator } from "@/components/ui/separator";
import type { Evento } from "@/lib/api";

interface EventPreviewDialogProps {
	evento: Evento;
}

export function EventPreviewDialog({ evento }: EventPreviewDialogProps) {
	const fecha = new Date(evento.fecha);
	const fechaCompleta = fecha.toLocaleDateString("es-PE", {
		weekday: "long",
		year: "numeric",
		month: "long",
		day: "numeric",
	});
	const hora = fecha.toLocaleTimeString("es-PE", {
		hour: "2-digit",
		minute: "2-digit",
	});
	const precioDesde = Math.min(...(evento.zonas?.map((z) => z.precio) ?? [0]));
	const categoria = evento.categoria ?? "conciertos";

	return (
		<Dialog>
			<DialogTrigger render={<Button variant="ghost" size="icon-sm" />}>
				<Eye className="h-4 w-4" />
			</DialogTrigger>
			<DialogContent className="sm:max-w-lg">
				<DialogHeader>
					<DialogTitle>Vista Previa</DialogTitle>
				</DialogHeader>
				<div className="space-y-4">
					<div className="relative aspect-video overflow-hidden rounded-lg">
						<img
							src={evento.imagen_url}
							alt={evento.nombre}
							className="h-full w-full object-cover"
						/>
						<Badge className="absolute top-2 right-2 bg-[var(--teal)] text-[var(--deep-purple)]">
							{categoria}
						</Badge>
						<div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />
						<div className="absolute bottom-4 left-4">
							<span className="text-xs font-bold text-white/80 uppercase tracking-wider">
								{categoria}
							</span>
						</div>
					</div>

					<div>
						<h3 className="font-heading text-xl font-bold text-card-foreground">
							{evento.nombre}
						</h3>
						<p className="text-base font-semibold text-primary">
							{evento.artista}
						</p>
					</div>

					<div className="flex flex-wrap gap-4 text-sm text-muted-foreground">
						<span className="flex items-center gap-1.5">
							<Calendar className="h-4 w-4 text-[var(--teal)]" />
							{fechaCompleta}
						</span>
						<span className="flex items-center gap-1.5">
							<Clock className="h-4 w-4 text-[var(--teal)]" />
							{hora} hrs
						</span>
						<span className="flex items-center gap-1.5">
							<MapPin className="h-4 w-4 text-[var(--teal)]" />
							{evento.venue}
						</span>
					</div>

					<Separator />

					<div className="flex items-center justify-between">
						<span className="text-sm text-muted-foreground">Precio desde</span>
						<span className="text-2xl font-bold text-primary">
							S/ {precioDesde.toFixed(2)}
						</span>
					</div>
				</div>
				<DialogFooter>
					<DialogClose render={<Button variant="outline">Cerrar</Button>} />
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}
