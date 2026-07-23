import {
	Calendar,
	LayoutDashboard,
	LogOut,
	Menu,
	Ticket,
	Users,
	X,
} from "lucide-react";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";

interface AdminLayoutProps {
	children: React.ReactNode;
	activeTab: string;
	onTabChange: (tab: string) => void;
}

const menuItems = [
	{ id: "dashboard", label: "Dashboard", icon: LayoutDashboard },
	{ id: "eventos", label: "Eventos", icon: Calendar },
	{ id: "compras", label: "Compras", icon: Ticket },
	{ id: "asistentes", label: "Asistentes", icon: Users },
];

export function AdminLayout({
	children,
	activeTab,
	onTabChange,
}: AdminLayoutProps) {
	const [sidebarOpen, setSidebarOpen] = useState(false);

	return (
		<div className="flex h-screen bg-background">
			{/* Sidebar - Desktop */}
			<aside className="hidden w-64 flex-col border-r border-border bg-[var(--deep-purple)] text-[var(--light-gray)] lg:flex">
				{/* Logo */}
				<div className="flex h-16 items-center gap-2 border-b border-[var(--light-gray)]/10 px-6">
					<svg
						className="h-6 w-6 text-[var(--teal)]"
						fill="none"
						viewBox="0 0 24 24"
						stroke="currentColor"
						strokeWidth={2}
					>
						<path
							strokeLinecap="round"
							strokeLinejoin="round"
							d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"
						/>
					</svg>
					<span className="text-lg font-heading font-bold text-[var(--light-gray)]">
						Admin
					</span>
				</div>

				{/* Menu */}
				<nav className="flex-1 space-y-1 p-4">
					{menuItems.map((item) => {
						const Icon = item.icon;
						const isActive = activeTab === item.id;
						return (
							<button
								key={item.id}
								onClick={() => onTabChange(item.id)}
								className={`flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-all ${
									isActive
										? "bg-[var(--violet)] text-white"
										: "text-[var(--light-gray)] opacity-60 hover:opacity-100 hover:bg-[var(--light-gray)]/10"
								}`}
							>
								<Icon className="h-5 w-5" />
								{item.label}
							</button>
						);
					})}
				</nav>

				<Separator className="bg-[var(--light-gray)]/10" />

				{/* Footer */}
				<div className="p-4">
					<a
						href="/"
						className="flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-[var(--light-gray)] opacity-60 hover:opacity-100 hover:bg-[var(--light-gray)]/10 transition-all"
					>
						<LogOut className="h-5 w-5" />
						Volver al sitio
					</a>
				</div>
			</aside>

			{/* Mobile Sidebar */}
			{sidebarOpen && (
				<div className="fixed inset-0 z-50 lg:hidden">
					<div
						className="fixed inset-0 bg-black/50"
						onClick={() => setSidebarOpen(false)}
					/>
					<aside className="fixed left-0 top-0 h-full w-64 bg-[var(--deep-purple)] text-[var(--light-gray)]">
						<div className="flex h-16 items-center justify-between border-b border-[var(--light-gray)]/10 px-6">
							<span className="text-lg font-heading font-bold">Admin</span>
							<Button
								variant="ghost"
								size="icon"
								onClick={() => setSidebarOpen(false)}
								className="text-[var(--light-gray)]"
							>
								<X className="h-5 w-5" />
							</Button>
						</div>
						<nav className="space-y-1 p-4">
							{menuItems.map((item) => {
								const Icon = item.icon;
								return (
									<button
										key={item.id}
										onClick={() => {
											onTabChange(item.id);
											setSidebarOpen(false);
										}}
										className={`flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-all ${
											activeTab === item.id
												? "bg-[var(--violet)] text-white"
												: "text-[var(--light-gray)] opacity-60 hover:opacity-100"
										}`}
									>
										<Icon className="h-5 w-5" />
										{item.label}
									</button>
								);
							})}
						</nav>
					</aside>
				</div>
			)}

			{/* Main Content */}
			<div className="flex flex-1 flex-col overflow-hidden">
				{/* Top Bar */}
				<header className="flex h-16 items-center gap-4 border-b border-border bg-card px-6">
					<Button
						variant="ghost"
						size="icon"
						className="lg:hidden"
						onClick={() => setSidebarOpen(true)}
					>
						<Menu className="h-5 w-5" />
					</Button>
					<h1 className="text-lg font-heading font-semibold text-card-foreground">
						{menuItems.find((m) => m.id === activeTab)?.label || "Dashboard"}
					</h1>
				</header>

				{/* Content */}
				<main className="flex-1 overflow-y-auto p-6">{children}</main>
			</div>
		</div>
	);
}
