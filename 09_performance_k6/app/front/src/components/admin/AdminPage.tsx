import { useState } from "react";
import { AdminAsistentes } from "./AdminAsistentes";
import { AdminCompras } from "./AdminCompras";
import { AdminDashboard } from "./AdminDashboard";
import { AdminLayout } from "./AdminLayout";
import { AdminEvents } from "./event/AdminEvents";

export function AdminPage() {
	const [activeTab, setActiveTab] = useState("dashboard");

	const renderContent = () => {
		switch (activeTab) {
			case "dashboard":
				return <AdminDashboard />;
			case "eventos":
				return <AdminEvents />;
			case "compras":
				return <AdminCompras />;
			case "asistentes":
				return <AdminAsistentes />;
			default:
				return <AdminDashboard />;
		}
	};

	return (
		<AdminLayout activeTab={activeTab} onTabChange={setActiveTab}>
			{renderContent()}
		</AdminLayout>
	);
}
