import { Minus, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";

interface QuantitySelectorProps {
	value: number;
	onChange: (value: number) => void;
	min?: number;
	max?: number;
	precio?: number;
}

export function QuantitySelector({
	value,
	onChange,
	min = 1,
	max = 5,
	precio,
}: QuantitySelectorProps) {
	const handleDecrease = () => {
		if (value > min) onChange(value - 1);
	};

	const handleIncrease = () => {
		if (value < max) onChange(value + 1);
	};

	return (
		<div className="space-y-3">
			<h3 className="text-lg font-heading font-semibold text-card-foreground">
				Cantidad de entradas
			</h3>

			<div className="flex items-center gap-4">
				<div className="flex items-center rounded-lg border border-border">
					<Button
						variant="ghost"
						size="icon"
						onClick={handleDecrease}
						disabled={value <= min}
						className="h-12 w-12 rounded-r-none"
					>
						<Minus className="h-4 w-4" />
					</Button>

					<span className="flex h-12 w-16 items-center justify-center border-x border-border text-lg font-bold text-foreground">
						{value}
					</span>

					<Button
						variant="ghost"
						size="icon"
						onClick={handleIncrease}
						disabled={value >= max}
						className="h-12 w-12 rounded-l-none"
					>
						<Plus className="h-4 w-4" />
					</Button>
				</div>

				{precio && (
					<div className="flex-1 rounded-lg bg-muted p-4">
						<span className="text-sm text-muted-foreground">Total</span>
						<p className="text-2xl font-bold text-primary">
							S/ {(value * precio).toFixed(2)}
						</p>
					</div>
				)}
			</div>

			<p className="text-xs text-muted-foreground">
				Máximo {max} entradas por compra
			</p>
		</div>
	);
}
