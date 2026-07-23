import {
	Field,
	FieldDescription,
	FieldError,
	FieldLabel,
} from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";

interface EventMediaProps {
	categoria: string;
	imagen_url: string;
	descripcion: string;
	errors: Record<string, string>;
	onChange: (field: string, value: string) => void;
}

export function EventMedia({
	imagen_url,
	descripcion,
	errors,
	onChange,
}: EventMediaProps) {
	return (
		<div className="space-y-4">
			<div className="grid gap-4">
				<Field>
					<FieldLabel>URL de imagen</FieldLabel>
					<Input
						value={imagen_url}
						onChange={(e) => onChange("imagen_url", e.target.value)}
						placeholder="https://..."
						aria-invalid={!!errors.imagen_url}
					/>
					{errors.imagen_url && <FieldError>{errors.imagen_url}</FieldError>}
				</Field>
				<Field>
					<FieldLabel>Descripción</FieldLabel>
					<Textarea
						value={descripcion}
						onChange={(e) => onChange("descripcion", e.target.value)}
						placeholder="Descripción del evento..."
						className="w-full rounded-lg border border-input px-3 py-2 text-sm placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-ring"
					/>
					<FieldDescription className="ml-2 text-xs">
						Opcional. Máximo 1000 caracteres.
					</FieldDescription>
				</Field>
			</div>
		</div>
	);
}
