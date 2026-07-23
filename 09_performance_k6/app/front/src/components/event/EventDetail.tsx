import { ArrowLeft } from "lucide-react";
import { useEffect, useState } from "react";
import { Link } from "@/components/ui/link";
import { type Evento, eventosApi } from "@/lib/api";
import { PurchaseForm } from "../purchase/PurchaseForm";
import { VirtualQueue } from "../queue/VirtualQueue";
import { EventInfo } from "./detail/EventInfo";
import { EventSidebar } from "./detail/EventSidebar";
import { EventSuccess } from "./detail/EventSuccess";

type Step = "zonas" | "cola" | "datos" | "exito";

export function EventDetail() {
	const [evento, setEvento] = useState<Evento | null>(null);
	const [loading, setLoading] = useState(true);
	const [step, setStep] = useState<Step>("zonas");
	const [selectedZona, setSelectedZona] = useState<string | null>(null);
	const [cantidad, setCantidad] = useState(1);

	useEffect(() => {
		const params = new URLSearchParams(window.location.search);
		const id = params.get("id");
		if (id) {
			eventosApi
				.obtener(id)
				.then(setEvento)
				.catch(console.error)
				.finally(() => setLoading(false));
		}
	}, []);

	if (loading) {
		return (
			<div className="py-20 text-center text-muted-foreground">
				Cargando evento...
			</div>
		);
	}

	if (!evento) {
		return (
			<div className="py-20 text-center">
				<p className="text-muted-foreground">Evento no encontrado</p>
				<Link href="/eventos" className="text-primary hover:underline">
					Ver eventos
				</Link>
			</div>
		);
	}

	const zonaSeleccionada = evento.zonas.find((z) => z.id === selectedZona);

	const handleReservar = () => {
		const isHighDemand = (zonaSeleccionada?.stock_disponible ?? 0) < 30;
		setStep(isHighDemand ? "cola" : "datos");
	};

	const handleConfirmar = () => setStep("exito");

	const handleExpire = () => {
		alert("Tu reserva ha expirado. El stock ha sido liberado.");
		setStep("zonas");
		setSelectedZona(null);
	};

	return (
		<div>
			<Link
				href="/eventos"
				className="mb-6 inline-flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground transition-colors"
			>
				<ArrowLeft className="h-4 w-4" />
				Volver a eventos
			</Link>

			{step === "zonas" && (
				<div className="grid gap-8 lg:grid-cols-[1fr_400px]">
					<EventInfo {...evento} />
					<EventSidebar
						zonas={evento.zonas}
						selectedZona={selectedZona}
						cantidad={cantidad}
						onSelectZona={setSelectedZona}
						onCantidadChange={setCantidad}
						onReservar={handleReservar}
					/>
				</div>
			)}

			{step === "cola" && (
				<VirtualQueue
					eventoNombre={evento.nombre}
					onQueueComplete={() => setStep("datos")}
				/>
			)}

			{step === "datos" && zonaSeleccionada && (
				<PurchaseForm
					eventoNombre={evento.nombre}
					zonaNombre={zonaSeleccionada.nombre}
					cantidad={cantidad}
					precioUnitario={zonaSeleccionada.precio}
					onConfirm={handleConfirmar}
					onCancel={() => setStep("zonas")}
					onExpire={handleExpire}
				/>
			)}

			{step === "exito" && zonaSeleccionada && (
				<EventSuccess
					eventoNombre={evento.nombre}
					zonaNombre={zonaSeleccionada.nombre}
					cantidad={cantidad}
					precioUnitario={zonaSeleccionada.precio}
				/>
			)}
		</div>
	);
}
