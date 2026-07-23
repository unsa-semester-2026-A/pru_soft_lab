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

interface Zona {
	id: string;
	nombre: string;
	precio: number;
	stock_total: number;
}

interface EventFormPreviewDialogProps {
	form: {
		nombre: string;
		artista: string;
		venue: string;
		fecha: string;
		categoria: string;
		imagen_url: string;
		descripcion: string;
	};
	zonas: Zona[];
}

export function EventFormPreviewDialog({
	form,
	zonas,
}: EventFormPreviewDialogProps) {
	const fecha = form.fecha ? new Date(form.fecha) : null;
	const fechaCompleta = fecha
		? fecha.toLocaleDateString("es-PE", {
				weekday: "long",
				year: "numeric",
				month: "long",
				day: "numeric",
			})
		: "Fecha";
	const hora = fecha
		? fecha.toLocaleTimeString("es-PE", { hour: "2-digit", minute: "2-digit" })
		: "Hora";

	return (
		<Dialog>
			<DialogTrigger render={<Button variant="outline" />}>
				<Eye className="h-4 w-4" />
				Vista previa
			</DialogTrigger>
			<DialogContent className="sm:max-w-lg">
				<DialogHeader>
					<DialogTitle>Vista Previa del Evento</DialogTitle>
				</DialogHeader>
				<div className="space-y-4">
					{/* Imagen */}
					<div className="relative aspect-video overflow-hidden rounded-lg">
						<img
							src={
								form.imagen_url ||
								"https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800"
							}
							alt={form.nombre || "Evento"}
							className="h-full w-full object-cover"
						/>
						<Badge className="absolute top-2 right-2 bg-[var(--teal)] text-[var(--deep-purple)]">
							{form.categoria}
						</Badge>
						<div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />
						<div className="absolute bottom-4 left-4">
							<span className="text-xs font-bold text-white/80 uppercase tracking-wider">
								{form.categoria}
							</span>
						</div>
					</div>

					{/* Info */}
					<div>
						<h3 className="font-heading text-xl font-bold text-card-foreground">
							{form.nombre || "Nombre del evento"}
						</h3>
						<p className="text-base font-semibold text-primary">
							{form.artista || "Artista"}
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
							{form.venue || "Venue"}
						</span>
					</div>

					{form.descripcion && (
						<p className="text-sm text-muted-foreground">{form.descripcion}</p>
					)}

					<Separator />

					{/* Zonas */}
					<div>
						<h4 className="mb-2 text-sm font-semibold text-card-foreground">
							Zonas disponibles
						</h4>
						<div className="space-y-2">
							{zonas
								.filter((z) => z.nombre)
								.map((zona, i) => (
									<div
										key={i}
										className="flex items-center justify-between rounded-lg border border-border p-2.5"
									>
										<div>
											<span className="text-sm font-medium text-card-foreground">
												{zona.nombre}
											</span>
											<span className="ml-2 text-xs text-muted-foreground">
												{zona.stock_total > 0
													? `${zona.stock_total} disponibles`
													: "Agotado"}
											</span>
										</div>
										<span className="text-sm font-bold text-primary">
											S/ {zona.precio.toFixed(2)}
										</span>
									</div>
								))}
						</div>
					</div>

					<Button className="w-full" size="lg">
						Comprar Entradas
					</Button>
				</div>
				<DialogFooter>
					<DialogClose render={<Button variant="outline">Cerrar</Button>} />
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}
