/*
 * Solution to Assignment #3, Part #1.
 */
#include <stdio.h>

main()
{
  int timeDifference(int, int, int, int);
  int timeIntoMinutes(int, int);
  int timeHour(int);
  int timeMinute(int);
  int timeIsValid(int, int);
  int timeIsBefore(int, int, int, int);

  int start_hour;
  int start_minute;
  int end_hour;
  int end_minute;
  int n;
  int trip_count;
  int trip_length;

  trip_count = 0;
  while ((n = scanf("%i:%i %i:%i",
                    &start_hour, &start_minute, &end_hour, &end_minute)) == 4)
  {
    if (timeIsValid(start_hour, start_minute) == 0)
      printf("ERROR: Invalid starting time for trip #%i\n", trip_count);
    else 
    {
      if (timeIsValid(end_hour, end_minute) == 0)
        printf("ERROR: Invalid ending time for trip #%i\n", trip_count);
      else
      {
        /* Now we know all the times are valid.
         *
         * Two possibilities:
         *   1) The first time is before second, in which case we just want 
         *      the difference between them.
         *   2) The first time is after second, in which case we want to
         *      add the difference between the first time and midnight to
         *      the minutes from midnight and the second time.
         */
          
        if (timeIsBefore(end_hour, end_minute, start_hour, start_minute) == 0)
          trip_length = timeDifference(start_hour, start_minute,
                                       end_hour, end_minute);
        else
          trip_length = timeDifference(start_hour, start_minute, 24, 0) +
                        timeIntoMinutes(end_hour, end_minute);
        printf("Trip #%i was %i hours, %i minutes (%i minutes).\n",
               trip_count,
               timeHour(trip_length), timeMinute(trip_length),
               trip_length);
      }
    }
    trip_count = trip_count + 1;
  }
  if (n != EOF)
    printf("ERROR: Could not read times for trip #%i.\n", trip_count);
  return 0;
}
