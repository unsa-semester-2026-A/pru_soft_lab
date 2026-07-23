import { ChevronLeft, ChevronRight, Ticket } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Link } from "@/components/ui/link";
import type { Evento } from "@/lib/api";

interface EventCarouselProps {
	eventos: Evento[];
}

export function EventCarousel({ eventos }: EventCarouselProps) {
	const [current, setCurrent] = useState(0);
	const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

	const next = () => setCurrent((prev) => (prev + 1) % eventos.length);
	const prev = () =>
		setCurrent((prev) => (prev - 1 + eventos.length) % eventos.length);

	useEffect(() => {
		timerRef.current = setInterval(next, 5000);
		return () => {
			if (timerRef.current) clearInterval(timerRef.current);
		};
	}, []);

	const resetTimer = () => {
		if (timerRef.current) clearInterval(timerRef.current);
		timerRef.current = setInterval(next, 5000);
	};

	const handleNext = () => {
		next();
		resetTimer();
	};
	const handlePrev = () => {
		prev();
		resetTimer();
	};

	const evento = eventos[current];
	const fechaObj = new Date(evento.fecha);
	const fechaFormateada = fechaObj.toLocaleDateString("es-PE", {
		weekday: "long",
		year: "numeric",
		month: "long",
		day: "numeric",
	});
	const precioDesde = Math.min(...(evento.zonas?.map((z) => z.precio) ?? [0]));
	const categoria = evento.categoria ?? "conciertos";

	return (
		<section className="relative h-[500px] w-full overflow-hidden md:h-[600px]">
			<div className="absolute inset-0">
				<img
					src={evento.imagen_url}
					alt={evento.nombre}
					className="h-full w-full object-cover transition-opacity duration-700"
				/>
				<div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/40 to-black/20" />
			</div>

			<div className="absolute inset-0 flex items-end">
				<div className="container mx-auto px-4 pb-16 md:px-6 md:pb-24">
					<div className="max-w-2xl">
						<Badge className="mb-4 bg-[var(--teal)] text-[var(--deep-purple)]">
							<Ticket className="h-3 w-3" />
							{categoria}
						</Badge>
						<h2 className="font-heading text-3xl font-bold text-white md:text-5xl lg:text-6xl">
							{evento.nombre}
						</h2>
						<p className="mt-2 text-xl font-semibold text-[var(--teal)] md:text-2xl">
							{evento.artista}
						</p>
						<p className="mt-2 text-sm text-white/70 md:text-base">
							{fechaFormateada} • {evento.venue}
						</p>
						<div className="mt-6 flex items-center gap-4">
							<Button
								asChild
								size="lg"
								className="bg-[var(--violet)] hover:bg-[var(--violet)]/90"
							>
								<Link href={`/evento?id=${evento.id}`}>Ver Evento</Link>
							</Button>
							<span className="text-lg font-bold text-white">
								Desde S/ {precioDesde.toFixed(2)}
							</span>
						</div>
					</div>
				</div>
			</div>

			<Button
				variant="ghost"
				size="icon"
				onClick={handlePrev}
				className="absolute left-4 top-1/2 -translate-y-1/2 h-12 w-12 rounded-full bg-black/30 text-white hover:bg-black/50 backdrop-blur-sm"
			>
				<ChevronLeft className="h-6 w-6" />
			</Button>
			<Button
				variant="ghost"
				size="icon"
				onClick={handleNext}
				className="absolute right-4 top-1/2 -translate-y-1/2 h-12 w-12 rounded-full bg-black/30 text-white hover:bg-black/50 backdrop-blur-sm"
			>
				<ChevronRight className="h-6 w-6" />
			</Button>

			<div className="absolute bottom-6 left-1/2 flex -translate-x-1/2 gap-2">
				{eventos.map((_, i) => (
					<button
						key={i}
						onClick={() => {
							setCurrent(i);
							resetTimer();
						}}
						className={`h-2 w-2 rounded-full transition-all ${
							i === current
								? "w-8 bg-[var(--teal)]"
								: "bg-white/50 hover:bg-white/80"
						}`}
					/>
				))}
			</div>
		</section>
	);
}
