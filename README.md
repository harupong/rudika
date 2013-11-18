# rudika

**rudika** は [radiko.jp](http://radiko.jp/) や [らじる★らじる　NHKネットラジオ](http://www3.nhk.or.jp/netradio/) を録音するための Ruby アプリケーションです。radiko やらじる★らじるの公式番組表にもとづく録音の自動停止、crontab と連動した確実な予約録音など便利な機能を備えています。

初めて自力で書いた Ruby アプリケーションなので動作は完全無保証です。ツッコミ大歓迎。

## インストール

**rudika** の実行には Ruby、Bundler、ffmpeg が必要です。インストールされていない場合は、パッケージ管理ツールを使ってインストールしておきましょう。

次に、以下のコマンドを順に実行します。

    git clone https://github.com/harupong/rudika.git
    cd rudika
    bundle install

`bundle exec rudika` でヘルプが表示されれば、**rudika** のインストールは完了です。

## 使い方

現在配信中のラジオを録音するには

    $ bundle exec rudika rec -s <ラジオ局の略称>

を実行します。録音は自動で停止し、MP3 ファイルが `~/Music/Radiko` か `~/Music/Radiru` に保存されます。録音を強制停止したい場合は、`ctrl-c` で止めてください。

ラジオ局の略称が分からない場合は、

    $ bundle exec rudika list | grep <ラジオ局名の一部>

と実行して目当ての略称を確認しましょう。

### 録音を予約するには

**rudika** は crontab と連動した録音予約機能を備えています。

    $ bundle exec rudika schedule -a

を実行すると録音予約メニューが出てきますので、ラジオ局や日時を入力してください。crontab への追加は自動で処理されます。登録した予約を削除したければ

    $ bundle exec rudika schedule -d

で削除メニューを呼び出しましょう。また、

    $ bundle exec rudika schedule

とオプションなしで schedule サブコマンドを呼び出せば、現在登録されている録音予約が一覧表示されます。

## よもやま話

TO BE FILLED...

## クレジット

TO BE FILLED...

---------------------
(in English)

# rudika

rudika lets you record radiko.jp/NHK radio streaming.  You can schedule the recording as well.  It is written in Ruby.

## Installation

First, install rudika and dependencies using bundler.

    git clone https://github.com/harupong/rudika.git
    cd rudika
    bundle install

Then, `which ffmpeg` to make sure ffmpeg executable is placed in $PATH. If not, please install it.

## How To Use

Go into the directory you cloned rudika repo, then `bundle exec rudika` to see the help.

There commands are available:

- rudika list       # lists all radio stations rudika can record
- rudika rec        # starts recording the station. recording stops automatically according to the broadcasting schedule.
- rudika schedule   # stores/deletes recording schedule into crontab

Currently, recordings are stored in either `~/Music/Radiko` or `~/Music/Radiru` based on which stations, radiko.jp or NHK radio, the stream is from.
