/******************************************
        Reconfigurable Interaction
        No.2
        2015 Seiya Iwasaki
******************************************/

import java.awt.Rectangle;
import java.awt.Point;

/** アプリケーション：「パズル合わせ」 **/
class AppPuzzle extends PuzzlePlayer{
    /*-- Field --*/
    private Rectangle appField;         // アプリケーション描画用画面割り当て
    private Point fieldCenter;          // 画面中心位置
    private PImage whiteout;            // 非選択中のパズルをホワイトアウトするためのマスク
    private int puzzleSize;             // パズルの大きさ
    private int interval;               // パズル同士の間隔
    private RegularPolygon rTriangle;   // 正三角形描画クラス
    private RegularPolygon rRectangle;  // 正四角形描画クラス
    private RegularPolygon rPentagon;   // 正五角形描画クラス


    /*-- Constractor --*/
    AppPuzzle(){
        appField = new Rectangle(0, 0, width / 3, height);
        fieldCenter = new Point(appField.x + appField.width / 2, appField.y + appField.height / 2);
        whiteout = loadImage("whiteout.png");
        puzzleSize = 140;
        interval = 40;
        rTriangle = new RegularPolygon(3, puzzleSize, 0, fieldCenter);
        rRectangle = new RegularPolygon(4, puzzleSize, 0, fieldCenter);
        rPentagon = new RegularPolygon(5, puzzleSize, 0, fieldCenter);
    }


