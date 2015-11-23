/******************************************
        Reconfigurable Interaction
        No.2
        2015 Seiya Iwasaki
******************************************/


/** アプリケーション：「エアコンの管理」（管理者とユーザによる可能操作の差異） **/
class AppManageAirCon extends AirCon {
    /*-- Field --*/
    private Rectangle appField;         // アプリケーション描画用画面割り当て
    private Point fieldCenter;          // 画面中心位置


    /*-- Constractor --*/
    AppManageAirCon(){
        appField = new Rectangle(width / 3 * 2, 0, width / 3, height);
        fieldCenter = new Point(appField.x + appField.width / 2, appField.y + appField.height / 2);

    }


    /*-- Draw --*/
    public void draw(){
        super.draw(fieldCenter, 400);
    }


    /*-- Method --*/
}

class AirCon {
    /*-- Field --*/
    private boolean power;
    private float userTemp;
    private int maxTemp, minTemp, userMode;
    private String[] modeList = new String[]{"Cooler", "Heater", "Dryer", "ventilator"};
    private color[] modeColor = new color[]{#4CE1FF, #FF6A4C, #CCB43D ,#88FF4C};


    /*-- Constractor --*/
    AirCon(){
        power = true;
        maxTemp = 32;
        minTemp = 18;
        userTemp = 27.0;
        userMode = 0;
    }


    /*-- Draw --*/
    public void draw(Point center, int size){
        // draw mode color circle
        if(power) fill(getModeColor());
        else fill(#aaaaaa);
        ellipseMode(CENTER);
        ellipse(center.x, center.y, size, size);
        fill(#ffffff);
        ellipse(center.x, center.y, size - 15, size - 15);
        // draw mode name and power status
        fill(#3c3c3c);
        textSize(32);
        textAlign(CENTER);
        text(getMode() + "\n" + getPowerStatusStr(), center.x, center.y);
        // draw setting temperature
        if(userMode < 2){
            text(str(floor(userTemp)) + "°C", center.x, center.y - (size / 2 - 50));
            stroke(#C34CFF);
            strokeWeight(2);
            float mapping = (userTemp - minTemp) / (float)(maxTemp - minTemp);
            mapping = 1 - mapping;
            for(int i = 420; i >= 120 + 300 * mapping; i -= 20){
                line((size / 2 - 25) * cos(radians(i)) + center.x,
                     (size / 2 - 25) * sin(-radians(i)) + center.y,
                     (size / 2 - 15) * cos(radians(i)) + center.x,
                     (size / 2 - 15) * sin(-radians(i)) + center.y);
            }
            noStroke();
        }
        // draw other mode color line
        rectMode(CENTER);
        fill(getNextModeColor());
        rect(center.x - size / 2 - 50, center.y, 10, size / 2);
        fill(getPreModeColor());
        rect(center.x + size / 2 + 50, center.y, 10, size / 2);
    }


    /*-- Method --*/

    // エアコンの電源をオン
    public void onPower(){
        power = true;
    }
    
    // エアコンの電源をオフ
    public void offPower(){
        power = false;
    }

    // エアコンの電源を切替
    public void changePower(){
        if(power) power = false;
        else power = true;
    }

    // エアコンの設定温度を変更
    public void addTemp(int val){
        userTemp += val / 5.0;
        if(userTemp > maxTemp) userTemp = maxTemp;
        else if(userTemp < minTemp) userTemp = minTemp;
    }
    public void changeTemp(int val){
        userTemp = val;
        if(userTemp > maxTemp) userTemp = maxTemp;
        else if(userTemp < minTemp) userTemp = minTemp;
    }

    // エアコンのモード変更
    public void changeMode(int direction){
        userMode += direction;
        if(userMode < 0) userMode = modeList.length - 1;
        else if(userMode > modeList.length - 1) userMode = 0;
    }

    // エアコンの電源の状態を取得
    public boolean getPowerStatus(){
        return power;
    }
    public String getPowerStatusStr(){
        if(power) return "ON";
        else return "OFF";
    }

    // エアコンの現在の設定温度を取得
    public float getUserTemp(){
        return userTemp;
    }

    // エアコンの現在のモードを取得
    public String getMode(){
        return modeList[userMode];
    }
    public color getModeColor(){
        return modeColor[userMode];
    }
    public color getPreModeColor(){
        if(userMode == 0) return modeColor[modeColor.length - 1];
        else return modeColor[userMode - 1];
    }
    public color getNextModeColor(){
        if(userMode == modeColor.length - 1) return modeColor[0];
        else return modeColor[userMode + 1];
    }

}