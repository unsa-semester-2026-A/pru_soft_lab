import { useState } from "react";
import type { Evento } from "@/lib/api";
import { eventosApi } from "@/lib/api";
import { EventSuccess } from "./EventSuccess";
import { EventForm } from "./form/EventForm";
import { EventList } from "./list/EventList";

type View = "list" | "create" | "edit" | "success";

export function AdminEvents() {
	const [view, setView] = useState<View>("list");
	const [editingEvento, setEditingEvento] = useState<Evento | null>(null);

	const handleNew = () => {
		setEditingEvento(null);
		setView("create");
	};

	const handleEdit = (evento: Evento) => {
		setEditingEvento(evento);
		setView("edit");
	};

	const handleSubmit = async (data: any) => {
		try {
			if (editingEvento) {
				await eventosApi.actualizar(editingEvento.id, data);
			} else {
				await eventosApi.crear(data);
			}
			setView("success");
		} catch (error) {
			console.error("Error al guardar evento:", error);
			alert("Error al guardar evento");
		}
	};

	const handleCancel = () => {
		setEditingEvento(null);
		setView("list");
	};

	const handleBackToList = () => {
		setEditingEvento(null);
		setView("list");
	};

	if (view === "success") {
		return <EventSuccess isEdit={!!editingEvento} onBack={handleBackToList} />;
	}

	if (view === "create") {
		return (
			<EventForm
				mode="create"
				onSubmit={handleSubmit}
				onCancel={handleCancel}
			/>
		);
	}

	if (view === "edit" && editingEvento) {
		return (
			<EventForm
				mode="edit"
				initialData={{
					nombre: editingEvento.nombre,
					artista: editingEvento.artista,
					venue: editingEvento.venue,
					fecha: editingEvento.fecha,
					categoria: editingEvento.categoria ?? "conciertos",
					imagen_url: editingEvento.imagen_url,
					descripcion: "",
				}}
				onSubmit={handleSubmit}
				onCancel={handleCancel}
			/>
		);
	}

	return <EventList onNew={handleNew} onEdit={handleEdit} />;
}
