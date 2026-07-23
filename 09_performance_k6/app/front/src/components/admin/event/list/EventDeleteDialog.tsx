import { Trash } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
	Dialog,
	DialogClose,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "@/components/ui/dialog";

interface EventDeleteDialogProps {
	eventoNombre: string;
	onDelete: () => void;
}

export function EventDeleteDialog({
	eventoNombre,
	onDelete,
}: EventDeleteDialogProps) {
	return (
		<Dialog>
			<DialogTrigger
				render={
					<Button variant="ghost" size="icon-sm" className="text-destructive" />
				}
			>
				<Trash className="h-4 w-4" />
			</DialogTrigger>
			<DialogContent>
				<DialogHeader>
					<DialogTitle>Eliminar evento</DialogTitle>
					<DialogDescription>
						¿Estás seguro de que deseas eliminar{" "}
						<strong>"{eventoNombre}"</strong>? Esta acción no se puede deshacer.
					</DialogDescription>
				</DialogHeader>
				<DialogFooter>
					<DialogClose render={<Button variant="outline">Cancelar</Button>} />
					<Button variant="destructive" onClick={onDelete}>
						Eliminar
					</Button>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
}
