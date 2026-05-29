"""In-memory repository for Habit entities."""

from datetime import date
from typing import Dict, List, Optional

# Cambiar esta importación
from finance.core.domain.habit import Habit  # ← Ahora importa de habit.py


class HabitMemoryRepository:
    """Repository for storing Habit entities in memory."""
    
    def __init__(self):
        self._habits: Dict[str, Habit] = {}
    
    def save(self, habit: Habit) -> None:
        """Save a habit to the repository."""
        if habit and habit.id:
            self._habits[habit.id] = habit
    
    def find_by_id(self, habit_id: str) -> Optional[Habit]:
        """Find a habit by its ID."""
        return self._habits.get(habit_id)
    
    def find_all(self) -> List[Habit]:
        """Return all habits."""
        return list(self._habits.values())
    
    def delete(self, habit_id: str) -> None:
        """Delete a habit by its ID."""
        if habit_id in self._habits:
            del self._habits[habit_id]
    
    def update(self, habit: Habit) -> None:
        """Update an existing habit."""
        if habit and habit.id and habit.id in self._habits:
            self._habits[habit.id] = habit
    
    def find_active_on_date(self, check_date: date) -> List[Habit]:
        """Find habits that are active on a specific date."""
        return [
            habit for habit in self._habits.values()
            if habit.is_active_on_date(check_date)
        ]
    
    def find_active_between(self, start: date, end: date) -> List[Habit]:
        """Find habits active between two dates."""
        return [
            habit for habit in self._habits.values()
            if self._overlaps_period(habit, start, end)
        ]
    
    def find_by_completion_status_on_date(self, check_date: date, completed: bool) -> List[Habit]:
        """Find habits by completion status on a specific date."""
        return [
            habit for habit in self._habits.values()
            if habit.is_completed_on(check_date) == completed
        ]
    
    def get_completions_count_in_period(self, start: date, end: date) -> Dict[str, int]:
        """Get completion counts per habit within a date period."""
        result = {}
        
        for habit_id, habit in self._habits.items():
            count = 0
            for completion_date, is_completed in habit.completions.items():
                if is_completed and start <= completion_date <= end:
                    count += 1
            result[habit_id] = count
        
        return result
    
    def _overlaps_period(self, habit: Habit, start: date, end: date) -> bool:
        """Check if a habit overlaps with a date period."""
        habit_start = habit.start_date
        habit_end = habit.end_date
        
        if habit_end and habit_end < start:
            return False
        
        if habit_start and habit_start > end:
            return False
        
        return True
    
    def clear(self) -> None:
        """Clear all habits from the repository (useful for testing)."""
        self._habits.clear()