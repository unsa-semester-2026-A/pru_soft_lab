import {
	Calendar,
	Ticket,
	Users,
	DollarSign,
	TrendingUp,
	Clock,
} from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { useApi } from "@/lib/useApi";
import { adminApi, type Stats, type Compra } from "@/lib/api";

export function AdminDashboard() {
	const { data: stats } = useApi<Stats>({ fetcher: adminApi.stats });
	const { data: compras } = useApi<Compra[]>({ fetcher: adminApi.compras });

	const statsCards = [
		{
			label: "Eventos Activos",
			value: stats?.total_eventos ?? 0,
			icon: Calendar,
			color: "text-primary",
		},
		{
			label: "Entradas Vendidas",
			value: stats?.total_compras ?? 0,
			icon: Ticket,
			color: "text-[var(--teal)]",
		},
		{
			label: "Asistentes",
			value: stats?.total_asistentes ?? 0,
			icon: Users,
			color: "text-[var(--violet)]",
		},
		{
			label: "Ingresos",
			value: `S/ ${(stats?.ingresos_totales ?? 0).toLocaleString()}`,
			icon: DollarSign,
			color: "text-[var(--teal)]",
		},
	];

	const recentPurchases = compras?.slice(0, 5) ?? [];

	return (
		<div className="space-y-6">
			<div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
				{statsCards.map((stat) => {
					const Icon = stat.icon;
					return (
						<Card key={stat.label}>
							<CardContent className="flex items-center gap-4">
								<div
									className={`flex h-12 w-12 items-center justify-center rounded-lg bg-muted ${stat.color}`}
								>
									<Icon className="h-6 w-6" />
								</div>
								<div>
									<p className="text-sm text-muted-foreground">{stat.label}</p>
									<p className="text-2xl font-bold text-card-foreground">
										{stat.value}
									</p>
								</div>
							</CardContent>
						</Card>
					);
				})}
			</div>

			<div className="grid gap-6 lg:grid-cols-2">
				<Card>
					<CardHeader>
						<CardTitle className="flex items-center gap-2">
							<TrendingUp className="h-5 w-5 text-primary" />
							Compras Recientes
						</CardTitle>
					</CardHeader>
					<CardContent>
						<div className="space-y-3">
							{recentPurchases.map((c) => (
								<div
									key={c.id}
									className="flex items-center justify-between rounded-lg border border-border p-3"
								>
									<div>
										<p className="font-medium text-card-foreground">
											{c.comprador_nombre}
										</p>
										<p className="text-xs text-muted-foreground">
											{c.evento_id} • {c.zona} x{c.cantidad}
										</p>
									</div>
									<div className="text-right">
										<p className="font-bold text-card-foreground">
											S/ {c.total}
										</p>
										<Badge
											variant={
												c.estado === "confirmado" ? "default" : "secondary"
											}
											className="text-[0.6rem]"
										>
											{c.estado}
										</Badge>
									</div>
								</div>
							))}
							{recentPurchases.length === 0 && (
								<p className="text-sm text-muted-foreground text-center py-4">
									No hay compras aún
								</p>
							)}
						</div>
					</CardContent>
				</Card>

				<Card>
					<CardHeader>
						<CardTitle className="flex items-center gap-2">
							<Clock className="h-5 w-5 text-[var(--teal)]" />
							Próximos Eventos
						</CardTitle>
					</CardHeader>
					<CardContent>
						<div className="space-y-3">
							<p className="text-sm text-muted-foreground text-center py-4">
								Ver eventos en la pestaña Eventos
							</p>
						</div>
					</CardContent>
				</Card>
			</div>
		</div>
	);
}
