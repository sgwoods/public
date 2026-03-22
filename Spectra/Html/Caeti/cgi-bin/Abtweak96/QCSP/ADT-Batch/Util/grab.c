/* Apr 10, 1997 
 * grab.c
 *       Reads in an output file from MOTORS single line override format
 *       and outputs a data file for GNUPLOT
 *       
 *  Average Version     
 *  Constraint Check version
 *
 * example ...   grab < file.input > file.output
 *
 * Steve Woods, orig Dec 1994
 */

#include <stdio.h>
#include <string.h>

#define ITERS 10
#define START 50
#define TIMES 20

main()
{
    int  Size;
    char Overf[2];
    char Ident[10];
    float Dsize;
    int NCC;
    int TCC;
    int BT;
    int V;
    float AP;
    float S;
    float Total;
    int NumS;

    int i,j;
    float max, min;
    float sum;
    float avg;

    int   size_sum;
    float size_avg;
    int   size_avgd;

    char* tcase[10];

    tcase[0] = "default";
    tcase[1] = "1783960706";
    tcase[2] = "6148712495";
    tcase[3] = "8261581571";
    tcase[4] = "4705297406";
    tcase[5] = "6724813580";
    tcase[6] = "8798969000";
    tcase[7] = "0805098560";
    tcase[8] = "4767135635";
    tcase[9] = "7685437293";

    /* loop for all cases */

    for (j=0;j<TIMES;j++) {

	size_sum = 0;
	size_avg = 0.0;
	size_avgd = 0;

	sum = 0.0;
	max = 0.0;
	min = 100000.0;

	/* read in case X, ITERS runs into an array */
	for (i=0; i<ITERS; i++)	{

	    scanf("%d %s %*s %*s %*s %*s %s %f %d %d %d %*s %d %f %f %f %d %*s %*s %*s %*s %*s %*s %*s %*s",
		  &Size,&Overf,   &Ident,&Dsize,&NCC,&TCC,&BT,    &V,&AP,&S,&Total,&NumS);

	    if ( strcmp(Ident,tcase[i]) )
		printf("Sequence error at [%d] [%s] [%s].\n",i,Ident,tcase[i]);
	    
	    /* calc avg, max, min */
	    sum = sum + TCC;
	    if (max < TCC) max = TCC;
	    if (min > TCC) min = TCC;

	    /* calc size avg */
	    size_sum += Size;
	}

	/* compute Size average */
	size_avg  = size_sum/ITERS;
	size_avgd = size_avg;         /* simply trunc result */

	/* compute average */
	avg = sum/ITERS;
	printf("%d   %f   %f   %f\n", size_avgd, avg, min, max);
    }
}

/* Local Variables: */
/* compile-command: "gcc grab.c" */
/* End: */
