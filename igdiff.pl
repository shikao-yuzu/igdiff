=head1 SCRIPT NAME

igdiff.pl

=head1 DESCRIPTION

特定の文字列を含む行を無視し, 2つのファイルの差分を計算する

=head1 USAGE

perl igdiff.pl input_file1 input_file2 [ignore_file]

[ignore_file]には改行区切りで差分計算時に無視する文字列を指定する.
[ignore_file]では半角スペースは無視され, 先頭が#の行はコメント行になる.
なお, [ignore_file]を指定しない場合は通常の差分計算になる.

=cut
use strict;
use warnings;
use Text::Diff 'diff';

my @files       = parse_arguments();
my @ignore_list = set_ignore_list( @files );
my @buff        = remove_ignore_line( \@files, \@ignore_list );
my $diff        = diff( \$buff[0], \$buff[1], { STYLE => "Context" }, { CONTEXT => 3 } );

echo_diff_result( $diff, @files );

exit(0);


sub parse_arguments
{
  use Pod::Usage 'pod2usage';

  my $argc = @ARGV;

  if ( $argc == 2 || $argc == 3 )
  {
    return @ARGV;
  }
  else
  {
    pod2usage();
  }
}


sub set_ignore_list
{
  my @files = @_;

  return () if ( $#files != 2 );

  my $ignore_file = $files[2];
  my @ignore_list = ();

  open( my $fh, '<', $ignore_file ) or die ( "Can't open file $ignore_file : $!" );
  while( my $line = <$fh> )
  {
#   行先頭文字が"#"はコメント行
    next if ( substr( $line, 0, 1 ) eq "#" );

#   末尾の改行文字と空白を削除
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

    open( my $fh, '<', $file ) or die ( "Can't open file $file : $!" );
    while( my $line = <$fh> )
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
    print $diff;
  }
  else
  {
    print "***************\n";
    print "ファイル $files[0] とファイル $files[1] の相違点は検出されませんでした\n";
    print "***************\n";
  }
}


sub my_trim
{
  my $str = \shift;
  $$str =~ s/\A\s*(.*?)\s*\z/$1/;
  return $$str;
}
