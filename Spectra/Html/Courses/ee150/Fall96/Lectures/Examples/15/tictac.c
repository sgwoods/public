/*
 * Tic-tac-toe monitoring game.
 */

#define BOARD_SIZE 3

main()
{
  void initBoard(char b[][BOARD_SIZE], int rows);
  int makeMove(char b[][BOARD_SIZE], char piece, int row, int col);
  char printBoard(char b[][BOARD_SIZE], int rows);
  int fullBoard(char b[][BOARD_SIZE]);
  int winningBoard(char b[][BOARD_SIZE], char piece);

  char board[BOARD_SIZE][BOARD_SIZE];       /* board */
  char piece;
  int row, col;
 
  initBoard(board, BOARD_SIZE);
  while (printf("Move (piece, row, col)? "),
         scanf("%c %i %i", &piece, &row, &col) == 3)
  {
    int c=getchar();  /* grab CR at end of line */

    if (makeMove(board, piece, row, col))
    {
      printBoard(board, BOARD_SIZE);
      if (fullBoard(board))
      {
        printf("It's a draw\n");
        break;
      }
      if (winningBoard(board, piece))
      {
        printf("%c wins\n", piece);
        break;
      }
    }
  }
  return 0;
}

int makeMove(char b[][BOARD_SIZE], char piece, int row, int col)
{
  if (row > BOARD_SIZE || row <= 0 || col > BOARD_SIZE || col <= 0 ||
      b[row - 1][col - 1] != ' ')
    return 0;    /* can't move there */
  b[row - 1][col - 1] = piece;
  return 1;
}

void initBoard(char b[][BOARD_SIZE], int rows)
{
  int r, c;

  for (r = 0; r < rows; r++)
    for (c = 0; c < BOARD_SIZE; c++)
      b[r][c] = ' ';
}

char printBoard(char b[][BOARD_SIZE], int rows)
{
  int r, c;

  for (r = 0; r < rows; r++)
  {
    for (c = 0; c < BOARD_SIZE; c++)
      putchar(b[r][c]);
    putchar('\n');
  }
}

int fullBoard(char b[][BOARD_SIZE])
{
  int r, c;

  for (r = 0; r < BOARD_SIZE; r++)
    for (c = 0; c < BOARD_SIZE; c++)
      if (b[r][c] == ' ')
        return 0;  /* board not full */
  return 1;   /* board is full */
}

int winningBoard(char b[][BOARD_SIZE], char piece)
{
  int winningLine(char b[][BOARD_SIZE], char piece, int row, int col,
                  int rinc, int cinc);
  int r, c;

  for (r = 0; r < BOARD_SIZE; r++)              /* Check Rows */
    if (winningLine(b, piece, r, 0, 0, 1))
      return 1;
  for (c = 0; c < BOARD_SIZE; c++)              /* Check Cols */
    if (winningLine(b, piece, 0, c, 1, 0))
      return 1;

  return winningLine(b, piece, 0, 0, 1, 1) || 
         winningLine(b, piece, 0, BOARD_SIZE - 1, 1, -1);
}

int winningLine(char b[][BOARD_SIZE], char piece, int nextrow, int nextcol,
                int rowinc, int colinc)
{
  int i;

  for (i = 0; i < BOARD_SIZE; i++, nextrow += rowinc, nextcol += colinc)
    if (b[nextrow][nextcol] != piece)
      return 0;
  return 1;
}
