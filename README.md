# igdiff

## Description
����̕�������܂ލs�𖳎���, 2�̃t�@�C���̍������v�Z����

## Usage
perl igdiff.pl input_file1 input_file2 [ignore_file]

[ignore_file]�ɂ͉��s��؂�ō����v�Z���ɖ������镶������w�肷��.
[ignore_file]�ł͔��p�X�y�[�X�͖�������, �擪��#�̍s�̓R�����g�s�ɂȂ�.
�Ȃ�, [ignore_file]���w�肵�Ȃ��ꍇ�͒ʏ�̍����v�Z�ɂȂ�.

### example

[ignore_file]�̓��e���ȉ��̏ꍇ�A

         hoge
    # fuga
    piyo    
      �Ă���

"hoge", "piyo", "�Ă���"���܂܂��s�������v�Z���ɖ��������.

