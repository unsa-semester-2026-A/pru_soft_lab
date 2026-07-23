import { useState } from "react";
import { Search, User, Ticket } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { useApi } from "@/lib/useApi";
import { adminApi, type Asistente } from "@/lib/api";

export function AdminAsistentes() {
	const { data: asistentes, loading } = useApi<Asistente[]>({
		fetcher: adminApi.asistentes,
	});
	const [query, setQuery] = useState("");

	const filtered = (asistentes ?? []).filter(
		(a) =>
			a.nombre.toLowerCase().includes(query.toLowerCase()) ||
			a.documento.includes(query) ||
			a.evento_id.toLowerCase().includes(query.toLowerCase()) ||
			a.ticket_id.toLowerCase().includes(query.toLowerCase()),
	);

	const totalTickets = asistentes?.length ?? 0;
	const totalIngresos = (asistentes ?? []).reduce(
		(acc, a) => acc + a.precio,
		0,
	);

	if (loading) {
		return (
			<div className="py-12 text-center text-muted-foreground">
				Cargando asistentes...
			</div>
		);
	}

	return (
		<div className="space-y-6">
			<div className="grid gap-4 sm:grid-cols-3">
				<Card>
					<CardContent className="flex items-center gap-4">
						<div className="flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10 text-primary">
							<User className="h-6 w-6" />
						</div>
						<div>
							<p className="text-sm text-muted-foreground">Total Asistentes</p>
							<p className="text-2xl font-bold text-card-foreground">
								{totalTickets}
							</p>
						</div>
					</CardContent>
				</Card>
				<Card>
					<CardContent className="flex items-center gap-4">
						<div className="flex h-12 w-12 items-center justify-center rounded-lg bg-[var(--teal)]/10 text-[var(--teal)]">
							<Ticket className="h-6 w-6" />
						</div>
						<div>
							<p className="text-sm text-muted-foreground">Tickets Generados</p>
							<p className="text-2xl font-bold text-card-foreground">
								{totalTickets}
							</p>
						</div>
					</CardContent>
				</Card>
				<Card>
					<CardContent className="flex items-center gap-4">
						<div className="flex h-12 w-12 items-center justify-center rounded-lg bg-[var(--violet)]/10 text-[var(--violet)]">
							<Ticket className="h-6 w-6" />
						</div>
						<div>
							<p className="text-sm text-muted-foreground">Valor Total</p>
							<p className="text-2xl font-bold text-card-foreground">
								S/ {totalIngresos.toLocaleString()}
							</p>
						</div>
					</CardContent>
				</Card>
			</div>

			<div className="flex items-center gap-4">
				<div className="relative flex-1 max-w-sm">
					<Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
					<Input
						placeholder="Buscar por nombre, documento, evento o ticket..."
						value={query}
						onChange={(e) => setQuery(e.target.value)}
						className="pl-10"
					/>
				</div>
			</div>

			<Card className="p-0">
				<CardContent className="p-0">
					<div className="overflow-x-auto">
						<table className="w-full">
							<thead>
								<tr className="border-b border-border bg-muted/50">
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Ticket ID
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Nombre
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Documento
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Evento
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Zona
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Precio
									</th>
								</tr>
							</thead>
							<tbody className="divide-y divide-border">
								{filtered.map((asistente) => (
									<tr
										key={asistente.id}
										className="hover:bg-muted/30 transition-colors"
									>
										<td className="px-4 py-3 text-sm font-mono text-primary">
											{asistente.ticket_id.slice(0, 8)}...
										</td>
										<td className="px-4 py-3">
											<div className="flex items-center gap-3">
												<div className="flex h-8 w-8 items-center justify-center rounded-full bg-muted text-xs font-medium text-muted-foreground">
													{asistente.nombre
														.split(" ")
														.map((n) => n[0])
														.join("")}
												</div>
												<span className="text-sm font-medium text-card-foreground">
													{asistente.nombre}
												</span>
											</div>
										</td>
										<td className="px-4 py-3 text-sm font-mono text-muted-foreground">
											{asistente.documento}
										</td>
										<td className="px-4 py-3 text-sm text-card-foreground">
											{asistente.evento_id}
										</td>
										<td className="px-4 py-3">
											<Badge variant="secondary">{asistente.zona}</Badge>
										</td>
										<td className="px-4 py-3 text-sm font-bold text-card-foreground">
											S/ {asistente.precio}
										</td>
									</tr>
								))}
							</tbody>
						</table>
					</div>
				</CardContent>
			</Card>
		</div>
	);
}