    /*-- Draw --*/
    /* 多角形描画クラスを配列にしてコードを簡潔化するのもあり */
    public void draw(){
        switch(getVertex()){
            case 0:
                super.draw(fieldCenter, puzzleSize);
                // 非選択角数のパズルを描画
                fill(#2c2c2c);
                rPentagon.changeCenter(new Point(fieldCenter.x, fieldCenter.y - (puzzleSize + interval)));
                rPentagon.changeAngle(0);
                rPentagon.draw();
                rTriangle.changeCenter(new Point(fieldCenter.x, fieldCenter.y + (puzzleSize + interval)));
                rTriangle.changeAngle(0);
                rTriangle.draw();
                // 非選択色のパズルを描画
                fill(getPreColor());
                ellipse(fieldCenter.x - (puzzleSize + interval), fieldCenter.y, puzzleSize, puzzleSize);    
                fill(getNextColor());
                ellipse(fieldCenter.x + (puzzleSize + interval), fieldCenter.y, puzzleSize, puzzleSize);
                break;
            case 3:
                super.draw(fieldCenter, rTriangle);
                // 非選択角数のパズルを描画
                fill(#2c2c2c);
                ellipse(fieldCenter.x, fieldCenter.y - (puzzleSize + interval), puzzleSize, puzzleSize);
                rRectangle.changeCenter(new Point(fieldCenter.x, fieldCenter.y + (puzzleSize + interval)));
                rRectangle.changeAngle(0);
                rRectangle.draw();
                // 非選択色のパズルを描画
                fill(getPreColor());
                rTriangle.changeCenter(new Point(fieldCenter.x - (puzzleSize + interval), fieldCenter.y));
                rTriangle.changeAngle(0);
                rTriangle.draw();    
                fill(getNextColor());
                rTriangle.changeCenter(new Point(fieldCenter.x + (puzzleSize + interval), fieldCenter.y));
                rTriangle.draw();
                break;
            case 4:
                super.draw(fieldCenter, rRectangle);
                // 非選択角数のパズルを描画
                fill(#2c2c2c);
                rTriangle.changeCenter(new Point(fieldCenter.x, fieldCenter.y - (puzzleSize + interval)));
                rTriangle.changeAngle(0);
                rTriangle.draw();
                rPentagon.changeCenter(new Point(fieldCenter.x, fieldCenter.y + (puzzleSize + interval)));
                rPentagon.changeAngle(0);
                rPentagon.draw();
                // 非選択色のパズルを描画
                fill(getPreColor());
                rRectangle.changeCenter(new Point(fieldCenter.x - (puzzleSize + interval), fieldCenter.y));
                rRectangle.changeAngle(0);
                rRectangle.draw();    
                fill(getNextColor());
                rRectangle.changeCenter(new Point(fieldCenter.x + (puzzleSize + interval), fieldCenter.y));
                rRectangle.draw();
                break;
            case 5:
                super.draw(fieldCenter, rPentagon);
                // 非選択角数のパズルを描画
                fill(#2c2c2c);
                rRectangle.changeCenter(new Point(fieldCenter.x, fieldCenter.y - (puzzleSize + interval)));
                rRectangle.changeAngle(0);
                rRectangle.draw();
                ellipse(fieldCenter.x, fieldCenter.y + (puzzleSize + interval), puzzleSize, puzzleSize);
                // 非選択色のパズルを描画
                fill(getPreColor());
                rPentagon.changeCenter(new Point(fieldCenter.x - (puzzleSize + interval), fieldCenter.y));
                rPentagon.changeAngle(0);
                rPentagon.draw();    
                fill(getNextColor());
                rPentagon.changeCenter(new Point(fieldCenter.x + (puzzleSize + interval), fieldCenter.y));
                rPentagon.draw();
                break;
            default:
                break;
        }

        // マスクの描画
        imageMode(CENTER);
        image(whiteout, fieldCenter.x, fieldCenter.y);
    }
}

/** 「パズル合わせ」のプレイヤー状態クラス **/
class PuzzlePlayer{
    /*-- Field --*/
    private int pvertex;                // プレイヤーが入力したパズルの角数
    private int pcolor;                 // プレイヤーが入力したパズルの色
    private float pangle;               // プレイヤーが入力したパズルの角度

    // プレイヤーが選択可能な角数
    private int vertexList[] = new int[]{0, 3, 4, 5};
    // プレイヤーが選択可能な色
    private color colorList[] = new color[]{
        #E55B5B,
        #E5E55B,
        #5BE55B,
        #5BE5E5,
        #5B5BE5,
        #E55BE5
    };  

    /*-- Constractor --*/
    PuzzlePlayer(){
        pvertex = 1;
        pcolor = 0;
        pangle = 0;
    }

    /*-- Draw --*/
    public void draw(Point center, int size){
        ellipseMode(CENTER);
        fill(getColor());
        ellipse(center.x, center.y, size, size);
    }
    public void draw(Point center, RegularPolygon polygon){
        fill(getColor());
        polygon.changeCenter(center);
        polygon.changeAngle(pangle);
        polygon.draw();
    }

    /*-- Method --*/

    // 角数の変更
    public void changeVertex(int direction){
        if(direction > 0){
            pvertex++;
        }else{
            pvertex--;
        }

        if(pvertex == vertexList.length){
            pvertex = 0;
        }else if(pvertex == -1){
            pvertex = vertexList.length - 1;
        }
    }

    // 色の変更
    public void changeColor(int direction){
        if(direction > 0){
            pcolor--;
        }else{
            pcolor++;
        }

        if(pcolor == colorList.length){
            pcolor = 0;
        }else if(pcolor == -1){
            pcolor = colorList.length - 1;
        }
    }

    // 角度の変更
    public void changeAngle(int val){
        pangle += val * 10;
        if(pangle >= 360) pangle -= 360;
        else if(pangle <= 0) pangle += 360;
        print("current angle");
        println(pangle);
    }

    // 選択中のパズルの角数を取得
    public int getVertex(){
        return vertexList[pvertex];
    }

    // 選択中のパズルの色を取得
    public color getColor(){
        return colorList[pcolor];
    }
    public color getPreColor(){
        if(pcolor == 0){
            return colorList[colorList.length - 1];
        }else{
            return colorList[pcolor - 1];
        }
    }
    public color getNextColor(){
        if(pcolor == colorList.length - 1){
            return colorList[0];
        }else{
            return colorList[pcolor + 1];
        }
    }

    // 選択中のパズルの角度を取得
    public float getAngle(){
        return pangle;
    }
}

/** N角形描画クラス **/
class RegularPolygon{
    /*-- Field --*/
    private int qty;            // 角数
    private int size;           // 正N角形を含む最小の円の直径（正N角形の大きさ）
    private float angle;        // 正N角形の角度
    private Point center;       // 正N角形の描画中心座標

    /*-- Constractor --*/
    RegularPolygon(int qty, int size, float angle, Point center){
        this.qty = qty;
        this.size = size;
        this.angle = angle;
        this.center = center;
    }

    /*-- Draw --*/
    public void draw(){
        pushMatrix();
        translate(center.x, center.y);
        rotate(radians(-90 + angle));

        beginShape();
        for (int i = 0; i < qty; i++) {
        vertex((size / 2) * cos(radians(360 * i / qty)), (size / 2) * sin(radians(360 * i / qty)));
        }
        endShape(CLOSE);

        popMatrix();
    }

    /*-- Method --*/

    // 角度の変更
    public void changeAngle(float angle){
        this.angle = angle;
    }

    // 位置の変更
    public void changeCenter(Point center){
        this.center = center;
    }
}