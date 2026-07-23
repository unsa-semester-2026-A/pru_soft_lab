import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Link } from "@/components/ui/link";
import { Separator } from "@/components/ui/separator";
import { Ticket } from "lucide-react";

interface EventSuccessProps {
	eventoNombre: string;
	zonaNombre: string;
	cantidad: number;
	precioUnitario: number;
}

export function EventSuccess({
	eventoNombre,
	zonaNombre,
	cantidad,
	precioUnitario,
}: EventSuccessProps) {
	const total = cantidad * precioUnitario;

	return (
		<div className="mx-auto max-w-md text-center">
			{/* Check icon */}
			<div className="mb-6 flex h-20 w-20 items-center justify-center rounded-full bg-[var(--teal)] mx-auto">
				<svg
					className="h-10 w-10 text-[var(--deep-purple)]"
					fill="none"
					viewBox="0 0 24 24"
					stroke="currentColor"
					strokeWidth={3}
					aria-hidden="true"
				>
					<path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
				</svg>
			</div>

			<h1 className="font-heading text-3xl font-bold text-foreground">
				¡Compra exitosa!
			</h1>
			<p className="mt-4 text-muted-foreground">
				Tus entradas han sido generadas correctamente.
			</p>

			{/* Boleta / Ticket */}
			<Card className="mt-8 border-2 border-[var(--teal)]/30 bg-card">
				<CardContent className="p-6">
					<div className="flex items-center gap-3 mb-4">
						<Ticket className="h-6 w-6 text-[var(--teal)]" />
						<h2 className="font-heading text-lg font-semibold text-card-foreground">
							Resumen de Compra
						</h2>
					</div>

					<Separator className="mb-4" />

					<div className="space-y-3 text-sm">
						<div className="flex justify-between">
							<span className="text-muted-foreground">Evento</span>
							<span className="font-medium text-card-foreground text-right max-w-[200px]">
								{eventoNombre}
							</span>
						</div>
						<div className="flex justify-between">
							<span className="text-muted-foreground">Zona</span>
							<span className="font-medium text-card-foreground">{zonaNombre}</span>
						</div>
						<div className="flex justify-between">
							<span className="text-muted-foreground">Cantidad</span>
							<span className="font-medium text-card-foreground">{cantidad} entrada(s)</span>
						</div>
						<div className="flex justify-between">
							<span className="text-muted-foreground">Precio unitario</span>
							<span className="font-medium text-card-foreground">S/ {precioUnitario.toFixed(2)}</span>
						</div>

						<Separator className="my-3" />

						<div className="flex justify-between items-center">
							<span className="font-semibold text-foreground">Total pagado</span>
							<span className="text-xl font-bold text-[var(--teal)]">S/ {total.toFixed(2)}</span>
						</div>
					</div>

					<div className="mt-4 rounded-lg bg-muted p-3 text-xs text-muted-foreground text-center">
						Recibirás un correo con el código de tus entradas
					</div>
				</CardContent>
			</Card>

			<div className="mt-8 flex gap-4">
				<Button size="lg" variant="outline" className="flex-1" asChild>
					<Link href="/">Volver al inicio</Link>
				</Button>
			</div>
		</div>
	);
}
