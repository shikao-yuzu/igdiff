=head1 SCRIPT NAME

igdiff.pl

=head1 DESCRIPTION

特定の文字列を含む行を無視して, 2つのファイルの差分を計算する.
日本語による入出力はShift_JISに対応している.

=head1 USAGE

perl igdiff.pl input_file1 input_file2 [ignore_file]

[ignore_file]には改行区切りで差分計算時に無視する文字列を指定する.
[ignore_file]では半角スペースは無視され, 先頭が"#"の行はコメントと
して行全体が無視される.
なお, [ignore_file]を指定しない場合は通常の差分計算になる.

=cut
use strict;
use warnings;
use utf8;
use Encode qw/ decode encode /;
use Text::Diff 'diff';

my @files       = parse_arguments();
my @ignore_list = set_ignore_list( @files );
my @buff        = remove_ignore_line( \@files, \@ignore_list );
my $diff        = diff( \$buff[0], \$buff[1], { STYLE => "Context" }, { CONTEXT => 3 } );

echo_diff_result( $diff, @files );
exit(0);


sub parse_arguments
{
  my $argc  = @ARGV;
  my @files = ();

  if ( $argc == 2 || $argc == 3 )
  {
    foreach my $str ( @ARGV )
    {
       push( @files, decode( 'Shift_JIS', $str ) );
    }
    return @files;
  }
  else
  {
    my $msg = "Usage:\n"
            . "    perl  igdiff.pl  input_file1  input_file2  [ignore_file]\n\n"
            . "[ignore_file]には改行区切りで差分計算時に無視する文字列を指定する.\n"
            . "[ignore_file]では半角スペースは無視され, 先頭が\"#\"の行はコメントと\n"
            . "して行全体が無視される.\n"
            . "なお, [ignore_file]を指定しない場合は通常の差分計算になる.\n";
    print encode( 'Shift_JIS', $msg );
    exit(1);
  }
}


sub set_ignore_list
{
  my @files = @_;

  # 無視ファイルが指定されていない場合
  return () if ( $#files != 2 );

  my $ignore_file = encode( 'Shift_JIS', $files[2] );
  my @ignore_list = ();

  open( my $fh, '<', $ignore_file ) or die ( "Can't open file $ignore_file : $!" );
  while( my $line = decode( 'Shift_JIS', <$fh> ) )
  {
    # 行先頭文字が"#"の場合はコメント行として無視
    next if ( substr( $line, 0, 1 ) eq "#" );

    # 末尾の改行文字と先頭・末尾の空白を削除
    chomp( $line );
    my_trim( $line );

    push( @ignore_list, $line );
  }
  close( $fh );

  return @ignore_list;
}


sub remove_ignore_line
{
  my ( $files, $ignore_list ) = @_;

  my @buff = ();
  foreach my $file ( @$files )
  {
    my $tmp = "";

    open( my $fh, '<', encode( 'Shift_JIS', $file ) ) or die ( "Can't open file $file : $!" );
    while( my $line = decode( 'Shift_JIS', <$fh> ) )
    {
      foreach my $ig ( @$ignore_list )
      {
        $line = "" if ( $line =~ /$ig/ );
      }
      $tmp .= $line;
    }
    close( $fh );

    push( @buff, $tmp );
  }

  return @buff;
}


sub echo_diff_result
{
  my ( $diff, @files ) = @_;

  if ( length( $diff ) )
  {
    print encode( 'Shift_JIS', $diff );
  }
  else
  {
    my $msg = "ファイル $files[0] とファイル $files[1] の相違点は検出されませんでした\n";
    print encode( 'Shift_JIS', $msg );
  }
}


sub my_trim
{
  my $str = \shift;
  $$str =~ s/^\s*(.*?)\s*$/$1/;
  return $$str;
}
