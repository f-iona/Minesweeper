import de.bezier.guido.*;

//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons

public final static int NUM_ROWS = 10; 
public final static int NUM_COLS = 10; 
private ArrayList <MSButton> bombs = new ArrayList <MSButton> (); 
public final static int NUM_BOMBS = 12; 
public boolean lost = false; 
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
   
    buttons = new MSButton[NUM_ROWS][NUM_COLS]; //declaration of 2D arr
    
    for (int i = 0; i < NUM_ROWS; i++){
      for (int j = 0; j<NUM_COLS; j++){
        buttons[i][j] = new MSButton(i, j); 
      }
    }//fill in the compartments to make the button objects
    
    setMines();
}
public void setMines()
{
    while (bombs.size() < NUM_BOMBS){
      int r = (int)(Math.random() * NUM_ROWS); 
      int c = (int)(Math.random() * NUM_COLS);
        bombs.add(buttons[r][c]);
     // System.out.println (r + "," + c); 
    }//end while
    
}//end set mines

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for (int r = 0; r< NUM_ROWS; r++){
        for(int c=0; c< NUM_COLS; c++){
            if(buttons[r][c].flagged == false){
                return false;
            }
        }
    }
    return true;
    
}

public void displayLosingMessage()
{
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        if(bombs.contains(buttons[i][j])){
          buttons[i][j].clicked = true; 
        }
      }
    }  
    lost = true; 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 5].setLabel("G"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("A"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("M"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 2].setLabel("E"); 
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("O"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("V"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("E");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 3].setLabel("R"); 
}

public void displayWinningMessage()
{

     buttons[NUM_ROWS/2][NUM_COLS/2 - 5].setLabel("Y"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("O"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("U"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("W"); 
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("I"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("N"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("!");
   
}

public boolean isValid(int r, int c)
{
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
      return true; 
    }
    return false;
}

public int countMines(int row, int col)
{
    int numMines = 0;
   for (int i= row-1; i <= row+1; i++){
     for (int j = col -1; j<=col+1; j++){
       if (isValid(i, j) && bombs.contains(buttons[i][j])){
         numMines++; 
       }
     }
   }
       if (bombs.contains(buttons[row][col])){
         numMines--; 
     }
    return numMines;
}//end count mines

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if (lost == true){
          return
        }
      clicked = true;
        
        if (keyPressed == true|| mousePressed && mouseButton == RIGHT){
          if (flagged == true){
            flagged = false; 
        }
          
        else {
          flagged = true; 
          clicked = false; 
          }
        }
        else if (bombs.contains(this)){
          displayLosingMessage(); 
        } else if (countMines(myRow,myCol) > 0){
          myLabel = Integer.toString(countMines(myRow, myCol)); 
     //textSize(23);
        }
        else { 
        
     for (int i = myRow -1; i <= myRow+1; i++){
       for (int j = myCol -1; j<= myCol+1; j++){
         if (i!= myRow || j!=myCol){
           if (isValid(i, j) && buttons[i][j].clicked == false && countMines(i,j) == 0)
            buttons[i][j].mousePressed(); 
         }
       }
     }
     
        
        }//end big if 
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if(clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
      
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
