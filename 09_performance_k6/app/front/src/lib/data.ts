export interface Evento {
	id: string;
	nombre: string;
	artista: string;
	venue: string;
	fecha: string;
	imagen_url: string;
	precioDesde: number;
	categoria: string;
}

export const eventos: Evento[] = [
	{
		id: "conc-001",
		nombre: "Lana Del Rey: The Did You Know Tour",
		artista: "Lana Del Rey",
		venue: "Estadio Nacional, Lima",
		fecha: "2026-08-15T21:00:00",
		imagen_url:
			"https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800",
		precioDesde: 100,
		categoria: "conciertos",
	},
	{
		id: "conc-002",
		nombre: "Julian Casablancas + The Voids Tour",
		artista: "Julian Casablancas",
		venue: "Arena Lima",
		fecha: "2026-09-20T20:00:00",
		imagen_url:
			"https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=800",
		precioDesde: 80,
		categoria: "conciertos",
	},
	{
		id: "conc-003",
		nombre: "Taylor Swift: The Eras Tour",
		artista: "Taylor Swift",
		venue: "Estadio San Marcos",
		fecha: "2026-10-05T21:30:00",
		imagen_url:
			"https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800",
		precioDesde: 150,
		categoria: "conciertos",
	},
	{
		id: "conc-004",
		nombre: "Hayley Williams: Petals for Armor",
		artista: "Hayley Williams",
		venue: "Jockey Club",
		fecha: "2026-11-12T20:30:00",
		imagen_url:
			"https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800",
		precioDesde: 100,
		categoria: "conciertos",
	},
	{
		id: "conc-005",
		nombre: "Daddy Yankee: La Última Vuelta",
		artista: "Daddy Yankee",
		venue: "Estadio Nacional, Lima",
		fecha: "2026-12-01T21:00:00",
		imagen_url:
			"https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?w=800",
		precioDesde: 120,
		categoria: "conciertos",
	},
	{
		id: "teat-001",
		nombre: "Bodas de Sangre - García Lorca",
		artista: "Compañía Nacional de Teatro",
		venue: "Gran Teatro Nacional",
		fecha: "2026-09-15T20:00:00",
		imagen_url:
			"https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?w=800",
		precioDesde: 60,
		categoria: "teatro",
	},
	{
		id: "teat-002",
		nombre: "El Principito - Experiencia Inmersiva",
		artista: "Producción Internacional",
		venue: "Centro de Convenciones",
		fecha: "2026-10-20T18:00:00",
		imagen_url:
			"https://images.unsplash.com/photo-1516307365426-bea591f05011?w=800",
		precioDesde: 90,
		categoria: "teatro",
	},
];
