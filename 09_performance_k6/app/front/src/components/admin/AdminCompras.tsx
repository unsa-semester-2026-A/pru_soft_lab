import { useState } from "react";
import { Eye, Search } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Separator } from "@/components/ui/separator";
import {
	Dialog,
	DialogContent,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "@/components/ui/dialog";
import { useApi } from "@/lib/useApi";
import { adminApi, type Compra } from "@/lib/api";

export function AdminCompras() {
	const { data: compras, loading } = useApi<Compra[]>({
		fetcher: adminApi.compras,
	});
	const [query, setQuery] = useState("");

	const filtered = (compras ?? []).filter(
		(c) =>
			c.comprador_nombre.toLowerCase().includes(query.toLowerCase()) ||
			c.evento_id.toLowerCase().includes(query.toLowerCase()) ||
			c.id.toLowerCase().includes(query.toLowerCase()),
	);

	const totalIngresos = (compras ?? []).reduce((acc, c) => acc + c.total, 0);

	if (loading) {
		return (
			<div className="py-12 text-center text-muted-foreground">
				Cargando compras...
			</div>
		);
  } else {
    console.log("Compras data:", compras);
  }

	return (
		<div className="space-y-6">
			<div className="grid gap-4 sm:grid-cols-3">
				<Card>
					<CardContent>
						<p className="text-sm text-muted-foreground">Total Compras</p>
						<p className="text-2xl font-bold text-card-foreground">
							{compras?.length ?? 0}
						</p>
					</CardContent>
				</Card>
				<Card>
					<CardContent>
						<p className="text-sm text-muted-foreground">Confirmadas</p>
						<p className="text-2xl font-bold text-green-600">
							{(compras ?? []).filter((c) => c.estado === "confirmado").length}
						</p>
					</CardContent>
				</Card>
				<Card>
					<CardContent>
						<p className="text-sm text-muted-foreground">Ingresos Totales</p>
						<p className="text-2xl font-bold text-[var(--teal)]">
							S/ {totalIngresos.toLocaleString()}
						</p>
					</CardContent>
				</Card>
			</div>

			<div className="flex items-center gap-4">
				<div className="relative flex-1 max-w-sm">
					<Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
					<Input
						placeholder="Buscar por comprador, evento o ID..."
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
										ID
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Evento
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Comprador
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Zona
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Cant.
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Total
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Estado
									</th>
									<th className="px-4 py-3 text-left text-xs font-medium uppercase tracking-wider text-muted-foreground">
										Acciones
									</th>
								</tr>
							</thead>
							<tbody className="divide-y divide-border">
								{filtered.map((compra) => (
									<tr
										key={compra.id}
										className="hover:bg-muted/30 transition-colors"
									>
										<td className="px-4 py-3 text-sm font-mono text-muted-foreground">
											{compra.id.slice(0, 8)}...
										</td>
										<td className="px-4 py-3 text-sm font-medium text-card-foreground">
											{compra.evento_id}
										</td>
										<td className="px-4 py-3 text-sm text-card-foreground">
											<div>
												<p>{compra.comprador_nombre}</p>
												<p className="text-xs text-muted-foreground">
													{compra.comprador_email}
												</p>
											</div>
										</td>
										<td className="px-4 py-3 text-sm text-card-foreground">
											{compra.zona}
										</td>
										<td className="px-4 py-3 text-sm text-card-foreground">
											{compra.cantidad}
										</td>
										<td className="px-4 py-3 text-sm font-bold text-card-foreground">
											S/ {compra.total}
										</td>
										<td className="px-4 py-3">
											<span
												className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium ${
													compra.estado === "confirmado"
														? "bg-green-100 text-green-800"
														: "bg-yellow-100 text-yellow-800"
												}`}
											>
												{compra.estado}
											</span>
										</td>
										<td className="px-4 py-3">
											<Dialog>
												<DialogTrigger
													render={<Button variant="ghost" size="icon-sm" />}
												>
													<Eye className="h-4 w-4" />
												</DialogTrigger>
												<DialogContent className="sm:max-w-md">
													<DialogHeader>
														<DialogTitle>Detalle de Compra</DialogTitle>
													</DialogHeader>
													<div className="space-y-4">
														<div className="grid grid-cols-2 gap-2 text-sm">
															<div>
																<span className="text-muted-foreground">
																	ID:
																</span>{" "}
																<span className="font-mono">{compra.id}</span>
															</div>
															<div>
																<span className="text-muted-foreground">
																	Fecha:
																</span>{" "}
																{new Date(compra.fecha).toLocaleString("es-PE")}
															</div>
															<div>
																<span className="text-muted-foreground">
																	Evento:
																</span>{" "}
																{compra.evento_id}
															</div>
															<div>
																<span className="text-muted-foreground">
																	Zona:
																</span>{" "}
																{compra.zona}
															</div>
															<div>
																<span className="text-muted-foreground">
																	Total:
																</span>{" "}
																<span className="font-bold">
																	S/ {compra.total}
																</span>
															</div>
															<div>
																<span className="text-muted-foreground">
																	Estado:
																</span>{" "}
																{compra.estado}
															</div>
														</div>
														<Separator />
														<div>
															<h4 className="mb-2 text-sm font-semibold text-card-foreground">
																Asistentes
															</h4>
															<div className="space-y-2">
																{compra.asistentes.map((a, i) => (
																	<div
																		key={i}
																		className="flex items-center justify-between rounded-lg border border-border p-2 text-sm"
																	>
																		<span className="font-medium text-card-foreground">
																			{a.nombre}
																		</span>
																		<span className="text-muted-foreground">
																			DNI: {a.documento}
																		</span>
																	</div>
																))}
															</div>
														</div>
													</div>
												</DialogContent>
											</Dialog>
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
