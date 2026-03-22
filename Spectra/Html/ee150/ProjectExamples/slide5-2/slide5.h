/*
 *prototype for "slide5".
 */


void setup(char players[2][17],char board[5][5],int chips[2]);
void displayBoard(char players[2][17], char board[5][5], int chips[2], int);
void rule1(void);
void rule2(void);
void displayWinner(char players[2][17],int);
void displayEnd(void);
void help(void);
int game_over(char board[5][5],char players[2][17]);
char do_move(int, char board[5][5], int);
int get_move(void);
int menu(void);
int switch_player(int);
char chipcolor(char color,int whoplay,char players[2][17],int chips[2]);
