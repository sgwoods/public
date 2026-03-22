/*
 Solution to in-class assignment (credited as bonus marks on assignment 2)

 The following provides two examples of programs which mimic the use of
 if...then...else using only while statements.  This is awkward and only
 meant as an exercise.  DO NOT do this in your own later assignments!!

 There are many ways to do this.   The point of the assignment is to 
 understand that:
 1. If you get into a while loop you also have to get out.
    (ie you must change the entry/exit condition inside the while loop)
 2. You can change conditions inside a loop that affect the program later
    (ie you can set a value inside a loop that determines if you go in the
     second loop)
*/


#define PASS_GRADE 65

main()
{
  double grade1 = 60.0;
  double grade2 = 70.0;
  
  int test_grade( double );

  printf(" Testing Solution 1 ... \n");
  test_grade1( grade1 );
  test_grade1( grade2 );

  printf(" Testing Solution 2 ... \n");
  test_grade2( grade1 );
  test_grade2( grade2 );

}

/*  ---------------------------------------------------------------------------
    Solution #1 to Bonus
*/
int test_grade1( double grade )
  {
  
    while( grade >= PASS_GRADE )
      {
	printf(" Grade of [%lf] is a PASS! \n", grade);
	return 0;
      }
  
    printf(" Grade of [%lf] is a FAIL! \n", grade);  

  }


/*  ---------------------------------------------------------------------------
    Solution #2 to Bonus
*/
int test_grade2( double grade )
  {

    int temp = grade;
  
    while( temp >= PASS_GRADE )
      {
	printf(" Grade of [%lf] is a PASS! \n", grade);
	temp = 0;
      }

    while( temp != 0 )
      {
	printf(" Grade of [%lf] is a FAIL! \n", grade);  
	temp = 0;
      }
  }
