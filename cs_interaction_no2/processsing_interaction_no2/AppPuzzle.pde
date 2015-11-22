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
    private int puzzleSize;             // パズルの大きさ
    private int interval;               // パズル同士の間隔
    private Rectangle appField;         // アプリケーション描画用画面割り当て
    private Point fieldCenter;          // 画面中心位置
    private Point[] endPosition;        // 左右上下の端の座標 
    private PImage whiteout;            // 非選択中のパズルをホワイトアウトするためのマスク
    private RegularPolygon[] polygons;  // 多角形描画用クラス配列
    private boolean playingAnimation;   // アニメーション再生中かどうか
    private int animationID;            // アニメーションの種類
    private int fps;                    // フレームレート
    private int animationCounter;       // アニメーション再生用カウンター
    private int animationDirection;     // アニメーションの方向


    /*-- Constractor --*/
    AppPuzzle(int fps){
        puzzleSize = 140;
        interval = 40;
        appField = new Rectangle(0, 0, width / 3, height);
        fieldCenter = new Point(appField.x + appField.width / 2, appField.y + appField.height / 2);
        endPosition = new Point[]{new Point(fieldCenter.x - (puzzleSize + interval), fieldCenter.y),
                                  new Point(fieldCenter.x + (puzzleSize + interval), fieldCenter.y),
                                  new Point(fieldCenter.x, fieldCenter.y - (puzzleSize + interval)),
                                  new Point(fieldCenter.x, fieldCenter.y + (puzzleSize + interval))};
        whiteout = loadImage("whiteout.png");
        whiteout.resize(appField.width, whiteout.height);
        polygons = new RegularPolygon[]{new RegularPolygon(0, puzzleSize, 0, fieldCenter),
                                        new RegularPolygon(3, puzzleSize, 0, fieldCenter),
                                        new RegularPolygon(4, puzzleSize, 0, fieldCenter),
                                        new RegularPolygon(5, puzzleSize, 0, fieldCenter)};
        playingAnimation = false;
        this.fps = fps;
        animationCounter = 0;
    }


    /*-- Draw --*/
    public void draw(){
        if(playingAnimation){
            if(animationID == 1){
                drawChangeColorAnimation();
            }else if(animationID == 2){
                drawChangePolygonAnimation();
            }
        }else{
            // プレイヤーパズルの描画
            super.draw(fieldCenter, polygons[getPVertex()]);

            // 非選択色のパズルを描画
            fill(getPreColor());
            polygons[getPVertex()].changeAngle(0);
            polygons[getPVertex()].changeCenter(endPosition[0]);
            polygons[getPVertex()].draw();
            fill(getNextColor());
            polygons[getPVertex()].changeCenter(endPosition[1]);
            polygons[getPVertex()].draw();

            // 非選択角数のパズルを描画
            fill(#3c3c3c);
            polygons[getPrePVertex()].changeAngle(0);
            polygons[getPrePVertex()].changeCenter(endPosition[2]);
            polygons[getPrePVertex()].draw();
            polygons[getNextPVertex()].changeAngle(0);
            polygons[getNextPVertex()].changeCenter(endPosition[3]);
            polygons[getNextPVertex()].draw();
        }

        // マスクの描画
        imageMode(CENTER);
        image(whiteout, fieldCenter.x, fieldCenter.y);
    }
    private void drawChangeColorAnimation(){
        float mapping = float(animationCounter) / (fps / 5.0);

        if(animationDirection > 0){
            fill(getPreColor());
            polygons[getPVertex()].changeAngle(0);
            polygons[getPVertex()].changeCenter(new Point(int((interval + puzzleSize) * mapping) - (interval + puzzleSize) + puzzleSize / 2 + 10, fieldCenter.y));
            polygons[getPVertex()].draw();

            fill(getColor());
            polygons[getPVertex()].changeAngle(0);
            polygons[getPVertex()].changeCenter(new Point(int((interval + puzzleSize) * mapping) + puzzleSize / 2 + 10, fieldCenter.y));
            polygons[getPVertex()].draw();

            fill(getNextColor());
            polygons[getPVertex()].changeAngle(0);
            polygons[getPVertex()].changeCenter(new Point(int((interval + puzzleSize) * mapping) + (interval + puzzleSize) + puzzleSize / 2 + 10, fieldCenter.y));
            polygons[getPVertex()].draw();

            if(mapping <= 0.5){
                fill(getDoubleNextColor());
                polygons[getPVertex()].changeAngle(0);
                polygons[getPVertex()].changeCenter(new Point(int((interval + puzzleSize) * mapping) + (interval + puzzleSize) * 2 + puzzleSize / 2 + 10, fieldCenter.y));
                polygons[getPVertex()].draw();
                fill(#ffffff);
                rectMode(CENTER);
                rect(appField.width + puzzleSize / 2, fieldCenter.y, puzzleSize, puzzleSize);
            }
        }else{
            mapping *= -1;

            fill(getDoublePreColor());
            polygons[getPVertex()].changeAngle(0);
            polygons[getPVertex()].changeCenter(new Point(int((interval + puzzleSize) * mapping) + puzzleSize / 2 + 10, fieldCenter.y));
            polygons[getPVertex()].draw();

            fill(getPreColor());
            polygons[getPVertex()].changeAngle(0);
            polygons[getPVertex()].changeCenter(new Point(int((interval + puzzleSize) * mapping) + (interval + puzzleSize) + puzzleSize / 2 + 10, fieldCenter.y));
            polygons[getPVertex()].draw();

            fill(getColor());
            polygons[getPVertex()].changeAngle(0);
            polygons[getPVertex()].changeCenter(new Point(int((interval + puzzleSize) * mapping) + (interval + puzzleSize) * 2 + puzzleSize / 2 + 10, fieldCenter.y));
            polygons[getPVertex()].draw();

            if(mapping <= -0.5){
                fill(getNextColor());
                polygons[getPVertex()].changeAngle(0);
                polygons[getPVertex()].changeCenter(new Point(int((interval + puzzleSize) * mapping) + (interval + puzzleSize) * 3 + puzzleSize / 2 + 10, fieldCenter.y));
                polygons[getPVertex()].draw();
                fill(#ffffff);
                rectMode(CENTER);
                rect(appField.width + puzzleSize / 2, fieldCenter.y, puzzleSize, puzzleSize);
            }
        }
        
        // 非選択角数のパズルを描画
        fill(#3c3c3c);
        polygons[getPrePVertex()].changeAngle(0);
        polygons[getPrePVertex()].changeCenter(endPosition[2]);
        polygons[getPrePVertex()].draw();
        polygons[getNextPVertex()].changeAngle(0);
        polygons[getNextPVertex()].changeCenter(endPosition[3]);
        polygons[getNextPVertex()].draw();

        updateFrameCount();
    }
    private void drawChangePolygonAnimation(){
        float mapping = float(animationCounter) / (fps / 5.0);

        fill(#3c3c3c);
        if(animationDirection > 0){
            mapping *= -1;

            polygons[getPrePVertex()].changeAngle(0);
            polygons[getPrePVertex()].changeCenter(new Point(fieldCenter.x, int((interval + puzzleSize) * mapping) + (interval + puzzleSize) + height / 2 - (puzzleSize + interval)));
            polygons[getPrePVertex()].draw();

            polygons[getPVertex()].changeAngle(0);
            polygons[getPVertex()].changeCenter(new Point(fieldCenter.x, int((interval + puzzleSize) * mapping) + (interval + puzzleSize) * 2 + height / 2 - (puzzleSize + interval)));
            polygons[getPVertex()].draw();

            if(mapping <= -0.5){
                polygons[getNextPVertex()].changeAngle(0);
                polygons[getNextPVertex()].changeCenter(new Point(fieldCenter.x, int((interval + puzzleSize) * mapping) + (interval + puzzleSize) * 3 + height / 2 - (puzzleSize + interval)));
                polygons[getNextPVertex()].draw();
                fill(#ffffff);
                rectMode(CENTER);
                rect(fieldCenter.x, fieldCenter.y + (puzzleSize + interval) * 1.75, puzzleSize, puzzleSize);
            }else{
                polygons[getDoublePrePVertex()].changeAngle(0);
                polygons[getDoublePrePVertex()].changeCenter(new Point(fieldCenter.x, int((interval + puzzleSize) * mapping) + height / 2 - (puzzleSize + interval)));
                polygons[getDoublePrePVertex()].draw();
                fill(#ffffff);
                rectMode(CENTER);
                rect(fieldCenter.x, fieldCenter.y - (puzzleSize + interval) * 1.5, puzzleSize, puzzleSize);
            }
        }else{

            polygons[getPVertex()].changeAngle(0);
            polygons[getPVertex()].changeCenter(new Point(fieldCenter.x, int((interval + puzzleSize) * mapping) + height / 2 - (puzzleSize + interval)));
            polygons[getPVertex()].draw();

            polygons[getNextPVertex()].changeAngle(0);
            polygons[getNextPVertex()].changeCenter(new Point(fieldCenter.x, int((interval + puzzleSize) * mapping) + (interval + puzzleSize) + height / 2 - (puzzleSize + interval)));
            polygons[getNextPVertex()].draw();

            if(mapping <= 0.5){
                polygons[getDoublePrePVertex()].changeAngle(0);
                polygons[getDoublePrePVertex()].changeCenter(new Point(fieldCenter.x, int((interval + puzzleSize) * mapping) + (interval + puzzleSize) * 2 + height / 2 - (puzzleSize + interval)));
                polygons[getDoublePrePVertex()].draw();
                fill(#ffffff);
                rectMode(CENTER);
                rect(fieldCenter.x, fieldCenter.y + (puzzleSize + interval) * 1.75, puzzleSize, puzzleSize);
            }else{
                polygons[getPrePVertex()].changeAngle(0);
                polygons[getPrePVertex()].changeCenter(new Point(fieldCenter.x, int((interval + puzzleSize) * mapping) - (interval + puzzleSize) + height / 2 - (puzzleSize + interval)));
                polygons[getPrePVertex()].draw();
                fill(#ffffff);
                rectMode(CENTER);
                rect(fieldCenter.x, fieldCenter.y - (puzzleSize + interval) * 1.5, puzzleSize, puzzleSize);
            }
        }
        
        // 非選択色のパズルを描画
        fill(getPreColor());
        polygons[getPVertex()].changeAngle(0);
        polygons[getPVertex()].changeCenter(endPosition[0]);
        polygons[getPVertex()].draw();
        fill(getNextColor());
        polygons[getPVertex()].changeCenter(endPosition[1]);
        polygons[getPVertex()].draw();

        updateFrameCount();
    }


    /*-- Method --*/

    // アニメーションの再生
    public void playAnimation(int id, int direction){
        playingAnimation = true;
        animationID = id;
        animationDirection = direction;
    }

    // アニメーションの停止
    private void stopAnimation(){
        playingAnimation = false;
        animationCounter = 0;
    }

    // アニメーション用フレームカウントの更新
    private void updateFrameCount(){
        animationCounter++;
        if(animationCounter > (fps / 5.0)) stopAnimation();
    }
    
    // アニメーション再生中かどうか
    public boolean playingAnimation(){
        return playingAnimation;
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
    public int getPVertex(){
        return pvertex;
    }
    public int getPrePVertex(){
        if(pvertex == 0){
            return vertexList.length - 1;
        }else{
            return pvertex - 1;
        }
    }
    public int getDoublePrePVertex(){
        if(pvertex < 2){
            return vertexList.length - 2 + pvertex;
        }else{
            return pvertex - 2;
        }
    }
    public int getTriplePrePVertex(){
        if(pvertex < 3){
            return vertexList.length - 3 + pvertex;
        }else{
            return pvertex - 3;
        }
    }
    public int getNextPVertex(){
        if(pvertex == vertexList.length - 1){
            return 0;
        }else{
            return pvertex + 1;
        }
    }
    public color getDoubleNextPVertex(){
        if(pvertex > vertexList.length - 3){
            return abs(vertexList.length - 2 - pvertex);
        }else{
            return pvertex + 2;
        }
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
    public color getDoublePreColor(){
        if(pcolor < 2){
            return colorList[colorList.length - 2 + pcolor];
        }else{
            return colorList[pcolor - 2];
        }
    }
    public color getTriplePreColor(){
        if(pcolor < 3){
            return colorList[colorList.length - 3 + pcolor];
        }else{
            return colorList[pcolor - 3];
        }
    }
    public color getNextColor(){
        if(pcolor == colorList.length - 1){
            return colorList[0];
        }else{
            return colorList[pcolor + 1];
        }
    }
    public color getDoubleNextColor(){
        if(pcolor > colorList.length - 3){
            return colorList[abs(colorList.length - 2 - pcolor)];
        }else{
            return colorList[pcolor + 2];
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
        if(qty == 0){
            ellipseMode(CENTER);
            ellipse(center.x, center.y, size, size);
        }else{
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