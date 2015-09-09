Vine MV
====

曲名を入力すると、Vineの動画を使ったミュージックビデオを自動生成するWebアプリケーションです。

Vine MV is a web application which automatically generates a music video using the Vine APIs
from the music title you type.

## Demo
Herokuで確認できます。

You can try out this app on Heroku.

+ <https://vinemv.herokuapp.com/>

## Requirements
アプリケーションは以下の環境での動作確認を行いました。

I've tested this app on the following environment.  This app may work
on the other environment, but I do not support the other setting.

+ Ruby 2.2.2p95
+ Sinatra 1.4.6

## Installation
    $ git clone https://github.com/ikeay/vinemv.git
    $ cd vinemv
    $ edit keys in class/extract.rb (see below).
    $ bundle install

class/extract.rbに書かれている鍵情報``YOUR_CLIENT_ID``, ``YOUR_CLIENT_SECRET``, ``AZURE_ACCOUNT_KEY``を書き換える必要があります。

Note that in class/extract.rb, you need to change the values of the
keys properly: ``YOUR_CLIENT_ID``, ``YOUR_CLIENT_SECRET``, ``AZURE_ACCOUNT_KEY``.

## Usage
    $ ruby main.rb
このアプリケーションがどのような挙動をするのかは[こちら](http://blog.ikeay.net/559)のブログで説明しています。

[This blog post (written in Japanese)](http://blog.ikeay.net/559) explains how it works.

## Author
[ikeay](https://github.com/ikeay)

## Copyright
Copyright © 2015 Ayaka Ikezawa. This software is released under the MIT License, see LICENSE.txt.