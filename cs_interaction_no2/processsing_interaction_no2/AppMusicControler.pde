/******************************************
        Reconfigurable Interaction
        No.2
        2015 Seiya Iwasaki
******************************************/


/** アプリケーション：「ミュージックコントローラー」 **/
class AppMusicControler{
    /*-- Field --*/
    private Rectangle appField;         // アプリケーション描画用画面割り当て
    private Point fieldCenter;          // 画面中心位置
    private Minim minim;                // 音源ファイル読み込み
    private Playlist[] playlist;        // 保存されている楽曲のプレイリスト
    private AudioPlayer playingMusic;   // 再生中の音源
    private boolean activePlaying;      // 再生状態
    private int activeList;             // 選択中のプレイリストのインデックス
    private int activeMusic;            // 選択中の音源のインデックス
    private float musicVolume;          // 音量
    private PImage playImage;
    private PImage pauseImage;
    private PImage preImage;
    private PImage nextImage;

    /*-- Constractor --*/
    AppMusicControler(Minim minim){
        appField = new Rectangle(width / 3, 0, width / 3, height);
        fieldCenter = new Point(appField.x + appField.width / 2, appField.y + appField.height / 2);
        this.minim = minim;
        playlist = new Playlist[]{
            new Playlist("Chopin", new String[]{"Nocturne Op.9-2", "Raindrop", "Minute Waltz"}),
            new Playlist("Mozart", new String[]{"Symphony No.40 Mov1", "Divertimenti Mov1", "P.C. No.23 Mov2"}),
            new Playlist("Debussy", new String[]{"Menuet", "Prelude", "Clair de lune"})
        };
        activePlaying = true;
        activeList = 0;
        activeMusic = 0;
        musicVolume = 0;
        loadMusicFile();
        playMusic();
        playImage = loadImage("play.png");
        pauseImage = loadImage("pause.png");
        preImage = loadImage("pre.png");
        nextImage = loadImage("next.png");
        playImage.resize(60, 60);
        pauseImage.resize(60, 60);
        preImage.resize(60, 60);
        nextImage.resize(60, 60);
    }


