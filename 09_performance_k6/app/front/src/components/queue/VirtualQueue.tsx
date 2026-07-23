import { AlertTriangle, Clock, Loader2, Users } from "lucide-react";
import { useEffect, useState } from "react";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";

interface VirtualQueueProps {
	eventoNombre: string;
	onQueueComplete: () => void;
}

export function VirtualQueue({
	eventoNombre,
	onQueueComplete,
}: VirtualQueueProps) {
	const [position, setPosition] = useState(48);
	const [waitTime, setWaitTime] = useState(120); // seconds
	const [progress, setProgress] = useState(0);

	useEffect(() => {
		const interval = setInterval(() => {
			setPosition((prev) => {
				const next = prev - Math.floor(Math.random() * 3) - 1;
				if (next <= 0) {
					clearInterval(interval);
					setTimeout(onQueueComplete, 500);
					return 0;
				}
				return next;
			});
			setWaitTime((prev) =>
				Math.max(0, prev - Math.floor(Math.random() * 5) - 1),
			);
			setProgress((prev) => Math.min(100, prev + Math.random() * 3 + 1));
		}, 800);

		return () => clearInterval(interval);
	}, [onQueueComplete]);

	const formatTime = (seconds: number) => {
		const mins = Math.floor(seconds / 60);
		const secs = seconds % 60;
		return mins > 0 ? `~${mins} min ${secs} seg` : `~${secs} segundos`;
	};

	return (
		<div className="mx-auto max-w-md py-12">
			<Card className="border-2 border-primary/20">
				<CardHeader className="text-center">
					<div className="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-primary/10">
						<Loader2 className="h-8 w-8 text-primary animate-spin" />
					</div>
					<CardTitle className="text-xl">Fila Virtual</CardTitle>
				</CardHeader>
				<CardContent className="space-y-6">
					{/* Evento */}
					<div className="text-center">
						<p className="text-sm text-muted-foreground">
							Estás en la fila virtual para
						</p>
						<p className="mt-1 text-lg font-semibold text-card-foreground">
							{eventoNombre}
						</p>
					</div>

					{/* Posición */}
					<div className="flex items-center justify-center gap-3 rounded-lg bg-muted p-4">
						<Users className="h-6 w-6 text-primary" />
						<div>
							<p className="text-sm text-muted-foreground">
								Tu posición en la cola
							</p>
							<p className="text-2xl font-bold text-card-foreground">
								#{position}
							</p>
						</div>
					</div>

					{/* Progreso */}
					<div className="space-y-2">
						<div className="flex items-center justify-between text-sm">
							<span className="text-muted-foreground">Progreso</span>
							<span className="font-medium text-card-foreground">
								{Math.round(progress)}%
							</span>
						</div>
						<Progress value={progress} className="h-2" />
					</div>

					{/* Tiempo estimado */}
					<div className="flex items-center justify-center gap-3 rounded-lg bg-muted p-4">
						<Clock className="h-6 w-6 text-[var(--teal)]" />
						<div>
							<p className="text-sm text-muted-foreground">
								Tiempo estimado de espera
							</p>
							<p className="text-lg font-semibold text-card-foreground">
								{formatTime(waitTime)}
							</p>
						</div>
					</div>

					{/* Advertencia */}
					<div className="flex items-start gap-3 rounded-lg border border-yellow-200 bg-yellow-50 p-4 dark:border-yellow-800 dark:bg-yellow-950">
						<AlertTriangle className="mt-0.5 h-5 w-5 flex-shrink-0 text-yellow-600 dark:text-yellow-400" />
						<div>
							<p className="text-sm font-medium text-yellow-800 dark:text-yellow-200">
								No cierres ni recargues esta pestaña
							</p>
							<p className="mt-1 text-xs text-yellow-600 dark:text-yellow-400">
								Perderás tu turno en la cola si recargas la página.
							</p>
						</div>
					</div>

					{/* Info adicional */}
					<div className="text-center">
						<Badge variant="secondary" className="text-xs">
							Alta demanda detectada
						</Badge>
						<p className="mt-2 text-xs text-muted-foreground">
							El sistema está procesando las solicitudes en orden de llegada
						</p>
					</div>
				</CardContent>
			</Card>
		</div>
	);
}
