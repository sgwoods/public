/*
 * Functions to do interesting time calculations:
 *
 *   timeDifference( start hour and minute, end hour and minute)
 *   timeIntoMinutes( hour, minute)
 *   timeIsValid( hour, minute )
 *   timeHourOfDay( minutes )
 *   timeMinuteOfHour ( minutes )
 *   timeIsBefore ( hour and minute, other hour and other minute)
 */

#define MINUTES_PER_HOUR 60

#define MIN_MINUTE 0
#define MAX_MINUTE 59

#define MIN_HOUR   0
#define MAX_HOUR   23

/* Compute the difference between start_hour_of_day:start_minute_of_hour
   and end_hour_of_day:end_minute_of_hour */

int timeDifference(int start_hour_of_day,
                   int start_minute_of_hour,
                   int end_hour_of_day,
                   int end_minute_of_hour)
{
  int timeIntoMinutes(int hour_of_day, int minute_of_hour);

  int start_time;
  int end_time;

  start_time = timeIntoMinutes(start_hour_of_day, start_minute_of_hour);
  end_time = timeIntoMinutes(end_hour_of_day, end_minute_of_hour);
  return end_time - start_time;
}

/*
 * Determine the minute of the day corresponding to hour_of_day:minute_of_hour.
 */
int timeIntoMinutes(int hour_of_day, int minute_of_hour)
{
  return hour_of_day * MINUTES_PER_HOUR + minute_of_hour;
}

/*
 * Determine whether the given hour and minute are legal (between 00:00 and
 * 23:59).
 */
int timeIsValid(int hour_of_day, int minute_of_hour)
{
  int inBetween(int, int, int);

  int hour_check;     /* result of checking anHour  */
  int minute_check;   /* result of checking minutes */
  int status;         /* time is ok or not */

  hour_check = inBetween(hour_of_day, MIN_HOUR, MAX_HOUR);
  if (hour_check != 1)
    status = 0;
  else
  {
    minute_check = inBetween(minute_of_hour, MIN_MINUTE, MAX_MINUTE);
    if (minute_check != 1)
      status = 0;
    else
      status = 1;
  }
  return status;
}

/*
 * Give back the hour from a number of minutes in the day.
 */
int timeHour(int minute_of_day)
{
  return minute_of_day / MINUTES_PER_HOUR;
}

/*
 * Give back the minute in an hour from the minute in the day.
 */
int timeMinute(int minute_of_day)
{
  return minute_of_day - (timeHour(minute_of_day) * MINUTES_PER_HOUR);
}

/*
 * Return 0 if first time is not before the other.
 */
int timeIsBefore(int first_hour, int first_minute,
                 int second_hour, int second_minute)
{
  if (timeDifference(first_hour, first_minute, second_hour, second_minute) < 0)
    return 0;
  return 1;
}

/*
 * Return 0 if value isn't between other two values.
 */
int inBetween(int value, int lower_bound, int upper_bound)
{
  if (value > upper_bound)
    return 0;
  if (value < lower_bound)
    return 0;
  return 1;
}

