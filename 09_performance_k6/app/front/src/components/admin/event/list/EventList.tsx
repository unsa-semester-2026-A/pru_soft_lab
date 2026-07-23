import { Plus, Search } from "lucide-react";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useApi } from "@/lib/useApi";
import { eventosApi, type Evento } from "@/lib/api";
import { EventCard } from "./EventCard";

interface EventListProps {
	onNew: () => void;
	onEdit: (evento: Evento) => void;
}

export function EventList({ onNew, onEdit }: EventListProps) {
	const {
		data: eventos,
		loading,
		refetch,
	} = useApi<Evento[]>({ fetcher: eventosApi.listar });
	const [query, setQuery] = useState("");

	const filtered = (eventos ?? []).filter(
		(e) =>
			e.nombre.toLowerCase().includes(query.toLowerCase()) ||
			e.artista.toLowerCase().includes(query.toLowerCase()) ||
			e.venue.toLowerCase().includes(query.toLowerCase()),
	);

	const handleDelete = async (id: string) => {
		try {
			await eventosApi.eliminar(id);
			refetch();
		} catch (error) {
			console.error("Error al eliminar:", error);
			alert("Error al eliminar evento");
		}
	};

	if (loading) {
		return (
			<div className="py-12 text-center text-muted-foreground">
				Cargando eventos...
			</div>
		);
	}

	return (
		<div className="space-y-6">
			<div className="flex flex-wrap items-center justify-between gap-4">
				<div className="relative flex-1 max-w-sm">
					<Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
					<Input
						placeholder="Buscar eventos..."
						value={query}
						onChange={(e) => setQuery(e.target.value)}
						className="pl-10"
					/>
				</div>
				<Button onClick={onNew}>
					<Plus className="h-4 w-4" />
					Nuevo Evento
				</Button>
			</div>

			<div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
				{filtered.map((evento) => (
					<EventCard
						key={evento.id}
						evento={evento}
						onEdit={onEdit}
						onDelete={handleDelete}
					/>
				))}
			</div>

			{filtered.length === 0 && (
				<div className="py-12 text-center">
					<p className="text-muted-foreground">No se encontraron eventos</p>
					<Button variant="link" onClick={() => setQuery("")}>
						Limpiar búsqueda
					</Button>
				</div>
			)}
		</div>
	);
}
