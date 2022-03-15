import de.bezier.guido.*;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
private ArrayList <MSButton> unclickedButtons;
public boolean firstClick = false;
public static int NUM_ROWS = 20;
public static int NUM_COLS = 20;
public static int NUM_MINES = 70;

void setup ()
{
  size(600, 750);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );


  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  unclickedButtons = new ArrayList<MSButton>();
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_ROWS; c++) {
      unclickedButtons.add(buttons[r][c]);
    }
  }
  mines = new ArrayList<MSButton>();
}
public void setMines(int myRow, int myCol) {
  while (mines.size() < NUM_MINES) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[r][c]) && ((r < myRow - 1 || r > myRow + 1) || (c < myCol - 1 || c > myCol + 1))) {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
  for (int i = 0; i < mines.size(); i++) {
    if (mines.get(i).clicked == true) {
      displayLosingMessage();
    }
  }
}
public boolean isWon() {
  for (int i = 0; i < unclickedButtons.size(); i++) {
    if (!mines.contains(unclickedButtons.get(i))) {
      return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  fill(255);
  textSize(50);
  text("YOU LOSE!", 300, 680);
}
public void displayWinningMessage()
{
  fill(255);
  textSize(50);
  text("YOU WIN!", 300, 680);
}
public boolean isValid(int r, int c)
{
  return (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS);
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      if (i != 0 || j!= 0) {
        if (isValid(row + i, col + j) && mines.contains(buttons[row+i][col+j])) {
          numMines ++;
        }
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col ) {
    width = 600/NUM_COLS;
    height = 600/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    if (firstClick == false) {
      firstClick = true;
      setMines(myRow, myCol);
    }
    if (mouseButton == RIGHT) {
      if (clicked == false) {
        if (flagged == true)
          flagged = false;
        else
          flagged = true;
      }
    }
    if (mouseButton == LEFT) {
      unclickedButtons.remove(this);
      clicked = true;
      if (countMines(myRow, myCol) == 0) {
        if (isValid(myRow + 1, myCol) && buttons[myRow + 1][myCol].clicked == false) {
          buttons[myRow + 1][myCol].mousePressed();
        }
        if (isValid(myRow - 1, myCol) && buttons[myRow - 1][myCol].clicked == false) {
          buttons[myRow - 1][myCol].mousePressed();
        }
        if (isValid(myRow, myCol - 1) && buttons[myRow][myCol - 1].clicked == false) {
          buttons[myRow][myCol - 1].mousePressed();
        }
        if (isValid(myRow, myCol + 1) && buttons[myRow][myCol + 1].clicked == false) {
          buttons[myRow][myCol + 1].mousePressed();
        }
        if (isValid(myRow + 1, myCol + 1) && buttons[myRow + 1][myCol + 1].clicked == false) {
          buttons[myRow + 1][myCol + 1].mousePressed();
        }
        if (isValid(myRow + 1, myCol - 1) && buttons[myRow + 1][myCol - 1].clicked == false) {
          buttons[myRow + 1][myCol - 1].mousePressed();
        }
        if (isValid(myRow - 1, myCol + 1) && buttons[myRow - 1][myCol + 1].clicked == false) {
          buttons[myRow - 1][myCol + 1].mousePressed();
        }
        if (isValid(myRow - 1, myCol - 1) && buttons[myRow - 1][myCol - 1].clicked == false) {
          buttons[myRow - 1][myCol - 1].mousePressed();
        }
      }
    }
  }
  public void draw () {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked) {
      fill( 200 );
      setLabel(countMines(myRow, myCol));
    } else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    if (countMines(myRow, myCol) > 0) {
      textSize(width / 2);
      if (countMines(myRow, myCol) == 1) {
        fill(0, 0, 255);
      }
      if (countMines(myRow, myCol) == 2) {
        fill(0, 255, 0);
      }
      if (countMines(myRow, myCol) == 3) {
        fill(255, 0, 0);
      }
      if (countMines(myRow, myCol) == 4) {
        fill(85, 0, 206);
      }
      if (countMines(myRow, myCol) == 5) {
        fill(155, 0, 5);
      }
      if (countMines(myRow, myCol) == 6) {
        fill(3, 161, 165);
      }
      if (countMines(myRow, myCol) >= 7) {
        fill(0);
      }
      text(myLabel, x+width/2, y+height/2);
    }
  }
  public void setLabel(String newLabel) {
    textSize(20);
    myLabel = newLabel;
  }
  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged() {
    return flagged;
  }
}
