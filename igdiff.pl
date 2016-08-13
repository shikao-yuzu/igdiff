=head1 SCRIPT NAME

igdiff.pl

=head1 DESCRIPTION

����̕�������܂ލs�𖳎���, 2�̃t�@�C���̍������v�Z����

=head1 USAGE

perl igdiff.pl input_file1 input_file2 [ignore_file]

[ignore_file]�ɂ͉��s��؂�ō����v�Z���ɖ������镶������w�肷��.
[ignore_file]�ł͔��p�X�y�[�X�͖�������, �擪��#�̍s�̓R�����g�s�ɂȂ�.
�Ȃ�, [ignore_file]���w�肵�Ȃ��ꍇ�͒ʏ�̍����v�Z�ɂȂ�.

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
#   �s�擪������"#"�̓R�����g�s
    next if ( substr( $line, 0, 1 ) eq "#" );

#   �����̉��s�����Ƌ󔒂��폜
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
    print "�t�@�C�� $files[0] �ƃt�@�C�� $files[1] �̑���_�͌��o����܂���ł���\n";
    print "***************\n";
  }
}


sub my_trim
{
  my $str = \shift;
  $$str =~ s/\A\s*(.*?)\s*\z/$1/;
  return $$str;
}
