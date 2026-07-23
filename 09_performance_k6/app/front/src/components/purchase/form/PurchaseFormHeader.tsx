import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

interface PurchaseFormHeaderProps {
	eventoNombre: string;
	zonaNombre: string;
	cantidad: number;
	precioUnitario: number;
}

export function PurchaseFormHeader({
	eventoNombre,
	zonaNombre,
	cantidad,
	precioUnitario,
}: PurchaseFormHeaderProps) {
	const precioTotal = cantidad * precioUnitario;

	return (
		<Card className="bg-[var(--deep-purple)] text-[var(--light-gray)] border-0">
			<CardHeader>
				<CardTitle className="flex items-center gap-3 text-[var(--light-gray)]">
					<svg
						className="h-6 w-6 text-[var(--teal)]"
						fill="none"
						viewBox="0 0 24 24"
						stroke="currentColor"
						strokeWidth={2}
					>
						<path
							strokeLinecap="round"
							strokeLinejoin="round"
							d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"
						/>
					</svg>
					Completar Compra
				</CardTitle>
			</CardHeader>
			<CardContent>
				<div className="grid grid-cols-2 gap-4 text-sm">
					<div>
						<span className="text-[var(--light-gray)]/60">Evento</span>
						<p className="font-medium">{eventoNombre}</p>
					</div>
					<div>
						<span className="text-[var(--light-gray)]/60">Zona</span>
						<p className="font-medium">{zonaNombre}</p>
					</div>
					<div>
						<span className="text-[var(--light-gray)]/60">Cantidad</span>
						<p className="font-medium">{cantidad} entrada(s)</p>
					</div>
					<div>
						<span className="text-[var(--light-gray)]/60">Total</span>
						<p className="text-xl font-bold text-[var(--teal)]">
							S/ {precioTotal.toFixed(2)}
						</p>
					</div>
				</div>
			</CardContent>
		</Card>
	);
}
