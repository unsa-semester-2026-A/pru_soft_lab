import { format } from "date-fns";
import { es } from "date-fns/locale";
import { CalendarIcon } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Calendar } from "@/components/ui/calendar";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import {
	Popover,
	PopoverContent,
	PopoverTrigger,
} from "@/components/ui/popover";
import {
	Select,
	SelectContent,
	SelectItem,
	SelectTrigger,
	SelectValue,
} from "@/components/ui/select";
import { cn } from "@/lib/utils";

interface EventBasicInfoProps {
	nombre: string;
	artista: string;
	categoria: string;
	venue: string;
	fecha: string; // ISO string
	errors: Record<string, string>;
	onChange: (field: string, value: string) => void;
}

export function EventBasicInfo({
	nombre,
	artista,
	categoria,
	venue,
	fecha,
	errors,
	onChange,
}: EventBasicInfoProps) {
	const dateValue = fecha ? new Date(fecha) : undefined;
	const isDateValid = dateValue && !Number.isNaN(dateValue.getTime());

	// Extraer hora completa HH:mm:ss para el input de hora
	const timeValue = isDateValid ? format(dateValue, "HH:mm:ss") : "10:30:00";

	const handleDateSelect = (selectedDate: Date | undefined) => {
		if (!selectedDate) {
			onChange("fecha", "");
			return;
		}

		const [hours = 10, minutes = 30, seconds = 0] = timeValue
			.split(":")
			.map(Number);
		selectedDate.setHours(hours, minutes, seconds, 0);

		onChange("fecha", selectedDate.toISOString());
	};

	const handleTimeChange = (timeString: string) => {
		if (!timeString) return;

		const baseDate = isDateValid ? new Date(dateValue) : new Date();
		const [hours = 0, minutes = 0, seconds = 0] = timeString
			.split(":")
			.map(Number);
		baseDate.setHours(hours, minutes, seconds, 0);

		onChange("fecha", baseDate.toISOString());
	};

	const currentYear = new Date().getFullYear();

	return (
		<div className="space-y-4">
			{/* Fila 1: Nombre y Artista */}
			<div className="grid gap-4 sm:grid-cols-2">
				<Field>
					<FieldLabel>Nombre del evento</FieldLabel>
					<Input
						value={nombre}
						onChange={(e) => onChange("nombre", e.target.value)}
						placeholder="Ej: Lana Del Rey Tour"
						aria-invalid={!!errors.nombre}
					/>
					{errors.nombre && <FieldError>{errors.nombre}</FieldError>}
				</Field>

				<Field>
					<FieldLabel>Artista</FieldLabel>
					<Input
						value={artista}
						onChange={(e) => onChange("artista", e.target.value)}
						placeholder="Ej: Lana Del Rey"
						aria-invalid={!!errors.artista}
					/>
					{errors.artista && <FieldError>{errors.artista}</FieldError>}
				</Field>
			</div>

			{/* Fila 2: Categoría y Venue */}
			<div className="grid gap-4 sm:grid-cols-2">
				<Field>
					<FieldLabel>Categoría</FieldLabel>
					<Select
						value={categoria}
						onValueChange={(val) => onChange("categoria", val)}
					>
						<SelectTrigger className="w-full rounded-lg px-3 py-5 text-sm placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring">
							<SelectValue placeholder="Selecciona una categoría" />
						</SelectTrigger>
						<SelectContent className="rounded-lg px-3 py-2">
							<SelectItem value="conciertos">Conciertos</SelectItem>
							<SelectItem value="teatro">Teatro</SelectItem>
							<SelectItem value="deportes">Deportes</SelectItem>
							<SelectItem value="entretenimiento">Entretenimiento</SelectItem>
						</SelectContent>
					</Select>
					{errors.categoria && <FieldError>{errors.categoria}</FieldError>}
				</Field>

				<Field>
					<FieldLabel>Venue</FieldLabel>
					<Input
						value={venue}
						onChange={(e) => onChange("venue", e.target.value)}
						placeholder="Ej: Estadio Nacional"
						aria-invalid={!!errors.venue}
					/>
					{errors.venue && <FieldError>{errors.venue}</FieldError>}
				</Field>
			</div>

			{/* Fila 3: Fecha y Hora */}
			<div className="grid gap-4 sm:grid-cols-2">
				<Field>
					<FieldLabel>Fecha y hora</FieldLabel>
					<div className="flex gap-4">
						{/* Seleccionador de fecha con icono ChevronDown */}
						<Popover>
							<PopoverTrigger asChild className="w-full">
								<Button
									variant={"outline"}
									className={cn(
										"w-full justify-between font-normal",
										!isDateValid && "text-muted-foreground",
										errors.fecha && "border-destructive",
									)}
								>
									{isDateValid ? (
										format(dateValue, "PPP", { locale: es })
									) : (
										<span>Selecciona fecha</span>
									)}
									<CalendarIcon className="h-4 w-4" />
								</Button>
							</PopoverTrigger>
							<PopoverContent className="w-auto p-0" align="start">
								<Calendar
									mode="single"
									captionLayout="dropdown"
									fromYear={currentYear}
									toYear={currentYear + 10}
									selected={isDateValid ? dateValue : undefined}
									onSelect={handleDateSelect}
								/>
							</PopoverContent>
						</Popover>

						<div className="w-36 shrink-0">
							{/*<Clock className="absolute left-2 top-2.5 h-4 w-4 text-muted-foreground pointer-events-none" />*/}
							<Input
								type="time"
								step="1"
								value={timeValue}
								onChange={(e) => handleTimeChange(e.target.value)}
								className="appearance-none bg-muted [&::-webkit-calendar-picker-indicator]:hidden [&::-webkit-calendar-picker-indicator]:appearance-none"
							/>
						</div>
					</div>
					{errors.fecha && <FieldError>{errors.fecha}</FieldError>}
				</Field>
			</div>
		</div>
	);
}
