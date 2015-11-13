/******************************************
		Reconfigurable Interaction
		No.2
		2015 Seiya Iwasaki
******************************************/

import processing.serial.*;

Serial port;

/*
* 構成位置の数は Arduino 側のプログラムと
* Processing 側のプログラムで一致させる必要がある
*/
final int fps = 60;
final int position_qty = 1;										// 構成位置の数（着脱位置の数）
long capVal[][] = new long[position_qty][4];					// 静電容量の測定値
OperationDetect opeDet[] = new OperationDetect[position_qty];	// 操作検出クラス
int count = 0;

int operationID = 0;
final String operationName[] = new String[]{"Nothing", "Touch", "LeftRight Slide", "UpDown Slide", "Wheel"};


void setup(){
    /*--- Arduino 設定 ---*/
  
    // シリアルポートの設定
  	println(Serial.list());                // シリアルポート一覧
   	String portName = Serial.list()[2];    // Arduinoと接続しているシリアルを選択
   	port = new Serial(this, portName, 9600);  
   

   	/*--- 操作検出クラス初期化 & リスナー登録 ---*/
   	for(int i = 0; i < position_qty; i++){
   		opeDet[i] = new OperationDetect(100, 30, fps);
   	}
    setListeners();


    /*--- アプリケーション設定 ---*/

    // 画面設定
    size(500, 500);
    noStroke();
    noCursor();
    smooth();
    frameRate(fps);
    imageMode(CENTER);
    colorMode(RGB, 256, 256, 256, 256);
}


void draw(){
    background(#ffffff);

	textSize(64);
        textAlign(CENTER);
	fill(#2c2c2c);
	text(operationName[operationID], width / 2, height / 2);
	text(int(opeDet[0].getOperateDirection()), width / 2, height / 2 + 60);
    text(int(capVal[0][0] + capVal[0][1] + capVal[0][2] + capVal[0][3]), width / 2, height / 2 + 120);

	// DEBUG
    textSize(18);
    text(count, 40, 40);
    
    float size[] = new float[4];
    size[0] = map(opeDet[0].getCapValue()[0], 0, 500, 0, 200);
    size[1] = map(opeDet[0].getCapValue()[1], 0, 500, 0, 200);
    size[2] = map(opeDet[0].getCapValue()[2], 0, 500, 0, 200);
    size[3] = map(opeDet[0].getCapValue()[3], 0, 500, 0, 200);
    fill(#ff5555);
    ellipse(width / 3, height / 3, size[0], size[0]);
    fill(#55ff55);
    ellipse(width / 3 * 2, height / 3, size[1], size[1]);
    fill(#5555ff);
    ellipse(width / 3, height / 3 * 2, size[2], size[2]);
    fill(#bbbbbb);
    ellipse(width / 3 * 2, height / 3 * 2, size[3], size[3]);
    
    fill(#2c2c2c);
    text(opeDet[0].getCapValue()[0], width / 3, height / 3);
    text(opeDet[0].getCapValue()[1], width / 3 * 2, height / 3);
    text(opeDet[0].getCapValue()[2], width / 3, height / 3 * 2);
    text(opeDet[0].getCapValue()[3], width / 3 * 2, height / 3 * 2);


    textAlign(LEFT);
	fill(#2cee2c);
	text("fps = " + (int)frameRate, width - 100, 40);

    
}


/*-- 静電容量の測定値を入力し，ユーザのアクションを検出 --*/
void detectAction(){
	for(int i = 0; i < position_qty; i++){
		opeDet[i].inputCapValue(capVal[i]);
	}
        // 各構成位置のアクションを検出
        for(int i = 0; i < position_qty; i++){
            opeDet[i].operationDetect();
        }
}


/*-- シリアル通信 --*/
void serialEvent(Serial p){
    try{
        // 改行区切りでデータを読み込む (¥n == 10)
        String inString = p.readStringUntil(10);
        
        // カンマ区切りのデータの文字列をパースして数値として読み込む
        if(inString != null){
            inString = trim(inString);
            int[] value = int(split(inString, ','));

            if(value.length >= position_qty * 4){
            	for(int i = 0; i < position_qty; i++){
            		capVal[i][0] = value[i * 4];
            		capVal[i][1] = value[i * 4 + 1];
            		capVal[i][2] = value[i * 4 + 2];
            		capVal[i][3] = value[i * 4 + 3];
            	}
            }
        }
    }catch(RuntimeException e){
        e.printStackTrace();
    }
    detectAction();
}


/*-- リスナー登録（匿名クラス） --*/
void setListeners(){
    // 構成位置 No.1
    if(position_qty > 0){
        opeDet[0].setOnActionListener(new OnActionListener(){
            @Override // タッチ
            public void onTouch(int direction){
                println("touch Action");
                operationID = 1;
                if(direction >= 0) count++;
                else count--;
            }

            @Override // 左右スライド
            public void onLRSwipe(int direction){
                operationID = 2;
                if(direction >= 0) count++;
                else count--;
            }

            @Override // 上下スライド
            public void onUDSwipe(int direction){
                operationID = 3;
                if(direction >= 0) count++;
                else count--;
            }

            @Override // ホイール
            public void onWheel(int direction){
                operationID = 4;
                if(direction >= 0) count++;
                else count--;
            }
        });
    }
}
