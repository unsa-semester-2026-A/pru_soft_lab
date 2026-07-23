import { Check, Star, Ticket, Users } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";

interface Zona {
	id: string;
	nombre: string;
	precio: number;
	stock_disponible: number;
}

interface SeatSelectorProps {
	zonas: Zona[];
	selectedZona: string | null;
	onSelectZona: (zonaId: string) => void;
}

const zonaIcons: Record<string, typeof Ticket> = {
	vip: Star,
	pref: Users,
	gen: Ticket,
};

export function SeatSelector({
	zonas,
	selectedZona,
	onSelectZona,
}: SeatSelectorProps) {
	return (
		<div className="space-y-4">
			<h3 className="text-lg font-heading font-semibold text-card-foreground">
				Selecciona tu zona
			</h3>

			<div className="grid gap-3">
				{zonas.map((zona) => {
					const Icon = zonaIcons[zona.id] || Ticket;
					const isSelected = selectedZona === zona.id;
					const isAvailable = zona.stock_disponible > 0;

					return (
						<button
							key={zona.id}
							onClick={() => isAvailable && onSelectZona(zona.id)}
							disabled={!isAvailable}
							className={`relative text-left rounded-lg ${
								isSelected
									? "ring-3 ring-primary"
									: isAvailable
										? "hover:ring-2 hover:ring-primary/50"
										: "opacity-50 cursor-not-allowed"
							}`}
						>
							<Card className={isSelected ? "border-primary" : ""}>
								<CardContent className="flex items-center gap-4">
									{/* Icon */}
									<div
										className={`flex h-12 w-12 items-center justify-center rounded-lg bg-primary text-primary-foreground`}
									>
										<Icon className="h-6 w-6" />
									</div>

									{/* Info */}
									<div className="flex-1">
										<div className="flex items-center gap-2">
											<span className="font-semibold text-card-foreground">
												{zona.nombre}
											</span>
											{zona.id === "vip" && (
												<Badge variant="secondary" className="text-[0.6rem]">
													Premium
												</Badge>
											)}
										</div>
										<p className="text-sm text-muted-foreground">
											{isAvailable
												? `${zona.stock_disponible} entradas disponibles`
												: "Agotado"}
										</p>
									</div>

									{/* Price */}
									<div className="text-right">
										<span className="text-xs text-muted-foreground">Desde</span>
										<p className="text-xl font-bold text-primary">
											S/ {zona.precio.toFixed(2)}
										</p>
									</div>

									{/* Selected Indicator */}
									{isSelected && (
										<div className="absolute top-2 right-2">
											<div className="flex h-6 w-6 items-center justify-center rounded-full bg-primary text-primary-foreground">
												<Check className="h-4 w-4" />
											</div>
										</div>
									)}
								</CardContent>
							</Card>
						</button>
					);
				})}
			</div>
		</div>
	);
}
