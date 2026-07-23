import { Button } from "@/components/ui/button";

interface EventSuccessProps {
	isEdit: boolean;
	onBack: () => void;
}

export function EventSuccess({ isEdit, onBack }: EventSuccessProps) {
	return (
		<div className="mx-auto max-w-md py-12 text-center">
			<div className="mb-6 flex h-20 w-20 items-center justify-center rounded-full bg-[var(--teal)] mx-auto">
				<svg
					className="h-10 w-10 text-[var(--deep-purple)]"
					fill="none"
					viewBox="0 0 24 24"
					stroke="currentColor"
					strokeWidth={3}
				>
					<path
						strokeLinecap="round"
						strokeLinejoin="round"
						d="M5 13l4 4L19 7"
					/>
				</svg>
			</div>
			<h2 className="font-heading text-2xl font-bold text-foreground">
				{isEdit ? "¡Evento actualizado!" : "¡Evento creado!"}
			</h2>
			<p className="mt-2 text-muted-foreground">
				{isEdit
					? "Los cambios se han guardado exitosamente."
					: "El evento ha sido creado exitosamente."}
			</p>
			<div className="mt-6">
				<Button onClick={onBack}>Volver a eventos</Button>
			</div>
		</div>
	);
}
