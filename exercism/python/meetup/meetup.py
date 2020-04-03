import datetime
import calendar
from collections import Counter


def meetup_day(year, month, day_of_the_week, which):
    day_num = weekday_num(day_of_the_week)
    c = calendar.Calendar()
    weeks = week_iter(c.monthdays2calendar(year, month))
    last = calendar.monthrange(year, month)[1]
    final = None
    counter = 0
    while final is None:
        counter += 1
        (c, day, weekday) = next(weeks)
        if which == 'teenth':
            if weekday == day_num and day in range(13, 20):
                final = day
        elif which == 'last':
            if day >= last - 6 and weekday == day_num:
                final = day
        else:
            index = int(which[0])
            if weekday == day_num and c >= index:
                final = day
        if counter >= 100:
            break
    return datetime.date(year, month, final)


def week_iter(cal):
    c = Counter()
    for week in cal:
        for day, weekday in week:
            if day > 0:
                c[weekday] += 1
                yield (c[weekday], day, weekday)


def weekday_num(day_of_the_week):
    dt = datetime.date(2017, 11, 6)
    for i in range(7):
        weekday = dt.strftime("%A")
        if day_of_the_week == weekday:
            return i
        dt += datetime.timedelta(days=1)
