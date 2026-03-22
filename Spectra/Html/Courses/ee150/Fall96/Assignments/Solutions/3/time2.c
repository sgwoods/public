/*
 * Solution to Assignment #3, Part #2.
 */
#include <stdio.h>
#include <limits.h>

main()
{
  int timeDifference(int, int, int, int);
  int timeIntoMinutes(int, int);
  int timeHour(int);
  int timeMinute(int);
  int timeIsValid(int, int);
  int timeIsBefore(int, int, int, int);

  void printTime(long minutes);   /* helper function */

  int start_hour;
  int start_minute;
  int end_hour;
  int end_minute;
  int n;
  int trip_length;
  int trip_count;           /* count of all trips entered */
  int good_trip_count;      /* count of valid trips entered */

  int longest_length;       /* length of longest trip */
  int shortest_length;      /* length of shortest trip */
  int average_length;       
  long total_length;        /* total length of all legal trips */

  trip_count = good_trip_count = 0; 

  longest_length = INT_MIN;  
  shortest_length = INT_MAX;

  while ((n = scanf("%i:%i %i:%i",
                    &start_hour, &start_minute, &end_hour, &end_minute)) == 4)
  {
    if (timeIsValid(start_hour, start_minute) == 0)
      printf("ERROR: Invalid starting time for trip #%i\n", trip_count);
    else 
      if (timeIsValid(end_hour, end_minute) == 0)
        printf("ERROR: Invalid ending time for trip #%i\n", trip_count);
      else
      {
        good_trip_count  = good_trip_count  + 1;

        if (timeIsBefore(end_hour, end_minute, start_hour, start_minute) == 0)
          trip_length = timeDifference(start_hour, start_minute,
                                       end_hour, end_minute);
        else
          trip_length = timeDifference(start_hour, start_minute, 24, 0) +
                        timeIntoMinutes(end_hour, end_minute);

        printf("Trip #%i", trip_count);   printTime(trip_length);

        total_length = total_length + trip_length;
        if (trip_length > longest_length)
          longest_length = trip_length;
        if (trip_length < shortest_length) 
          shortest_length = trip_length;
      }
    trip_count = trip_count + 1;
  }
  if (n != EOF)
    printf("ERROR: Could not read times for trip #%i.\n", trip_count);
  else 
    if (trip_count == good_trip_count)
    {
      if (trip_count != 0)
         average_length = total_length / trip_count;
      else
         average_length = 0;

      printf("Average trip");   printTime(average_length);
      printf("Longest trip");   printTime(longest_length);
      printf("Shortest trip");  printTime(shortest_length);
      printf("Total time");     printTime(total_length);
    }
  return 0;
}

void printTime(long minutes)
{
  printf(" was %li hours, %li minutes (%li minutes).\n",
          (long) timeHour(minutes), (long) timeMinute(minutes), minutes);
}
