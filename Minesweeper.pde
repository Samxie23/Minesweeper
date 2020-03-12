import de.bezier.guido.*;
int NUM_ROWS = 20;
int NUM_COLS = 20;
int numMines = 60;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 470);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int row = 0; row < NUM_ROWS; row++){
        for(int col = 0; col < NUM_COLS; col++){
            buttons[row][col] = new MSButton(row,col);
        }
    }
    setMines();
}
public void setMines()
{
        int r = (int)(Math.random() * NUM_ROWS);
        int c = (int)(Math.random() * NUM_COLS);
        while(numMines > mines.size()){
           if(mines.contains(buttons[r][c])){
            setMines();
            }
        else {
            mines.add(buttons[r][c]);
            }
        } 
        
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int mineCount = 0;
    int clickCount = 0;
    for(int i = 0; i<mines.size();i++){
        if(mines.get(i).isFlagged())
            mineCount++;
    }
    for(int r = 0; r< buttons.length;r++){
        for(int c = 0; c<buttons[r].length;c++){
            if(buttons[r][c].isClicked()){
                clickCount++;
            }
        }
    }
    if(mineCount == numMines && clickCount == (NUM_ROWS * NUM_COLS) - numMines){
        return true;
    }

    return false;
}
public void displayLosingMessage()
{
    for(int i = 0;i<mines.size();i++){
        mines.get(i).setClicked(true);
    }
    for(int i = 0;i<mines.size();i++){
        mines.get(i).setFlagged(false);
    }
    fill(255);
    textSize(20);
    text("You lose", 200,450);
    textSize(15);
}
public void displayWinningMessage()
{
    fill(255);
    textSize(20);
    text("You win", 200,450);
    textSize(15);
}
public boolean isValid(int r, int c)
{
    if(r<NUM_ROWS && r>=0 && c<NUM_COLS && c>=0){
        return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row - 1; r<row+2;r++){
        for(int c = col - 1; c<col+2;c++){
            if(isValid(r,c) == true && mines.contains(buttons[r][c])){
                numMines++;
            }
        }
    } 

    return numMines;
}
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
        if(mouseButton == LEFT && !flagged)
            clicked = true;
        if(mouseButton == RIGHT && flagged == true){
            flagged = false;
        }
        else if(mouseButton == RIGHT && flagged == false){
            flagged = true;
        } 
        else if( mines.contains(this)){
            displayLosingMessage();
            noLoop();
        }
         else if(clicked && countMines(myRow,myCol) > 0){
            setLabel(countMines(myRow,myCol));
         }
         else {
             for(int r = myRow - 1; r < myRow + 2;r++){
                for(int c = myCol - 1; c < myCol + 2;c++){
                    if(isValid(r,c) == true && !buttons[r][c].isClicked()){
                        buttons[r][c].mousePressed();
                    
                    }
                }
             }
         }

    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
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
        myLabel = "" + newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }

    public boolean isClicked()
    {
        return clicked;
    }
    public void setClicked(boolean a)
    {
        clicked = a;
    }
    public void setFlagged(boolean b)
    {
        flagged = b;
    }

}
