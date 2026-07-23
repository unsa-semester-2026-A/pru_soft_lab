import { Search, X } from "lucide-react";
import { useMemo, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { eventosApi } from "@/lib/api";
import { useApi } from "@/lib/useApi";
import { EventCard } from "./EventCard";
import { EventListItem } from "./EventListItem";
import { ViewToggle } from "./ViewToggle";

const categorias = [
	{ id: "todos", label: "Todos" },
	{ id: "conciertos", label: "Conciertos" },
	{ id: "teatro", label: "Teatro" },
];

export function EventsPage() {
	const {
		data: eventos,
		loading,
		error,
	} = useApi({ fetcher: eventosApi.listar });
	const [query, setQuery] = useState("");
	const [categoria, setCategoria] = useState("todos");
	const [view, setView] = useState<"grid" | "list">("grid");

	const filtered = useMemo(() => {
		if (!eventos) return [];
		return eventos.filter((e) => {
			const matchesCategoria =
				categoria === "todos" || e.categoria === categoria;
			const matchesQuery =
				!query ||
				e.nombre.toLowerCase().includes(query.toLowerCase()) ||
				e.artista.toLowerCase().includes(query.toLowerCase()) ||
				e.venue.toLowerCase().includes(query.toLowerCase());
			return matchesCategoria && matchesQuery;
		});
	}, [eventos, query, categoria]);

	if (loading) {
		return (
			<div className="py-12 text-center">
				<p className="text-muted-foreground">Cargando eventos...</p>
			</div>
		);
	}

	if (error) {
		return (
			<div className="py-12 text-center">
				<p className="text-destructive">Error: {error}</p>
				<Button variant="link" onClick={() => window.location.reload()}>
					Reintentar
				</Button>
			</div>
		);
	}

	return (
		<div>
			<div className="mb-6 flex flex-wrap items-center gap-4">
				<div className="flex flex-wrap gap-2">
					{categorias.map((cat) => (
						<Button
							key={cat.id}
							variant={categoria === cat.id ? "default" : "outline"}
							size="sm"
							onClick={() => setCategoria(cat.id)}
						>
							{cat.label}
						</Button>
					))}
				</div>

				<div className="relative flex-1 min-w-[200px]">
					<Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
					<Input
						type="text"
						value={query}
						onChange={(e) => setQuery(e.target.value)}
						placeholder="Buscar eventos, artistas..."
						className="pl-10 pr-10 h-10"
					/>
					{query && (
						<Button
							variant="ghost"
							size="icon"
							onClick={() => setQuery("")}
							className="absolute right-1 top-1/2 -translate-y-1/2 h-8 w-8"
						>
							<X className="h-4 w-4" />
						</Button>
					)}
				</div>

				<ViewToggle view={view} onChange={setView} />
			</div>

			<div className="mb-6 flex items-center justify-between">
				<p className="text-sm text-muted-foreground">
					Mostrando{" "}
					<span className="font-semibold text-foreground">
						{filtered.length}
					</span>{" "}
					eventos
				</p>
			</div>

			{filtered.length === 0 ? (
				<div className="py-20 text-center">
					<p className="text-lg text-muted-foreground">
						No se encontraron eventos
					</p>
					<Button
						variant="link"
						onClick={() => {
							setQuery("");
							setCategoria("todos");
						}}
					>
						Limpiar filtros
					</Button>
				</div>
			) : view === "grid" ? (
				<div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
					{filtered.map((evento) => (
						<EventCard key={evento.id} evento={evento} />
					))}
				</div>
			) : (
				<div className="space-y-3">
					{filtered.map((evento) => (
						<EventListItem key={evento.id} evento={evento} />
					))}
				</div>
			)}
		</div>
	);
}
