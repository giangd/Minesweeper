//iswon make it count clicked buttons too
final static int NUM_COLS = 20;
final static int NUM_ROWS = 20;
final static int NUM_BOMBS = 20;

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList<MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
boolean play = true;
boolean win = false;
boolean lose = false;

void setup() {
    size(500, 500);
    textSize(18);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make(this);
    
    //your code to declare and initialize buttons goes here
    bombs = new ArrayList<MSButton>();
    buttons = new MSButton[20][20];
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r,c); 
        }
    }
    
    setBombs();
}

public void setBombs() {
    while(bombs.size() != NUM_BOMBS) {
        int r = (int)(Math.random()*NUM_ROWS); 
        int c = (int)(Math.random()*NUM_COLS);
        if (!bombs.contains(buttons[r][c])) {
            bombs.add(buttons[r][c]);
        }
    }
}

public void draw() {   
}
public boolean isWon() {
    int numMarked = 0;
    for (MSButton[] array : buttons) {
        for (MSButton butt : array)
            if (butt.isMarked() && bombs.contains(butt))
                numMarked++;
    }
    if (numMarked == NUM_BOMBS)
        return true;
    return false;
}
public void displayLosingMessage() {
    play = false;
    textSize(50);
    fill(30,255,30);
    text("YOU LOSE", width/2, height/2);
}
public void displayWinningMessage() {
    play = false;
    textSize(50);
    fill(255,30,30);
    text("YOU WIN", width/2, height/2);
}

public class MSButton {
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton(int rr, int cc) {
        width = 500/NUM_COLS;
        height = 500/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add(this); // register it with the manager
    }
    public boolean isMarked() {
        return marked;
    }
    public boolean isClicked() {
        return clicked;
    }
    // called by manager
    
    public void mousePressed() {
        if (!keyPressed) {
            clicked = true;
        }
        if (keyPressed && !clicked) {
            marked = !marked;
        } else if (bombs.contains(this)) {
            lose = true;
        } else if (countBombs(r,c) > 0) {
            label = Integer.toString(countBombs(r,c));
        } else {
            for (int row = -1; row < 2; row++) {
                for (int col = -1; col < 2; col++) {
                    if (isValid(row+r,col+c) && !buttons[row+r][col+c].isClicked()) {
                        buttons[row+r][col+c].mousePressed();
                    }
                }
            }
        }
    }

    public void draw() {
        if (marked)
            fill(0);
        else if (clicked && bombs.contains(this)) 
            fill(255,0,0);
        else if (clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        textSize(18);
        text(label,x+width/2,y+height/2);
        if (isWon()) {
            displayWinningMessage();
        }
    
        if (lose) {
            displayLosingMessage();
        }
    }
    public void setLabel(String newLabel) {
        label = newLabel;
    }
    public boolean isValid(int r, int c) {
        if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
            return true;
        return false;
    }
    public int countBombs(int row, int col) {
        int numBombs = 0;
        for (int r = -1; r < 2; r++) {
            for (int c = -1; c < 2; c++) {
                if (isValid(row+r,col+c) && bombs.contains(buttons[row+r][col+c])) {
                    numBombs++;
                }
            }
        }
        return numBombs;
    }
}



