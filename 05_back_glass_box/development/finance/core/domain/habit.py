"""Habit domain entity for tracking financial discipline habits."""

from dataclasses import dataclass, field
from datetime import date, timedelta
from typing import Dict, List, Optional


@dataclass(slots=True)
class Habit:
    """Habit tracking for financial discipline."""
    
    id: str
    name: str
    description: str
    start_date: date
    end_date: Optional[date]
    scheduled_days: List[int]  # 0=Lunes, 1=Martes, ..., 6=Domingo
    completions: Dict[date, bool] = field(default_factory=dict)
    
    def is_active_on_date(self, check_date: date) -> bool:
        """Verifica si el hábito está activo en una fecha específica."""
        if check_date is None:
            return False
        
        after_or_equal_start = self.start_date is not None and check_date >= self.start_date
        before_or_equal_end = self.end_date is None or check_date <= self.end_date
        
        return after_or_equal_start and before_or_equal_end
    
    def get_scheduled_days_count(self) -> int:
        """Obtiene el número de días programados dentro del rango del hábito."""
        if not self.scheduled_days:
            return 0
        
        start = self.start_date if self.start_date else date.today()
        end = self.end_date if self.end_date else date.today().replace(year=date.today().year + 1)
        
        count = 0
        current = start
        
        while current <= end:
            if current.weekday() in self.scheduled_days:
                count += 1
            current += timedelta(days=1)
        
        return count
    
    def is_completed_on(self, check_date: date) -> bool:
        """Verifica si el hábito fue completado en una fecha específica."""
        if check_date is None:
            return False
        return self.completions.get(check_date, False)
    
    def set_completed_on(self, completion_date: date, completed: bool) -> bool:
        """Marca el hábito como completado en una fecha específica.
        Antes de la fecha de inicio debe fallar."""
        if completion_date is None:
            return False
        
        if self.start_date and completion_date < self.start_date:
            return False
        
        self.completions[completion_date] = completed
        return True
    
    def get_total_completions_count(self) -> int:
        """Obtiene el número total de completaciones."""
        return sum(1 for completed in self.completions.values() if completed)
    
    def get_total_scheduled_days_count(self) -> int:
        """Obtiene el número total de días programados hasta la fecha actual."""
        return self.get_scheduled_days_count()
    
    def get_completion_rate(self) -> float:
        """Calcula la tasa de completación.
        Maneja hábitos sin días programados."""
        total_scheduled = self.get_total_scheduled_days_count()
        if total_scheduled == 0:
            return 0.0
        
        total_completed = self.get_total_completions_count()
        return total_completed / total_scheduled
    
    def get_scheduled_days_up_to(self, limit_date: date) -> List[date]:
        """Obtiene días programados hasta una fecha límite."""
        if not self.scheduled_days or limit_date is None:
            return []
        
        start = self.start_date if self.start_date else date.today()
        end = min(limit_date, self.end_date) if self.end_date else limit_date
        
        scheduled = []
        current = start
        
        while current <= end:
            if current.weekday() in self.scheduled_days:
                scheduled.append(current)
            current += timedelta(days=1)
        
        return scheduled