import { Calendar, MapPin, Ticket } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/components/ui/link";
import type { Evento } from "@/lib/api";

interface EventListItemProps {
	evento: Evento;
}

export function EventListItem({ evento }: EventListItemProps) {
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
			<Card className="transition-all hover:shadow-md hover:border-primary/50">
				<CardContent className="flex gap-4 p-4">
					{/* Date Badge */}
					<div className="flex h-16 w-16 flex-shrink-0 flex-col items-center justify-center rounded-lg bg-primary text-primary-foreground">
						<span className="text-xs font-bold leading-none">{mes}</span>
						<span className="text-xl font-bold leading-none">{dia}</span>
					</div>

					{/* Image */}
					<div className="h-16 w-24 flex-shrink-0 overflow-hidden rounded-lg">
						<img
							src={evento.imagen_url}
							alt={evento.nombre}
							className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
							loading="lazy"
						/>
					</div>

					{/* Info */}
					<div className="flex flex-1 flex-col justify-center min-w-0">
						<div className="flex items-center gap-2">
							<h3 className="font-heading text-sm font-semibold text-card-foreground truncate group-hover:text-primary transition-colors">
								{evento.nombre}
							</h3>
							<Badge
								variant="secondary"
								className="flex-shrink-0 text-[0.6rem]"
							>
								{evento.categoria ?? "Música"}
							</Badge>
						</div>
						<p className="text-xs font-medium text-primary">{evento.artista}</p>
						<div className="mt-1 flex items-center gap-3 text-xs text-muted-foreground">
							<span className="flex items-center gap-1">
								<Calendar className="h-3 w-3" />
								{hora} hrs
							</span>
							<span className="flex items-center gap-1">
								<MapPin className="h-3 w-3" />
								{evento.venue}
							</span>
						</div>
					</div>

					{/* Price & CTA */}
					<div className="flex flex-shrink-0 flex-col items-end justify-center gap-2">
						<span className="text-lg font-bold text-primary">
							S/ {precioDesde.toFixed(2)}
						</span>
						<Button size="sm" className="text-[0.65rem]">
							<Ticket className="h-3 w-3" />
							Comprar
						</Button>
					</div>
				</CardContent>
			</Card>
		</Link>
	);
}
