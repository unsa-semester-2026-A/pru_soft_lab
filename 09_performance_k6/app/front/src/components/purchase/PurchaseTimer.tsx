import { AlertTriangle, Clock } from "lucide-react";
import { useCallback, useEffect, useState } from "react";
import { Progress } from "@/components/ui/progress";

interface PurchaseTimerProps {
	durationSeconds?: number;
	onExpire: () => void;
}

export function PurchaseTimer({
	durationSeconds = 180,
	onExpire,
}: PurchaseTimerProps) {
	const [remaining, setRemaining] = useState(durationSeconds);
	const [isWarning, setIsWarning] = useState(false);

	const minutes = Math.floor(remaining / 60);
	const seconds = remaining % 60;
	const progress = ((durationSeconds - remaining) / durationSeconds) * 100;

	const handleExpire = useCallback(() => {
		onExpire();
	}, [onExpire]);

	useEffect(() => {
		if (remaining <= 0) {
			handleExpire();
			return;
		}

		if (remaining <= 60) {
			setIsWarning(true);
		}

		const timer = setInterval(() => {
			setRemaining((prev) => {
				if (prev <= 1) {
					clearInterval(timer);
					return 0;
				}
				return prev - 1;
			});
		}, 1000);

		return () => clearInterval(timer);
	}, [remaining, handleExpire]);

	const formatNumber = (n: number) => n.toString().padStart(2, "0");

	return (
		<div
			className={`rounded-lg border p-4 transition-colors ${
				isWarning
					? "border-destructive/50 bg-destructive/5"
					: "border-border bg-card"
			}`}
		>
			<div className="flex items-center justify-between">
				<div className="flex items-center gap-3">
					<div
						className={`flex h-10 w-10 items-center justify-center rounded-full ${
							isWarning
								? "bg-destructive/10 text-destructive"
								: "bg-primary/10 text-primary"
						}`}
					>
						<Clock className="h-5 w-5" />
					</div>
					<div>
						<p className="text-sm font-medium text-card-foreground">
							Tiempo restante para completar la compra
						</p>
						<p
							className={`text-2xl font-bold tabular-nums ${
								isWarning ? "text-destructive" : "text-card-foreground"
							}`}
						>
							{formatNumber(minutes)}:{formatNumber(seconds)}
						</p>
					</div>
				</div>

				{isWarning && (
					<div className="flex items-center gap-2 text-destructive">
						<AlertTriangle className="h-4 w-4" />
						<span className="text-xs font-medium">¡Apúrate!</span>
					</div>
				)}
			</div>

			<Progress
				value={progress}
				className={`mt-3 h-1.5 ${isWarning ? "[&>div]:bg-destructive" : ""}`}
			/>

			{isWarning && (
				<p className="mt-2 text-xs text-destructive">
					Tu reserva expirará si no completas la compra a tiempo. El stock será
					liberado.
				</p>
			)}
		</div>
	);
}
