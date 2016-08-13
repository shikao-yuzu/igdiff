# igdiff

## Description
特定の文字列を含む行を無視し, 2つのファイルの差分を計算する

## Usage
perl igdiff.pl input_file1 input_file2 [ignore_file]

[ignore_file]には改行区切りで差分計算時に無視する文字列を指定する.
[ignore_file]では半角スペースは無視され, 先頭が#の行はコメント行になる.
なお, [ignore_file]を指定しない場合は通常の差分計算になる.

### example

[ignore_file]の内容が以下の場合、

         hoge
    # fuga
    piyo    
      てすと

"hoge", "piyo", "てすと"が含まれる行が差分計算時に無視される.

