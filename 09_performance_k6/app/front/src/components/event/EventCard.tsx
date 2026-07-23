import { Calendar, MapPin, Ticket } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/components/ui/link";
import type { Evento } from "@/lib/api";

interface EventCardProps {
	evento: Evento;
}

export function EventCard({ evento }: EventCardProps) {
	const fechaObj = new Date(evento.fecha);
	const dia = fechaObj.getDate();
	const mes = fechaObj
		.toLocaleDateString("es-PE", { month: "short" })
		.toUpperCase();
	const hora = fechaObj.toLocaleTimeString("es-PE", {
		hour: "2-digit",
		minute: "2-digit",
	});
	const precioDesde = Math.min(...(evento.zonas?.map((z) => z.precio) ?? [0]));

	return (
		<Link href={`/evento?id=${evento.id}`} className="group block">
			<Card className="h-full transition-all hover:shadow-md hover:border-primary/50 py-0 pb-4">
				<div className="relative aspect-[16/10] overflow-hidden">
					<img
						src={evento.imagen_url}
						alt={evento.nombre}
						className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
						loading="lazy"
					/>
					<div className="absolute inset-0 bg-linear-to-t from-black/60 via-transparent to-transparent" />

					<div className="absolute top-3 left-3 flex flex-col items-center rounded-md bg-primary px-3 py-1.5 text-primary-foreground shadow-lg">
						<span className="text-xs font-bold leading-none">{mes}</span>
						<span className="text-xl font-bold leading-none">{dia}</span>
					</div>

					<div className="absolute top-3 right-3">
						<Badge
							variant="secondary"
							className="bg-secondary/90 backdrop-blur-sm gap-1"
						>
							<Ticket className="h-3 w-3" />
							{evento.categoria ?? "Música"}
						</Badge>
					</div>
				</div>

				<CardContent className="flex flex-col gap-2">
					<h3 className="font-heading text-lg font-semibold leading-tight text-card-foreground line-clamp-2 group-hover:text-primary transition-colors">
						{evento.nombre}
					</h3>

					<p className="text-sm font-medium text-primary">{evento.artista}</p>

					<div className="mt-auto flex flex-col gap-1.5 text-sm text-muted-foreground">
						<div className="flex items-center gap-1.5">
							<Calendar className="h-3.5 w-3.5 shrink-0" />
							<span>{hora} hrs</span>
						</div>
						<div className="flex items-center gap-1.5">
							<MapPin className="h-3.5 w-3.5 shrink-0" />
							<span className="line-clamp-1">{evento.venue}</span>
						</div>
					</div>

					<div className="mt-3 flex items-center justify-between border-t border-border pt-3">
						<div>
							<span className="text-xs text-muted-foreground">Desde</span>
							<p className="text-lg font-bold text-primary">
								S/ {precioDesde.toFixed(2)}
							</p>
						</div>
						<span className="inline-flex items-center gap-1 rounded-md bg-primary/10 px-3 py-1.5 text-xs font-semibold text-primary transition-colors group-hover:bg-primary group-hover:text-primary-foreground">
							<Ticket className="h-3.5 w-3.5" />
							Comprar
						</span>
					</div>
				</CardContent>
			</Card>
		</Link>
	);
}
