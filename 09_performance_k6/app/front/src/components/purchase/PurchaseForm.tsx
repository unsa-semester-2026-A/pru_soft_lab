import type { AsistenteInput } from "@/lib/validations";
import { PurchaseFormHeader } from "./form/PurchaseFormHeader";
import { PurchaseFormProgress } from "./form/PurchaseFormProgress";
import { PurchaseStepAsistentes } from "./form/PurchaseStepAsistentes";
import { PurchaseStepComprador } from "./form/PurchaseStepComprador";
import { PurchaseStepConfirmar } from "./form/PurchaseStepConfirmar";
import { type CompradorData, usePurchaseForm } from "./form/usePurchaseForm";
import { PurchaseTimer } from "./PurchaseTimer";

interface PurchaseFormProps {
	eventoNombre: string;
	zonaNombre: string;
	cantidad: number;
	precioUnitario: number;
	onConfirm: (comprador: CompradorData, asistentes: AsistenteInput[]) => void;
	onCancel: () => void;
	onExpire: () => void;
}

export function PurchaseForm({
	eventoNombre,
	zonaNombre,
	cantidad,
	precioUnitario,
	onConfirm,
	onCancel,
	onExpire,
}: PurchaseFormProps) {
	const form = usePurchaseForm(cantidad);

	const handleConfirm = () => onConfirm(form.comprador, form.asistentes);

	return (
		<div className="mx-auto max-w-2xl space-y-6">
			<PurchaseTimer durationSeconds={180} onExpire={onExpire} />
			<PurchaseFormHeader
				eventoNombre={eventoNombre}
				zonaNombre={zonaNombre}
				cantidad={cantidad}
				precioUnitario={precioUnitario}
			/>
			<PurchaseFormProgress
				currentStep={form.step}
				steps={["comprador", "asistentes", "confirmar"]}
			/>

			{form.step === "comprador" && (
				<PurchaseStepComprador
					comprador={form.comprador}
					errors={form.compradorErrors}
					onChange={form.updateComprador}
					onNext={form.goToAsistentes}
					onCancel={onCancel}
				/>
			)}

			{form.step === "asistentes" && (
				<PurchaseStepAsistentes
					asistentes={form.asistentes}
					errors={form.asistenteErrors[form.currentAsistente] || {}}
					current={form.currentAsistente}
					total={cantidad}
					onChange={form.updateAsistente}
					onSetCurrent={form.setCurrentAsistente}
					onNext={form.goToConfirmar}
					onBack={form.goBackToAsistentes}
				/>
			)}

			{form.step === "confirmar" && (
				<PurchaseStepConfirmar
					comprador={form.comprador}
					asistentes={form.asistentes}
					precioUnitario={precioUnitario}
					onConfirm={handleConfirm}
					onBack={() => form.setStep("asistentes")}
				/>
			)}
		</div>
	);
}
