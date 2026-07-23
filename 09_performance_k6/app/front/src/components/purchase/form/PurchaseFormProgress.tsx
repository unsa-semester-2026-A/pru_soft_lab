import { Check } from "lucide-react";

interface PurchaseFormProgressProps {
	currentStep: string;
	steps: string[];
}

export function PurchaseFormProgress({
	currentStep,
	steps,
}: PurchaseFormProgressProps) {
	return (
		<div className="flex items-center justify-center gap-2">
			{steps.map((step, i) => {
				const currentIndex = steps.indexOf(currentStep);
				const isCompleted = i < currentIndex;
				const isCurrent = step === currentStep;

				return (
					<div key={step} className="flex items-center gap-2">
						<div
							className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-bold ${
								isCurrent
									? "bg-primary text-primary-foreground"
									: isCompleted
										? "bg-[var(--teal)] text-[var(--deep-purple)]"
										: "bg-muted text-muted-foreground"
							}`}
						>
							{isCompleted ? <Check className="h-4 w-4" /> : i + 1}
						</div>
						{i < steps.length - 1 && <div className="w-8 h-0.5 bg-border" />}
					</div>
				);
			})}
		</div>
	);
}
