# python_lib/date_utils.py

from datetime import datetime, timedelta
from robot.api.deco import keyword

class DateUtils:
    """Robot Framework library for date utilities."""

    @keyword
    def get_future_date(self, days: int = 1):
        """Return a future date as DD-MM-YYYY string"""
        return (datetime.today() + timedelta(days=days)).strftime("%d-%m-%Y")