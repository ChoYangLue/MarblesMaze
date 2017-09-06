# MarblesMaze

# 概要
今回はビー玉迷路（アプリケーション名；Marbles Maze）を作成した。swift3.0
また、下記の機能を実装または利用した。

* 加速度センサーでビー玉を操作
* SpriteKitを使用
* 制限時間内にゴールに到達するとクリア
* 迷路を自動生成（ランダム生成）
* viewを三つに分ける

# 実装
ランダムな迷路の作成方法にはいろいろあるが、今回は棒倒し法を採用した。
二次元配列によって迷路を生成する。また、それぞれの要素には
* 何もないところは０
* 柱があるところは１
* 水平な壁があるところは２
* 垂直な壁があるところは３
* ゴールがあるところは４
* 穴があるところは５
* アイテムがあるところは６
を代入する。

# 問題と解決
迷路を作成する際、配列のとおりに地面と柱と壁を配置した場合、ノードの数が２４０以上になり、加速度センサーの値の取得が急激に遅くなった。そこで地面は一枚だけ背景として描画して、柱と壁だけの表示とした。これだけでもかなりのノード数削減になった。棒倒し法を採用しているゲームで有名なドルアーガの塔を観察してみると壁を柱の長さの二倍にして、ノード数の削減していることに気付いた。これを参考にして、さらなるノード数の削減に成功した。加速度センサーの値がうまく取れなくなるのは
manager.accelerometerUpdateInterval = 0.01
の部分だったようである。上記の値は加速度センサーから値をとってくる間隔なのだが、短くするとCPUがビジーになるようだ。今回は0.1に設定。

Spritekitの当たり判定は基本的にBitMaskを使い、面倒な座標計算をしなくてよい。BitMaskとは二進数のビット列をシフトしてビット演算子“｜”（和）を使ってパターンを判別（当たったかどうか）している。didBeginContactメソッドで何が何に衝突したかなどの情報を受け取ることができる。注意すべきなのはGameSceneクラスにSKPhysicsContactDelegateの記述を追加しないとdidBeginContactメソッドでデリゲートを受け取ることができない。SKPhysicsContactDelegateの記述を追加しなくても跳ね返り処理ができてしまうのでdidBeginContactメソッドでデリゲートが受け取れない原因がわからず苦戦した。


# 参考文献
当たり判定
https://www.raywenderlich.com/119815/sprite-kit-swift-2-tutorial-for-beginners

効果音
http://musmus.main.jp/se.html
http://kappa-game.hatenadiary.jp/entry/2015/10/14/swift_spritekit_で音楽を鳴らす

画面遷移
http://qiita.com/mochizukikotaro/items/e188ec14a2428491dd84
http://karamawariken.net/blog/2016/04/07/iosswiftspritekitでゲームのスタート画面を作る/

アイコン
http://swift-bettychang.hatenadiary.jp/entry/2016/01/05/185303
http://qiita.com/Yutako/items/d4beacc0144363f59eae

回転
https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/spritekit/021-zhi-dingshita-hui-zhuan-zhimade-hui-zhuansaseruakushonwo-zuoru
http://spritekit.senchan-office.com/index.php/sknode

アイテムの削除
https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/spritekit/007-qinnodekara-te-dingnonodewo-xue-chu

ラベル
https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/spritekit/002-wen-zi-liewo-

ゲームデザイン
Nomco ドルアーガの塔
