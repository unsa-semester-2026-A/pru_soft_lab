"""Unit tests for Habit memory repository."""

import sys
from pathlib import Path

import pytest
from datetime import date

# Add development to path
sys.path.insert(0, str(Path(__file__).parent / "development"))

from finance.core.domain.habit import Habit
from finance.adapters.outbound.db_memory.habit_memory_repository import (
    HabitMemoryRepository,
)


class TestHabitMemoryRepository:
    """Test suite for HabitMemoryRepository."""

    @pytest.fixture
    def repository(self):
        """Create a fresh repository for each test."""
        return HabitMemoryRepository()

    @pytest.fixture
    def sample_habits(self):
        """Create sample habits for testing."""
        habit1 = Habit(
            id="1",
            name="Exercise",
            description="Daily exercise",
            start_date=date(2024, 1, 1),
            end_date=date(2024, 1, 31),
            scheduled_days=[0, 2, 4],  # Mon, Wed, Fri
        )

        habit2 = Habit(
            id="2",
            name="Read",
            description="Read 30 minutes",
            start_date=date(2024, 1, 1),
            end_date=date(2024, 12, 31),
            scheduled_days=[1, 3, 5],  # Tue, Thu, Sat
        )

        habit3 = Habit(
            id="3",
            name="Meditate",
            description="Daily meditation",
            start_date=date(2024, 2, 1),
            end_date=date(2024, 2, 28),
            scheduled_days=[],  # No scheduled days
        )

        return [habit1, habit2, habit3]

    def test_save_and_find_by_id(self, repository, sample_habits):
        """PE-01: Test basic CRUD operations."""
        habit = sample_habits[0]
        repository.save(habit)

        found = repository.find_by_id("1")
        assert found is not None
        assert found.name == "Exercise"
        assert found.id == "1"

        repository.delete("1")
        assert repository.find_by_id("1") is None

    def test_find_all(self, repository, sample_habits):
        """Test finding all habits."""
        for habit in sample_habits:
            repository.save(habit)

        all_habits = repository.find_all()
        assert len(all_habits) == 3

    def test_update(self, repository, sample_habits):
        """Test updating a habit."""
        habit = sample_habits[0]
        repository.save(habit)

        # Update the habit
        habit.name = "Updated Exercise"
        repository.update(habit)

        found = repository.find_by_id("1")
        assert found.name == "Updated Exercise"

    def test_find_active_on_date(self, repository, sample_habits):
        """PE-02: Test filtering habits active on a specific date."""
        for habit in sample_habits:
            repository.save(habit)

        active_jan15 = repository.find_active_on_date(date(2024, 1, 15))
        assert len(active_jan15) == 2  # Habit 1 and 2
        assert {h.name for h in active_jan15} == {"Exercise", "Read"}

        active_feb15 = repository.find_active_on_date(date(2024, 2, 15))
        assert len(active_feb15) == 2  # Habit 2 and 3
        assert {h.name for h in active_feb15} == {"Read", "Meditate"}

    def test_find_active_between(self, repository, sample_habits):
        """PE-03: Test filtering habits active between dates."""
        for habit in sample_habits:
            repository.save(habit)

        active_in_jan = repository.find_active_between(
            date(2024, 1, 1), date(2024, 1, 31)
        )
        assert len(active_in_jan) == 2  # Habits 1 and 2

        active_in_feb = repository.find_active_between(
            date(2024, 2, 1), date(2024, 2, 28)
        )
        assert len(active_in_feb) == 2  # Habits 2 and 3

    def test_is_active_on_date_boundaries(self, sample_habits):
        """AVL-01: Test is_active_on_date with boundary dates."""
        habit = sample_habits[0]  # Jan 1-31, 2024

        # Before start date
        assert habit.is_active_on_date(date(2023, 12, 31)) is False

        # On start date
        assert habit.is_active_on_date(date(2024, 1, 1)) is True

        # Within range
        assert habit.is_active_on_date(date(2024, 1, 15)) is True

        # On end date
        assert habit.is_active_on_date(date(2024, 1, 31)) is True

        # After end date
        assert habit.is_active_on_date(date(2024, 2, 1)) is False

    def test_set_completed_on_before_start_date_fails(self, sample_habits):
        """AVL-02: Test set_completed_on fails for dates before start_date."""
        habit = sample_habits[0]  # Starts Jan 1, 2024

        # Try to complete before start date
        result = habit.set_completed_on(date(2023, 12, 31), True)
        assert result is False
        assert habit.is_completed_on(date(2023, 12, 31)) is False

        # Complete on valid date
        result = habit.set_completed_on(date(2024, 1, 15), True)
        assert result is True
        assert habit.is_completed_on(date(2024, 1, 15)) is True

    def test_get_scheduled_days_count_various_configurations(self, sample_habits):
        """AVL-03: Test get_scheduled_days_count with different configurations."""
        # Habit with scheduled days (Jan 2024: 14 days - Mon, Wed, Fri)
        scheduled_count = sample_habits[0].get_scheduled_days_count()
        assert scheduled_count == 14  # Enero 2024: 14 días (Lun, Mié, Vie)

        # Habit with no scheduled days
        assert sample_habits[2].get_scheduled_days_count() == 0

    def test_completion_rate_with_no_scheduled_days(self, sample_habits):
        """Test completion rate with habits that have no scheduled days."""
        habit = sample_habits[2]  # Meditate habit with no scheduled days

        # Complete on some dates
        habit.set_completed_on(date(2024, 2, 1), True)
        habit.set_completed_on(date(2024, 2, 2), True)

        # Rate should be 0 because no scheduled days
        assert habit.get_completion_rate() == 0.0

        # Total completions should count
        assert habit.get_total_completions_count() == 2

        # Total scheduled days should be 0
        assert habit.get_total_scheduled_days_count() == 0

    def test_completion_rate_with_past_dates(self, sample_habits):
        """Test completion rate calculation with past dates."""
        habit = sample_habits[1]  # Read habit

        # Complete some scheduled days
        habit.set_completed_on(date(2024, 1, 2), True)  # Tuesday
        habit.set_completed_on(date(2024, 1, 4), True)  # Thursday
        habit.set_completed_on(date(2024, 1, 6), False)  # Saturday not completed

        rate = habit.get_completion_rate()
        # 2 completions out of total scheduled days
        assert 0 < rate < 1

    def test_get_scheduled_days_count_no_end_date(self):
        """AVL-04: Test get_scheduled_days_count with no end date."""
        habit_no_end = Habit(
            id="4",
            name="No End",
            description="Habit without end date",
            start_date=date(2024, 1, 1),
            end_date=None,
            scheduled_days=[0],  # Mondays only
        )

        count = habit_no_end.get_scheduled_days_count()
        assert count > 0  # Should calculate up to reasonable limit

    def test_find_by_completion_status(self, repository, sample_habits):
        """PE-04: Test filtering by completion status on a date."""
        for habit in sample_habits:
            repository.save(habit)

        # Mark completions
        sample_habits[0].set_completed_on(date(2024, 1, 1), True)
        sample_habits[0].set_completed_on(date(2024, 1, 3), True)

        completed_on_jan1 = repository.find_by_completion_status_on_date(
            date(2024, 1, 1), True
        )
        assert len(completed_on_jan1) == 1
        assert completed_on_jan1[0].name == "Exercise"

        not_completed_on_jan1 = repository.find_by_completion_status_on_date(
            date(2024, 1, 1), False
        )
        assert len(not_completed_on_jan1) == 2

    def test_get_completions_count_in_period(self, repository, sample_habits):
        """PE-05: Test counting completions within a period."""
        for habit in sample_habits:
            repository.save(habit)

        # Register multiple completions
        sample_habits[0].set_completed_on(date(2024, 1, 1), True)
        sample_habits[0].set_completed_on(date(2024, 1, 3), True)
        sample_habits[0].set_completed_on(date(2024, 1, 5), True)

        sample_habits[1].set_completed_on(date(2024, 1, 2), True)
        sample_habits[1].set_completed_on(date(2024, 1, 4), True)

        counts = repository.get_completions_count_in_period(
            date(2024, 1, 1), date(2024, 1, 7)
        )

        assert counts["1"] == 3
        assert counts["2"] == 2
        assert counts["3"] == 0

    def test_habit_with_null_end_date(self):
        """Test habit behavior with null end date."""
        habit = Habit(
            id="5",
            name="Ongoing",
            description="Ongoing habit",
            start_date=date(2024, 1, 1),
            end_date=None,
            scheduled_days=[0, 1, 2, 3, 4],  # Weekdays
        )

        # Should be active on future dates
        future_date = date(2025, 12, 31)
        assert habit.is_active_on_date(future_date) is True

        # Set completion on future date
        assert habit.set_completed_on(future_date, True) is True
        assert habit.is_completed_on(future_date) is True

    def test_clear_repository(self, repository, sample_habits):
        """Test clearing all habits from repository."""
        for habit in sample_habits:
            repository.save(habit)

        assert len(repository.find_all()) == 3

        repository.clear()
        assert len(repository.find_all()) == 0
