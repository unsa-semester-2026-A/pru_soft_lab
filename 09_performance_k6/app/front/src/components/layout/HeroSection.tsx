import { ArrowRight, Sparkles, Ticket } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Link } from "@/components/ui/link";

export function HeroSection() {
	return (
		<section className="relative overflow-hidden bg-[var(--deep-purple)] py-20 md:py-32">
			<div className="absolute inset-0 overflow-hidden">
				<div className="absolute -top-40 -right-40 h-80 w-80 rounded-full bg-[var(--violet)] opacity-20 blur-3xl" />
				<div className="absolute -bottom-40 -left-40 h-80 w-80 rounded-full bg-[var(--teal)] opacity-20 blur-3xl" />
			</div>

			<div className="container relative mx-auto px-4 md:px-6">
				<div className="mx-auto max-w-3xl text-center">
					<div className="mb-6 inline-flex items-center gap-2 rounded-full border border-[var(--violet)]/30 bg-[var(--violet)]/10 px-4 py-1.5 text-sm text-[var(--teal)] backdrop-blur-sm">
						<Sparkles className="h-4 w-4" />
						<span>Venta de entradas en tiempo real</span>
					</div>

					<h1 className="font-heading text-4xl font-bold tracking-tight text-white sm:text-5xl md:text-6xl lg:text-7xl">
						Vive la{" "}
						<span className="bg-gradient-to-r from-[var(--teal)] to-[var(--violet)] bg-clip-text text-transparent">
							experiencia
						</span>{" "}
						de tus artistas favoritos
					</h1>

					<p className="mt-6 text-lg text-[var(--light-gray)]/70 md:text-xl">
						Consigue tus entradas de forma rápida y segura. Stock en tiempo
						real, sin filas, sin esperas.
					</p>

					<div className="mt-10 flex flex-col items-center gap-4 sm:flex-row sm:justify-center">
						<Button
							asChild
							size="lg"
							className="bg-[var(--violet)] hover:bg-[var(--violet)]/90"
						>
							<Link href="/eventos">
								<Ticket className="h-5 w-5" />
								Ver Eventos
								<ArrowRight className="h-4 w-4" />
							</Link>
						</Button>
						<Button
							variant="outline"
							size="lg"
							className="border-[var(--light-gray)]/20 text-[var(--light-gray)] hover:bg-white/10"
						>
							¿Cómo funciona?
						</Button>
					</div>

					<div className="mt-16 grid grid-cols-3 gap-8 border-t border-[var(--light-gray)]/10 pt-8">
						<div>
							<p className="text-3xl font-bold text-[var(--teal)]">100+</p>
							<p className="mt-1 text-sm text-[var(--light-gray)]/60">
								Eventos activos
							</p>
						</div>
						<div>
							<p className="text-3xl font-bold text-[var(--violet)]">50K+</p>
							<p className="mt-1 text-sm text-[var(--light-gray)]/60">
								Entradas vendidas
							</p>
						</div>
						<div>
							<p className="text-3xl font-bold text-[var(--teal)]">&lt;10ms</p>
							<p className="mt-1 text-sm text-[var(--light-gray)]/60">
								Tiempo de respuesta
							</p>
						</div>
					</div>
				</div>
			</div>
		</section>
	);
}
