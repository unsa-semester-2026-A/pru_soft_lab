import { LayoutGrid, List } from "lucide-react";
import { Button } from "@/components/ui/button";

interface ViewToggleProps {
	view: "grid" | "list";
	onChange: (view: "grid" | "list") => void;
}

export function ViewToggle({ view, onChange }: ViewToggleProps) {
	return (
		<div className="flex items-center rounded-lg border border-border">
			<Button
				variant={view === "grid" ? "default" : "ghost"}
				size="icon"
				onClick={() => onChange("grid")}
				className="h-9 w-9 rounded-r-none"
			>
				<LayoutGrid className="h-4 w-4" />
			</Button>
			<Button
				variant={view === "list" ? "default" : "ghost"}
				size="icon"
				onClick={() => onChange("list")}
				className="h-9 w-9 rounded-l-none"
			>
				<List className="h-4 w-4" />
			</Button>
		</div>
	);
}
