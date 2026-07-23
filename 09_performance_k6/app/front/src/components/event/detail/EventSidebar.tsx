import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { QuantitySelector } from "../../purchase/QuantitySelector";
import { SeatSelector } from "../../purchase/SeatSelector";

interface Zona {
	id: string;
	nombre: string;
	precio: number;
	stock_disponible: number;
}

interface EventSidebarProps {
	zonas: Zona[];
	selectedZona: string | null;
	cantidad: number;
	onSelectZona: (id: string) => void;
	onCantidadChange: (value: number) => void;
	onReservar: () => void;
}

export function EventSidebar({
	zonas,
	selectedZona,
	cantidad,
	onSelectZona,
	onCantidadChange,
	onReservar,
}: EventSidebarProps) {
	const zonaSeleccionada = zonas.find((z) => z.id === selectedZona);

	return (
		<div className="space-y-6">
			<Card className="sticky top-24">
				<CardContent className="space-y-6">
					<SeatSelector
						zonas={zonas}
						selectedZona={selectedZona}
						onSelectZona={onSelectZona}
					/>
					{selectedZona && (
						<>
							<Separator />
							<QuantitySelector
								value={cantidad}
								onChange={onCantidadChange}
								max={5}
								precio={zonaSeleccionada?.precio}
							/>
						</>
					)}
					{selectedZona && (
						<Button className="w-full py-5" size="lg" onClick={onReservar}>
							Reservar {cantidad} entrada(s)
						</Button>
					)}
				</CardContent>
			</Card>
		</div>
	);
}
