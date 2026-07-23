import { ArrowLeft, Check } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import type { AsistenteInput } from "@/lib/validations";
import type { CompradorData } from "./usePurchaseForm";

interface PurchaseStepConfirmarProps {
	comprador: CompradorData;
	asistentes: AsistenteInput[];
	precioUnitario: number;
	onConfirm: () => void;
	onBack: () => void;
}

export function PurchaseStepConfirmar({
	comprador,
	asistentes,
	precioUnitario,
	onConfirm,
	onBack,
}: PurchaseStepConfirmarProps) {
	const precioTotal = asistentes.length * precioUnitario;

	return (
		<Card>
			<CardHeader>
				<CardTitle>Confirmar compra</CardTitle>
			</CardHeader>
			<CardContent className="space-y-4">
				<div className="rounded-lg bg-muted p-4">
					<h4 className="mb-2 text-sm font-semibold text-card-foreground">
						Comprador
					</h4>
					<div className="grid grid-cols-3 gap-2 text-sm">
						<div>
							<span className="text-muted-foreground">Nombre:</span>
							<p className="font-medium">{comprador.nombre}</p>
						</div>
						<div>
							<span className="text-muted-foreground">Email:</span>
							<p className="font-medium">{comprador.email}</p>
						</div>
						<div>
							<span className="text-muted-foreground">DNI:</span>
							<p className="font-medium">{comprador.dni}</p>
						</div>
					</div>
				</div>

				<Separator />

				<h4 className="text-sm font-semibold text-card-foreground">
					Asistentes
				</h4>
				<div className="space-y-2">
					{asistentes.map((a, i) => (
						<div
							key={i}
							className="flex items-center justify-between rounded-lg border border-border p-3"
						>
							<div>
								<p className="font-medium text-card-foreground">{a.nombre}</p>
								<p className="text-xs text-muted-foreground">
									DNI: {a.documento}
								</p>
							</div>
							<span className="text-sm font-medium text-[var(--teal)]">
								S/ {precioUnitario.toFixed(2)}
							</span>
						</div>
					))}
				</div>

				<Separator />

				<div className="flex items-center justify-between">
					<div>
						<span className="text-sm text-muted-foreground">Total a pagar</span>
						<p className="text-2xl font-bold text-primary">
							S/ {precioTotal.toFixed(2)}
						</p>
					</div>
					<div className="flex gap-3">
						<Button variant="outline" onClick={onBack}>
							<ArrowLeft className="h-4 w-4" />
							Editar
						</Button>
						<Button
							className="bg-[var(--teal)] text-[var(--deep-purple)] hover:bg-[var(--teal)]/90"
							onClick={onConfirm}
						>
							<Check className="h-4 w-4" />
							Confirmar Compra
						</Button>
					</div>
				</div>
			</CardContent>
		</Card>
	);
}
