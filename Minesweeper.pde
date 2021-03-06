//somethimes when you flag in the beginning the blocks around it are flagged
final static int NUM_COLS = 20;
final static int NUM_ROWS = 20;
final static int NUM_BOMBS = 40;

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList<MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
float xAlign = 0;
float yAlign = 0;
boolean win = false;
boolean lose = false;
boolean play = true;

void setup() {
    size(600, 700);
    textSize(18);
    textAlign(CENTER,CENTER);
    win = false;
    lose = false;
    play = true;
    frameRate(30);
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
    fill(210);
    background(210);
    if (isWon()) {
        displayWinningMessage();
    } else if (lose) {
        displayLosingMessage();
    } 
}

void keyPressed() {
    if (key == 'r') {
        setup();
    }
}


public boolean isWon() {
    int numMarked = 0;
    int numClicked = 0;
    for (MSButton[] array : buttons) {
        for (MSButton butt : array) {
            if (butt.isMarked() && bombs.contains(butt))
                numMarked++;
            if (butt.isClicked() && !bombs.contains(butt))
                numClicked++;
        }
    }

    if (numMarked+numClicked == NUM_COLS*NUM_ROWS)
        return true;
    return false;
}
public void displayLosingMessage() {
    play = false;
    textSize(30);
    fill(255,50,50);
    text("CLICK HERE TO LOSE AGAIN!", width/2+xAlign, 60+yAlign);
    if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < 100 && mousePressed) {
        setup();
    } 
}
public void displayWinningMessage() {
    play = false;
    textSize(30);
    fill(50,200,50);
    text("CLICK HERE TO PLAY AGAIN!", width/2+xAlign, 60+yAlign);
    if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < 100 && mousePressed) {
        setup();
    } 
}

public class MSButton {
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton(int rr, int cc) {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height+100;
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
        if (play) {
            if (!keyPressed && mouseButton == LEFT && !marked || !keyPressed && !marked && mouseButton != RIGHT) {
                clicked = true;
            }
            if (keyPressed && !clicked || mouseButton == RIGHT && !clicked) {
                marked = !marked;
            } else if (bombs.contains(this) && !marked) {
                lose = true;
            } else if (countBombs(r,c) > 0  && !marked) {
                label = ""+countBombs(r,c);
            } else if (!marked && clicked){
                for (int row = -1; row < 2; row++) {
                    for (int col = -1; col < 2; col++) {
                        if (isValid(row+r,col+c) && !buttons[row+r][col+c].isClicked()) {
                            buttons[row+r][col+c].mousePressed();
                        }
                    }
                }
            }
        }
    }

    public void draw() {
        if (marked)
            fill(40);
        else if (clicked && bombs.contains(this)) 
            fill(255,0,0);
        else if (clicked)
            fill(189);
        else 
            fill(122);

        stroke(255);
        rect(x, y, width, height);
        textSize(18);
        if (label.equals("1")) {
            fill(0,0,255);    
        } else if (label.equals("2")) {
            fill(0, 121, 0);
        } else if (label.equals("3")) {
            fill(255, 0, 0);
        } else if (label.equals("4")) {
            fill(0,0,123);
        } else if (label.equals("5")) {
            fill(123,0,0);
        } else {
            fill(0);
        }
        
        text(label,x+width/2+xAlign,y+height/2-2+yAlign);
        // if (isWon()) {
        //     displayWinningMessage();
        // }
    
        // if (lose) {
        //     displayLosingMessage();
        // }
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


