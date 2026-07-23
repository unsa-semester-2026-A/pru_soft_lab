import { ArrowLeft, ArrowRight, Check, CreditCard, User } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import type { AsistenteInput } from "@/lib/validations";

interface PurchaseStepAsistentesProps {
	asistentes: AsistenteInput[];
	errors: Record<string, string>;
	current: number;
	total: number;
	onChange: (field: keyof AsistenteInput, value: string) => void;
	onSetCurrent: (index: number) => void;
	onNext: () => void;
	onBack: () => void;
}

export function PurchaseStepAsistentes({
	asistentes,
	errors,
	current,
	total,
	onChange,
	onSetCurrent,
	onNext,
	onBack,
}: PurchaseStepAsistentesProps) {
	return (
		<Card>
			<CardHeader>
				<CardTitle>
					Asistente {current + 1} de {total}
				</CardTitle>
			</CardHeader>
			<CardContent className="space-y-5">
				<Field>
					<FieldLabel htmlFor={`asis-nombre-${current}`}>
						Nombre completo
					</FieldLabel>
					<div className="relative">
						<User className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
						<Input
							id={`asis-nombre-${current}`}
							value={asistentes[current].nombre}
							onChange={(e) => onChange("nombre", e.target.value)}
							placeholder="Juan Pérez"
							className="pl-10"
							aria-invalid={!!errors.nombre}
						/>
					</div>
					{errors.nombre && <FieldError>{errors.nombre}</FieldError>}
				</Field>

				<Field>
					<FieldLabel htmlFor={`asis-doc-${current}`}>DNI</FieldLabel>
					<div className="relative">
						<CreditCard className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
						<Input
							id={`asis-doc-${current}`}
							value={asistentes[current].documento}
							onChange={(e) => onChange("documento", e.target.value)}
							placeholder="12345678"
							maxLength={15}
							className="pl-10"
							aria-invalid={!!errors.documento}
						/>
					</div>
					{errors.documento && <FieldError>{errors.documento}</FieldError>}
				</Field>

				{total > 1 && (
					<div className="flex items-center justify-center gap-2 pt-2">
						{Array.from({ length: total }, (_, i) => (
							<button
								key={i}
								onClick={() => {
									if (i <= current) onSetCurrent(i);
								}}
								className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-bold transition-colors ${
									i === current
										? "bg-primary text-primary-foreground"
										: i < current
											? "bg-[var(--teal)] text-[var(--deep-purple)]"
											: "bg-muted text-muted-foreground"
								}`}
							>
								{i < current ? <Check className="h-3 w-3" /> : i + 1}
							</button>
						))}
					</div>
				)}

				<div className="flex items-center justify-between pt-2">
					<Button variant="outline" onClick={onBack}>
						<ArrowLeft className="h-4 w-4" />
						Anterior
					</Button>
					<Button onClick={onNext}>
						{current === total - 1 ? "Revisar" : "Siguiente"}
						<ArrowRight className="h-4 w-4" />
					</Button>
				</div>
			</CardContent>
		</Card>
	);
}
