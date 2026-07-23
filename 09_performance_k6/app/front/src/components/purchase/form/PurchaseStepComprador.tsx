import { ArrowLeft, ArrowRight, CreditCard, Mail, User } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
	Field,
	FieldDescription,
	FieldError,
	FieldLabel,
} from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import type { CompradorData } from "./usePurchaseForm";

interface PurchaseStepCompradorProps {
	comprador: CompradorData;
	errors: Record<string, string>;
	onChange: (field: keyof CompradorData, value: string) => void;
	onNext: () => void;
	onCancel: () => void;
}

export function PurchaseStepComprador({
	comprador,
	errors,
	onChange,
	onNext,
	onCancel,
}: PurchaseStepCompradorProps) {
	return (
		<Card>
			<CardHeader>
				<CardTitle>Datos del comprador</CardTitle>
			</CardHeader>
			<CardContent className="space-y-5">
				<Field>
					<FieldLabel htmlFor="comprador-nombre">Nombre completo</FieldLabel>
					<div className="relative">
						<User className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
						<Input
							id="comprador-nombre"
							value={comprador.nombre}
							onChange={(e) => onChange("nombre", e.target.value)}
							placeholder="Juan Pérez"
							className="pl-10"
							aria-invalid={!!errors.nombre}
						/>
					</div>
					{errors.nombre && <FieldError>{errors.nombre}</FieldError>}
				</Field>

				<Field>
					<FieldLabel htmlFor="comprador-email">Correo electrónico</FieldLabel>
					<div className="relative">
						<Mail className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
						<Input
							id="comprador-email"
							type="email"
							value={comprador.email}
							onChange={(e) => onChange("email", e.target.value)}
							placeholder="juan@correo.com"
							className="pl-10"
							aria-invalid={!!errors.email}
						/>
					</div>
					{errors.email && <FieldError>{errors.email}</FieldError>}
					<FieldDescription>
						Recibirás los tickets en este correo
					</FieldDescription>
				</Field>

				<Field>
					<FieldLabel htmlFor="comprador-dni">DNI</FieldLabel>
					<div className="relative">
						<CreditCard className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
						<Input
							id="comprador-dni"
							value={comprador.dni}
							onChange={(e) => onChange("dni", e.target.value)}
							placeholder="12345678"
							maxLength={15}
							className="pl-10"
							aria-invalid={!!errors.dni}
						/>
					</div>
					{errors.dni && <FieldError>{errors.dni}</FieldError>}
				</Field>

				<div className="flex items-center justify-between pt-2">
					<Button variant="outline" onClick={onCancel}>
						<ArrowLeft className="h-4 w-4" />
						Cancelar
					</Button>
					<Button onClick={onNext}>
						Siguiente
						<ArrowRight className="h-4 w-4" />
					</Button>
				</div>
			</CardContent>
		</Card>
	);
}
