import { useEffect, useState } from "react";

interface UseApiOptions<T> {
	fetcher: () => Promise<T>;
	immediate?: boolean;
}

interface UseApiReturn<T> {
	data: T | null;
	loading: boolean;
	error: string | null;
	refetch: () => Promise<void>;
}

export function useApi<T>({
	fetcher,
	immediate = true,
}: UseApiOptions<T>): UseApiReturn<T> {
	const [data, setData] = useState<T | null>(null);
	const [loading, setLoading] = useState(immediate);
	const [error, setError] = useState<string | null>(null);

	const fetchData = async () => {
		setLoading(true);
		setError(null);
		try {
			const result = await fetcher();
			setData(result);
		} catch (err) {
			setError(err instanceof Error ? err.message : "Error desconocido");
		} finally {
			setLoading(false);
		}
	};

	useEffect(() => {
		if (immediate) fetchData();
	}, []);

	return { data, loading, error, refetch: fetchData };
}
