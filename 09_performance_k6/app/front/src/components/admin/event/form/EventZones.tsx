import { Plus, Trash2 } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";

interface Zona {
	id: string;
	nombre: string;
	precio: number;
	stock_total: number;
}

interface EventZonesProps {
	zonas: Zona[];
	error?: string;
	onUpdate: (index: number, field: string, value: string | number) => void;
	onAdd: () => void;
	onRemove: (index: number) => void;
}

export function EventZones({
	zonas,
	error,
	onUpdate,
	onAdd,
	onRemove,
}: EventZonesProps) {
	return (
		<div className="space-y-4">
			<div className="flex items-center justify-between">
				<h3 className="text-sm font-semibold text-card-foreground">
					Zonas y precios
				</h3>
				<Button variant="outline" size="sm" onClick={onAdd}>
					<Plus className="h-4 w-4" />
					Agregar zona
				</Button>
			</div>

			{error && <FieldError>{error}</FieldError>}

			{zonas.map((zona, index) => (
				<div key={index} className="rounded-lg border border-border p-4">
					<div className="mb-3 flex items-center justify-between">
						<Badge variant="secondary">Zona {index + 1}</Badge>
						{zonas.length > 1 && (
							<Button
								variant="ghost"
								size="icon-sm"
								onClick={() => onRemove(index)}
								className="text-destructive"
							>
								<Trash2 className="h-4 w-4" />
							</Button>
						)}
					</div>
					<div className="grid gap-3 sm:grid-cols-4">
						<Field>
							<FieldLabel className="text-xs">ID</FieldLabel>
							<Input
								value={zona.id}
								onChange={(e) => onUpdate(index, "id", e.target.value)}
								placeholder="vip"
								className="text-sm"
							/>
						</Field>
						<Field>
							<FieldLabel className="text-xs">Nombre</FieldLabel>
							<Input
								value={zona.nombre}
								onChange={(e) => onUpdate(index, "nombre", e.target.value)}
								placeholder="VIP"
								className="text-sm"
							/>
						</Field>
						<Field>
							<FieldLabel className="text-xs">Precio (S/)</FieldLabel>
							<Input
								type="number"
								value={zona.precio || ""}
								onChange={(e) =>
									onUpdate(index, "precio", Number(e.target.value))
								}
								placeholder="100"
								min={0}
								className="text-sm"
							/>
						</Field>
						<Field>
							<FieldLabel className="text-xs">Stock</FieldLabel>
							<Input
								type="number"
								value={zona.stock_total || ""}
								onChange={(e) =>
									onUpdate(index, "stock_total", Number(e.target.value))
								}
								placeholder="100"
								min={0}
								className="text-sm"
							/>
						</Field>
					</div>
				</div>
			))}
		</div>
	);
}
