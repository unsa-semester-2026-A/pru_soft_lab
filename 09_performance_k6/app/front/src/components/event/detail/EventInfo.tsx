import { Calendar, Clock, MapPin, Ticket } from "lucide-react";
import { Badge } from "@/components/ui/badge";

interface EventInfoProps {
	nombre: string;
	artista: string;
	venue: string;
	fecha: string;
	imagen_url: string;
	descripcion: string;
}

export function EventInfo({
	nombre,
	artista,
	venue,
	fecha,
	imagen_url,
	descripcion,
}: EventInfoProps) {
	const fechaObj = new Date(fecha);
	const fechaFormateada = fechaObj.toLocaleDateString("es-PE", {
		weekday: "long",
		year: "numeric",
		month: "long",
		day: "numeric",
	});
	const horaFormateada = fechaObj.toLocaleTimeString("es-PE", {
		hour: "2-digit",
		minute: "2-digit",
	});

	return (
		<div>
			<div className="relative aspect-video overflow-hidden rounded-xl">
				<img
					src={imagen_url}
					alt={nombre}
					className="h-full w-full object-cover"
				/>
				<div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />
				<div className="absolute bottom-4 left-4 right-4">
					<Badge className="bg-[var(--teal)] text-[var(--deep-purple)]">
						<Ticket className="h-3 w-3" />
						Música / Presencial
					</Badge>
				</div>
			</div>

			<div className="mt-6">
				<h1 className="font-heading text-3xl font-bold text-foreground md:text-4xl">
					{nombre}
				</h1>
				<p className="mt-2 text-xl font-semibold text-primary">{artista}</p>
			</div>

			<div className="mt-6 flex flex-wrap gap-6 text-sm text-muted-foreground">
				<div className="flex items-center gap-2">
					<Calendar className="h-5 w-5 text-[var(--teal)]" />
					<span>{fechaFormateada}</span>
				</div>
				<div className="flex items-center gap-2">
					<Clock className="h-5 w-5 text-[var(--teal)]" />
					<span>{horaFormateada} hrs</span>
				</div>
				<div className="flex items-center gap-2">
					<MapPin className="h-5 w-5 text-[var(--teal)]" />
					<span>{venue}</span>
				</div>
			</div>

			{descripcion && (
				<div className="mt-6 rounded-lg border border-border bg-card p-6">
					<h2 className="mb-4 text-lg font-heading font-semibold text-card-foreground">
						Acerca del evento
					</h2>
					<p className="text-muted-foreground">{descripcion}</p>
				</div>
			)}
		</div>
	);
}
