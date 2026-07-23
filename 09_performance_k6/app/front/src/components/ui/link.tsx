/**
 * Componente Link que genera URLs absolutas basadas en el origen actual.
 * - Desarrollo: http://localhost:4321/eventos
 * - Producción (nginx): http://localhost/eventos o https://midominio.com/eventos
 */
export function Link({
	href,
	children,
	...props
}: {
	href: string;
	children: React.ReactNode;
	[key: string]: any;
}) {
	// Si es un link externo (http/https), usar tal cual
	if (href.startsWith("http") || href.startsWith("mailto:")) {
		return (
			<a href={href} {...props}>
				{children}
			</a>
		);
	}

	// Para links internos, usar href directo (funciona en SPA y estático)
	return (
		<a href={href} {...props}>
			{children}
		</a>
	);
}
