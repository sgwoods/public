/*
 * A very messy version of our cost-computing program.
 */
#include <stdio.h>
main() {double dp;double tp;double st;double fc;
tp=23*13.95;dp=tp-tp*.18;st=dp*.075;fc=dp+st;
printf("List price per item:\t\t%7.2f\n",13.95);
printf("List price of %i items:\t\t%7.2f\n",23,tp);
printf("Price after %.1f%% discount:\t%7.2f\n",.18*100,dp);
printf("Sales tax at %.1f%%:\t\t%7.2f\n",.075*100,st);
printf("Total cost:\t\t\t%7.2f\n",fc);return 0;}
