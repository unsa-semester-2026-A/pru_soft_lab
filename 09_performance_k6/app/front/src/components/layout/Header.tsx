import { Menu, Search, Ticket, X } from "lucide-react";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Link } from "@/components/ui/link";

const navLinks = [
	{ label: "Inicio", href: "/" },
	{ label: "Eventos", href: "/eventos" },
	{ label: "Conciertos", href: "/eventos?cat=conciertos" },
	{ label: "Teatro", href: "/eventos?cat=teatro" },
];

export function Header() {
	const [isOpen, setIsOpen] = useState(false);

	return (
		<header className="sticky top-0 z-50 w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
			<div className="container mx-auto flex h-16 items-center justify-between px-4 md:px-6">
				<Link
					href="/"
					className="flex items-center gap-2 font-bold text-primary"
				>
					<Ticket className="h-6 w-6" />
					<span className="text-xl font-heading">TicketPass</span>
				</Link>

				<nav className="hidden md:flex items-center gap-6">
					{navLinks.map((link) => (
						<Link
							key={link.href}
							href={link.href}
							className="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
						>
							{link.label}
						</Link>
					))}
				</nav>

				<div className="flex items-center gap-3">
					<Button variant="ghost" size="icon" className="hidden md:flex">
						<Search className="h-4 w-4" />
					</Button>
					<Button asChild className="hidden md:inline-flex">
						<Link href="/eventos">Comprar Entradas</Link>
					</Button>
					<Button
						variant="ghost"
						size="icon"
						className="md:hidden"
						onClick={() => setIsOpen(!isOpen)}
					>
						{isOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
					</Button>
				</div>
			</div>

			{isOpen && (
				<div className="md:hidden border-t border-border/40 bg-background">
					<nav className="container mx-auto flex flex-col gap-4 px-4 py-6">
						{navLinks.map((link) => (
							<Link
								key={link.href}
								href={link.href}
								className="text-lg font-medium text-foreground hover:text-primary transition-colors"
								onClick={() => setIsOpen(false)}
							>
								{link.label}
							</Link>
						))}
						<Button asChild className="mt-2">
							<Link href="/eventos">Comprar Entradas</Link>
						</Button>
					</nav>
				</div>
			)}
		</header>
	);
}
