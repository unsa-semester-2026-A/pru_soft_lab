import { useState } from "react";
import { type AsistenteInput, asistenteSchema } from "@/lib/validations";

export interface CompradorData {
	nombre: string;
	email: string;
	dni: string;
}

type Step = "comprador" | "asistentes" | "confirmar";

export function usePurchaseForm(cantidad: number) {
	const [step, setStep] = useState<Step>("comprador");
	const [comprador, setComprador] = useState<CompradorData>({
		nombre: "",
		email: "",
		dni: "",
	});
	const [compradorErrors, setCompradorErrors] = useState<
		Record<string, string>
	>({});
	const [asistentes, setAsistentes] = useState<AsistenteInput[]>(
		Array.from({ length: cantidad }, () => ({ nombre: "", documento: "" })),
	);
	const [asistenteErrors, setAsistenteErrors] = useState<
		Record<number, Record<string, string>>
	>({});
	const [currentAsistente, setCurrentAsistente] = useState(0);

	const validateComprador = (): boolean => {
		const errors: Record<string, string> = {};
		if (comprador.nombre.length < 2) errors.nombre = "Mínimo 2 caracteres";
		if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(comprador.email))
			errors.email = "Correo inválido";
		if (comprador.dni.length < 7) errors.dni = "Mínimo 7 caracteres";
		setCompradorErrors(errors);
		return Object.keys(errors).length === 0;
	};

	const validateAsistente = (): boolean => {
		const result = asistenteSchema.safeParse(asistentes[currentAsistente]);
		if (result.success) {
			setAsistenteErrors((prev) => {
				const n = { ...prev };
				delete n[currentAsistente];
				return n;
			});
			return true;
		}
		const fieldErrors: Record<string, string> = {};
		for (const issue of result.error.issues) {
			const field = issue.path[0] as string;
			if (!fieldErrors[field]) fieldErrors[field] = issue.message;
		}
		setAsistenteErrors((prev) => ({
			...prev,
			[currentAsistente]: fieldErrors,
		}));
		return false;
	};

	const updateComprador = (field: keyof CompradorData, value: string) => {
		setComprador((prev) => ({ ...prev, [field]: value }));
		if (compradorErrors[field]) {
			setCompradorErrors((prev) => {
				const n = { ...prev };
				delete n[field];
				return n;
			});
		}
	};

	const updateAsistente = (field: keyof AsistenteInput, value: string) => {
		setAsistentes((prev) => {
			const n = [...prev];
			n[currentAsistente] = { ...n[currentAsistente], [field]: value };
			return n;
		});
		if (asistenteErrors[currentAsistente]?.[field]) {
			setAsistenteErrors((prev) => {
				const n = { ...prev };
				if (n[currentAsistente]) delete n[currentAsistente][field];
				return n;
			});
		}
	};

	const goToAsistentes = () => {
		if (validateComprador()) setStep("asistentes");
	};

	const goToConfirmar = () => {
		if (!validateAsistente()) return;
		if (currentAsistente < cantidad - 1) {
			setCurrentAsistente((prev) => prev + 1);
		} else {
			setStep("confirmar");
		}
	};

	const goBackToAsistentes = () => {
		if (currentAsistente > 0) setCurrentAsistente((prev) => prev - 1);
		else setStep("comprador");
	};

	return {
		step,
		comprador,
		compradorErrors,
		asistentes,
		asistenteErrors,
		currentAsistente,
		setCurrentAsistente,
		updateComprador,
		updateAsistente,
		goToAsistentes,
		goToConfirmar,
		goBackToAsistentes,
		setStep,
	};
}