    /*-- Draw --*/
    public void draw(){
        // draw music name and playlist name
        fill(#3c3c3c);
        textAlign(CENTER);
        textSize(22);
        text(playlist[activeList].getMusicName(activeMusic), fieldCenter.x, fieldCenter.y - 20);
        textSize(28);
        text(playlist[activeList].getPlaylistName(), fieldCenter.x, fieldCenter.y + 20);
        
        // draw playlist names
        fill(#3c3c3c);
        textSize(18);
        textAlign(CENTER);
        text(playlist[activeList].getPlaylistName() + " Musics", fieldCenter.x, fieldCenter.y - 100);
        fill(#aaaaaa);
        textAlign(RIGHT);
        if(activeList == 0) text(playlist[playlist.length - 1].getPlaylistName() + " Musics", fieldCenter.x + playImage.width * 4, fieldCenter.y - 100);
        else text(playlist[activeList - 1].getPlaylistName() + " Musics", fieldCenter.x + playImage.width * 4, fieldCenter.y - 100);
        textAlign(LEFT);
        if(activeList == playlist.length - 1) text(playlist[0].getPlaylistName() + " Musics", fieldCenter.x - playImage.width * 4, fieldCenter.y - 100);
        else text(playlist[activeList + 1].getPlaylistName() + " Musics", fieldCenter.x - playImage.width * 4, fieldCenter.y - 100);
        stroke(#888888);
        strokeWeight(1);
        line(fieldCenter.x - playImage.width * 4, fieldCenter.y - 90, fieldCenter.x + playImage.width * 4, fieldCenter.y - 90);
        noStroke();
        
        // draw UI Images
        imageMode(CENTER);
        if(playingMusic.isPlaying()){
            image(pauseImage, fieldCenter.x, fieldCenter.y + 100);
        }else{
            image(playImage, fieldCenter.x, fieldCenter.y + 100);
        }
        image(preImage, fieldCenter.x - playImage.width * 2, fieldCenter.y + 100);
        image(nextImage, fieldCenter.x + playImage.width * 2, fieldCenter.y + 100);
        textSize(14);
        textAlign(LEFT);
        text(playlist[activeList].getPreMusicName(activeMusic), fieldCenter.x - playImage.width * 2.5, fieldCenter.y + 100 + playImage.height * 0.6);
        textAlign(RIGHT);
        text(playlist[activeList].getNextMusicName(activeMusic), fieldCenter.x + playImage.width * 2.5, fieldCenter.y + 100 + playImage.height * 0.6);

        // draw Volume UI
        stroke(#888888);
        strokeWeight(1);
        line(fieldCenter.x + playImage.width * 4 - 20, fieldCenter.y - 90 + 50, fieldCenter.x + playImage.width * 4 - 20, fieldCenter.y + 100 + playImage.height * 0.6);
        stroke(#3c3c3c);
        strokeWeight(2);
        fill(#ffffff);
        ellipseMode(CENTER);
        int mapping = (int)map(musicVolume, 50, -50, fieldCenter.y - 90 + 50, fieldCenter.y + 100 + playImage.height * 0.6);
        ellipse(fieldCenter.x + playImage.width * 4 - 20, mapping, 10, 10);
        noStroke();
        fill(#3c3c3c);
        textSize(14);
        textAlign(CENTER);
        mapping = (int)map(musicVolume, -50, 50, 0, 100);
        text(mapping, fieldCenter.x + playImage.width * 4 - 20, fieldCenter.y - 90 + 50 - 10);
    }


    /*-- Method --*/

    // 選択中の音源ファイルを読み込む
    private void loadMusicFile(){
        playingMusic = minim.loadFile(playlist[activeList].getMusicFilePath(activeMusic));
        playingMusic.setGain(musicVolume);
    }

    // 音源の再生
    public void playMusic(){
        playingMusic.play();
        activePlaying = true;
    }

    // 音源の一時停止
    public void stopMusic(){
        playingMusic.pause();
        activePlaying = false;
    }

    // 再生の切替
    public void turnPlaying(){
        if(playingMusic.isPlaying()){
            playingMusic.pause();
            activePlaying = false;  
        }else{
            playingMusic.play();
            activePlaying = true;
        }
    }

    // プレイリストの変更
    public void changePlaylist(int direction){
        activeList += direction;
        if(activeList > playlist.length - 1){
            activeList = 0;
        }else if(activeList < 0){
            activeList = playlist.length - 1;
        }
        activeMusic = 0;
        playingMusic.close();
        loadMusicFile();
        if(activePlaying) playMusic();
    }

    // 音源の変更
    public void changeMusic(int direction){
        activeMusic += direction;
        if(activeMusic > playlist[activeList].getPlaylistLength() - 1){
            activeMusic = 0;
        }else if(activeMusic < 0){
            activeMusic = playlist[activeList].getPlaylistLength() - 1;
        }
        playingMusic.close();
        loadMusicFile();
        if(activePlaying) playMusic();
    }


    // 音量の変更
    public void changeVolume(int direction){
        musicVolume += direction;
        if(musicVolume > 50) musicVolume = 50;
        else if(musicVolume < -50) musicVolume = -50;
        playingMusic.setGain(musicVolume);
    }

    // アプリケーション終了処理
    public void stop(){
        playingMusic.close();
        minim.stop();
    }
}

class Playlist{
    /*-- Field --*/
    private String listName;
    private String[] playlist;

    /*-- Constractor --*/
    Playlist(String name, String[] musics){
        listName = name;
        playlist = musics;
    }

    /*-- Method --*/

    // プレイリスト名の取得
    public String getPlaylistName(){
        return listName;
    }

    // プレイリストの長さを取得
    public int getPlaylistLength(){
        return playlist.length;
    }

    // 曲名の取得
    public String getMusicName(int index){
        return playlist[index];
    }
    public String getPreMusicName(int index){
        if(index == 0) return playlist[playlist.length - 1];
        else return playlist[index - 1];
    }
    public String getNextMusicName(int index){
        if(index == playlist.length - 1) return playlist[0];
        else return playlist[index + 1];
    }
    public String getMusicFilePath(int index){
        return listName + "\\" + playlist[index] + ".mp3";
    }
}