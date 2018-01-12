function [KSX, Header] = ksread3(file,dataBlockNo)
%--------------------------------------------------------------------------
%% ksread3
%   ���a�W���f�[�^�t�@�C���t�H�[�}�b�gKS2��MATLAB�œǂݍ��݂��߂̃X�N���v�g�t�@�C���ł��B
%
%    �g�p�@:
%    KSX          = ksread3('FileName');
%    [KSX,Header] = ksread3('FileName');
%    KSX          = ksread3('FileName',OptNo);
%    [KSX,Header] = ksread3('FileName',OptNo);
%
%      ����
%          FileName         ... �Ώۃf�[�^�t�@�C��(�g���q�܂�:KS2 or E4A)
%                               E4A�t�@�C�����w�肵���ꍇ�C2�ڂ̈����͖�������܂�
%          OptNo(option)    ... �u���b�N�f�[�^�̓ǂݍ��ݔԍ��܂��́CKS2��E4A�t�@�C���̓����ǂݍ��݃��[�h
%                               OptNo���w�肵�Ȃ��ꍇ�C�����I�Ƀu���b�N
%                               �ԍ���1�ɂȂ�܂��B
%�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@'-1'���w�肵���ꍇ�C'Filename'�Ŏw�肵��
%                               �t�@�C�����Ɠ�����E4A�t�@�C���𓯎��ɓǂݍ��݂܂�
%                               ������E4A�t�@�C���������ꍇ�CKS2�̂ݓǂݍ��݂܂�
%      �߂�l
%          KSX              ... ���ԃf�[�^�܂߂����o�����W�^�f�[�^�B
%                               [M,(time)+N]�̑������z��B
%          Header           ... CH���(Cell�z��)
%
%
%   ���s���v�����v�g�\�����
%   �t�@�C��ID              �f�[�^���W�^�������i�̌^���ł�
%   �o�[�W����              KS2�̃o�[�W�����ł�
%   �ő�f�[�^�u���b�N��     �f�[�^�̃u���b�N���ł�
%   �w��f�[�^�u���b�N�ԍ�   BlockNo�Ŏw�肵���u���b�N���ł�
%   �W�^CH��                �A�i���OCH���ƃf�W�^��CH���𑫂���CH���ł�
%   �ʏW�^CH��            �A�i���OCH���ł�
%   �T���v�����O���g��(Hz)   �f�[�^�W�^���̃T���v�����O���g���ł�
%   �f�[�^�W�^��            1CH������̏W�^�f�[�^���ł�
%
%   ���̑��F
%           �������̃O���[�o���ϐ��ŏ������@���قȂ�܂��B
%
%
%    global g_CsvFormat;     %�w�b�_���̃t�H�[�}�b�g�̋����E�W����؂�ւ��܂�      0�F���^�C�v  1�F�W���^�C�v
%                                   ���^�C�v�FDAS-200A��Ver01.05�ȑO��CSV�ϊ��`��
%                                   �W���^�C�v�FVer01.06�ł̐V����CSV�ϊ��`��
%    global g_IndexType;     %�f�[�^�̃C���f�b�N�X��؂�ւ��܂�                     0�F����      1�F�ԍ�
%    global g_StartNumber;   %�f�[�^�̃C���f�b�N�X�̊J�n�ԍ���؂�ւ��܂�            0�F0�n�܂�   1�F1�n�܂�
%    global g_LanguageType;  %�\�������؂�ւ��܂�                                0:���{��     1:�p��
%
%
%   Copyright 2016 Kyowa ELECTRONIC INSTRUMENTS CO.,LTD.
%   version 1.03 2016/02/19
%
%   Date 13/12/25
%   ver1.00 �V�K�����[�X
%           CAN���ǂݍ��݂ɑΉ�

%   Date 14/01/24
%   ver1.01 E4A�̓ǂݍ��݂ɑΉ�
%
%   Date 14/06/20
%   ver1.02 �t�@�C���|�C���^�̏������C��
%           EDX-200A�ŏW�^�����ۂ̏W�^�J�n�J�E���^�l���Ȃ��ꍇ�̏�����ǉ�
%           float�^�̃f�[�^�������C��
%           CAN�f�[�^������Signed�^�̕s����C��

%   Date 16/02/19
%   ver1.03 KS2�t�@�C���̏W�^�J�n�J�E���^�l�̎擾�����C��
%           CSV�W���^�C�v���CE4A��KS2�𓯎��ɓǂݍ��񂾍ۂɑ���CH����NaN�ɂȂ�s����C��
%
%
%--------------------------------------------------------------------------

% initalized variable
%
    global g_NtbFlag;       %����킪NTB���������t���O
    global g_Ks2VerNum;     %KS2��Ver���


    global g_CsvFormat;     %�w�b�_���`���̋��^�C�v�E�W���^�C�v��؂�ւ��܂�
                            %0�F���^�C�v  1�F�W���^�C�v
                            %���^�C�v�FDAS-200A�̏����ۑ��`��
                            %�W���^�C�v�FVer01.06�Œǉ����ꂽ�V����CSV�ۑ��`��

    global g_IndexType;     %�ǂݍ��񂾏W�^�f�[�^�s��̐擪��ɕt������f�[�^�`����؂�ւ��܂�
                            %0�F����      1�F�ԍ�

    global g_StartNumber;   %�ǂݍ��񂾏W�^�f�[�^�s��̐擪��ɕt������f�[�^�̐擪�̊J�n�ԍ���؂�ւ��܂��B
                            %0�F0�n�܂�   1�F1�n�܂�

    global g_LanguageType;  %�{�X�N���v�g���s���̃R�}���h�v�����v�g��ɕ\�����錾���؂�ւ��܂�
                            %0:���{��     1:�p��

    g_CsvFormat    = 0;     %���^�C�v
    g_IndexType    = 0;     %����
    g_StartNumber  = 0;     %0�n�܂�
    %g_LanguageType = 0;     %���{��
    g_LanguageType = 1;     %English

    tblInfo = [];

    delm = '.';

    tblInfo.Error{1}       = 'MATLAB:ksread3:FileName';
    tblInfo.Error{2}       = 'MATLAB:ksread3:Argument';
    tblInfo.Error{3}       = 'MATLAB:ksread3:Argument';
    tblInfo.Error{11}      = 'MATLAB:ksread3:FileExist';
    tblInfo.Error{12}      = 'MATLAB:ksread3:AbnormalBlockNo';
    tblInfo.Error{13}      = 'MATLAB:ksread3:AbnormalBlockNo';
    tblInfo.Error{14}      = 'MATLAB:ksread3:FileExtension';
    tblInfo.Error{15}      = 'MATLAB:ksread3:FileExist';
    tblInfo.Error{16}      = 'MATLAB:ksread3:MeasurementParameter';
    tblInfo.Error{17}      = 'MATLAB:ksread3:FileExist';
    tblInfo.Error{21}      = 'MATLAB:ksread3:OutOfMemory';
    tblInfo.Error{22}      = 'MATLAB:ksread3:Error Ocurred';
    tblInfo.err.message    = '';
    tblInfo.err.identifier = '';
    tblInfo.err.stack      = [];

    % MATLAB��version�`�F�b�N
    vers = version;
    tblInfo.MATLAB_Ver   = str2double(vers(1:3));

    tblInfo.HeadSeek     = 256; % �Œ蒷�w�b�_���̑傫��
    tblInfo.InfoSeek     = 6;
    tblInfo.FixCH        = 16;
    tblInfo.CmpExt       = 'ks2';
    tblInfo.CmpMachine1  = 'EDX-1500A';
    tblInfo.CmpMachine2  = 'PCD-300A';
    tblInfo.CmpMachine10 = 'UDAS-100A';

    % ver1.01  MATLAB��Ver(R2008�ȍ~)�ɂ���Č���؂�ւ�������̂��߁C�p�����[�^�Őݒ肷��
    tblInfo.CmpLang = 'jhelp';
    if g_LanguageType == 0
        tblInfo.Lang = 'jhelp';
    else
        tblInfo.Lang = 'Dummy';
    end

    % (1)�������w�肳��Ă��Ȃ��ꍇ
    if nargin < 1 || isempty(file)
        error(makeDispMessage(1,tblInfo));
        exit;
    elseif nargin < 2
        dataBlockNo = 1;
    elseif nargin > 2
        % (2)�����̐����K�؂łȂ�
        strMsgBuf = makeDispMessage(2,tblInfo);
        error(strMsgBuf);
        exit;
    end

    [tbls,num] = split_str(file,delm);
    % (3)�g���q������
    if num < 2
        tblInfo.err = tbls;
        strMsgBuf = makeDispMessage(3,tblInfo);
        error(strMsgBuf);
        exit;
    end
    tblInfo.ext = lower(tbls{2}); % �擾�����g���q

    %2�Ԗڂ̈��������Ȃ�
    if(dataBlockNo < 0)
        ReadBoth = 1;
        dataBlockNo = 0;
        tblInfo.dataBlockNo = dataBlockNo;
    else
        ReadBoth = 0;
        tblInfo.dataBlockNo = dataBlockNo;
    end

    %�g���q��KS2�Ȃ�
    if(strcmpi(tblInfo.CmpExt, tblInfo.ext) == 1)

        %KS2�t�@�C���̓ǂݍ���
        fid = fopen(file,'r');
        % (11)�t�@�C�������݂��Ȃ��ꍇ
        if fid < 0
            strMsgBuf = makeDispMessage(11,tblInfo);
            error(strMsgBuf);
            exit;
        end
        % (14)�g���q���قȂ�
        if(strcmpi(tblInfo.CmpExt, tblInfo.ext) == 0)
            strMsgBuf = makeDispMessage(14,tblInfo);
            error(strMsgBuf);
            exit;
        end

        %KS2���e�L�X�g���̎擾
        tblInfo = getInfo(fid,tblInfo);

        %�u���b�N�ԍ��̃`�F�b�N
        if isnumeric(dataBlockNo) < 1
            % (13)�w�肳�ꂽ�u���b�NNo�����l�ł͂Ȃ��ꍇ
            strMsgBuf = makeDispMessage(13,tblInfo);
            error(strMsgBuf);
            exit;
        else
            % (12)�w�肳�ꂽ�u���b�NNo���s���ȏꍇ
            if dataBlockNo > tblInfo.BlockNo
                strMsgBuf = makeDispMessage(12,tblInfo);
                error(strMsgBuf);
                exit;
            else
            end
        end

        %�I�v�V�����ɓ����ǂݍ��݂��ݒ肳��Ă��Ȃ�������
        if(ReadBoth == 0)
            ReadMode = 0;
        %�����ǂݍ��݂Ȃ�
        else
            %�t�@�C�����̊g���q��KS2��E4A�ɒu��
            file((strfind(file, '.') + 1):end) = 'e4a';

            %E4A�t�@�C�������݂��邩���O�Ɋm�F����
            e4afid = fopen(file,'r');

            %�t�@�C�����̊g���q��E4A��KS2�ɒu��
            file((strfind(file, '.') + 1):end) = 'ks2';

            %E4A�t�@�C�����Ȃ��Ȃ�
            if(e4afid<0)
                ReadMode = 0;
            %E4A�t�@�C��������Ȃ�
            else
                ReadMode = 2;
                fclose(e4afid);
            end
        end
    %�g���q��E4A�Ȃ�
    elseif(strcmpi('e4a', tblInfo.ext) == 1)
        ReadMode = 1;
    %KS2�t�@�C���ł�E4A�t�@�C���ł͂Ȃ��ꍇ
    else
        % (17)KS2�t�@�C���ł�E4A�t�@�C���ł��Ȃ��ꍇ
        strMsgBuf = makeDispMessage(17,tblInfo);
        error(strMsgBuf);
        exit;
    end

    %����E4A�̂݃t�@�C���ǂݍ��ނȂ�
    if(ReadMode == 1)
        [KSX, Header, ErrNo] = e4read(file);
        if(ErrNo ~= 0)
            strMsgBuf = makeDispMessage(ErrNo,tblInfo);
            error(strMsgBuf);
            exit;
        end
        return;
    end

    %�R�}���h�E�B���h�E�ɏW�^�����̕\��
    %makeDispMessage(100,tblInfo);

    %KS2�̃o�[�W�����ԍ��̎擾
    VerStr = split_str(tblInfo.version,delm);
    g_Ks2VerNum = str2double(cell2mat(VerStr(2)));

%KS2�̏W�^�J�n�J�E���^�l�̎擾

    if(strcmpi(tblInfo.machine, 'EDX-200A') == 1)
        tblInfo.DataReadBody = (tblInfo.HeadSeek + tblInfo.variableHeader+tblInfo.dataHeader + 2);

        %�W�^�f�[�^���̃{�f�B���o�C�g���܂Ń|�C���^���ړ�
        fseek(fid, tblInfo.DataReadBody,'bof');

        %�{�f�B���o�C�g�����擾
        tblInfo.DataBodyByte = fread(fid, 1,'int64=>double');

        %�f�[�^�t�b�^���܂Ń|�C���^���ړ�
        fseek(fid, (tblInfo.DataReadBody + tblInfo.DataBodyByte + 8),'bof');

        %�I�t�Z�b�g�p�̃o�C�g����ݒ�
        OffsetSeek = (tblInfo.DataReadBody + tblInfo.DataBodyByte + 8);

        %�W�^�J�n�J�E���^�l��T��(0x12 0x19)
        while(1)
            [parent, child] = checkFlag(fid, OffsetSeek, 0);    %ver1.03

            %�f�[�^�t�b�^���̍��ڂ������Ȃ�ǂݍ��ݏI��
            if(isempty(parent) == 1)
                tblInfo.StCnt = 0;
                break;
            end
            [SeekByte, ~]= makeSeek(fid, parent, child);

            if(parent == 18)
                if(child == 32)
                    tblInfo.StCnt = fread(fid,1,'uint64');
                    break;
                end
            end

            %�啪�ށC�����ށC���ڃt���O�C�f�[�^�^��4�o�C�g�������Z����
            OffsetSeek = OffsetSeek + 4;

            %�{�f�B�o�C�g���̌^�̃T�C�Y���V�[�N�ʒu���X�V
            if (child == 25)
                OffsetSeek = OffsetSeek + 8;
            elseif (child == 26)
                OffsetSeek = OffsetSeek + 4;
            elseif (child == 28)
                OffsetSeek = OffsetSeek + 4;
            elseif (child == 30)
                OffsetSeek = OffsetSeek + 4;
            elseif (child == 31)
                OffsetSeek = OffsetSeek + 2;
            elseif (child == 32)
                OffsetSeek = OffsetSeek + 2;
            end

            %�{�f�B�o�C�g�����V�[�N�ʒu���X�V
            OffsetSeek = OffsetSeek + SeekByte;     %ver1.03
        end
    else
        tblInfo.StCnt = 0;
    end

    %E4A��KS2��ǂ݂��ނȂ�
    if(ReadMode == 2)
        %�t�@�C�����̊g���q��KS2��E4A�ɒu��
        file((strfind(file, '.') + 1):end) = 'e4a';

        %E4A�̃w�b�_���̎擾
        tblInfoE4a = e4readHeader(file);

        %KS2��E4A�̏W�^��������v���Ă��邩�m�F
        if(tblInfo.StCnt ~= tblInfoE4a.StCnt)
            %(16)����������قȂ邽��KS2��E4A�t�@�C���̌݊���������
            strMsgBuf = makeDispMessage(16,tblInfo);
            error(strMsgBuf);
            exit;
        end

        if(tblInfo.Hz ~= tblInfoE4a.Fs)
            %(16)����������قȂ邽��KS2��E4A�t�@�C���̌݊���������
            strMsgBuf = makeDispMessage(16,tblInfo);
            error(strMsgBuf);
            exit;
        end

        %E4A�t�@�C���̂�ǂݍ��ނ��߂̃��������s�����Ă�����
        try
            %CAN�f�[�^�s���NaN�ŏ�����
            e4X(1:tblInfoE4a.e4XLen-tblInfoE4a.StCnt,1:tblInfoE4a.TransChStsNum) = NaN;
        catch
            strMsgBuf = makeDispMessage(21,tblInfo);
            error(strMsgBuf);
            exit;
        end
            clear e4X;
    end

%�e�Z���f�[�^�̏�����
        tblfileID = cell(1,tblInfo.chAll+1);
        tblfileID(:,:) = {''};
        %tblfileID(1,1) = {'[ID�ԍ�]'};
        tblfileID(1,1) = {'[ID No.]'};

        tblfileTitle = cell(1,tblInfo.chAll+1);
        tblfileTitle(:,:) = {''};
        %tblfileTitle(1,1) = {'[�^�C�g��]'};
        tblfileTitle(1,1) = {'[Title]'};

        tblfileCh_num = cell(1,tblInfo.chAll+1);
        tblfileCh_num(:,:) = {''};
        %tblfileCh_num(1,1) = {'[����CH��]'};
        tblfileCh_num(1,1) = {'[Number of Channels]'};

        tblfileSf = cell(1,tblInfo.chAll+1);
        tblfileSf(:,:) = {''};
        %tblfileSf(1,1) = {'[�T���v�����O���g��(Hz)]'};
        tblfileSf(1,1) = {'[Sampling Frequency (Hz)]'};

        tblfileDigi_ch = cell(1,tblInfo.chAll+1);
        tblfileDigi_ch(:,:) = {''};
        %tblfileDigi_ch(1,1) = {'[�f�W�^������]'};
        tblfileDigi_ch(1,1) = {'[Digital Input]'};

        tblfileTime = cell(1,tblInfo.chAll+1);
        tblfileTime(:,:) = {''};
        %tblfileTime(1,1) = {'[���莞��(sec)]'};
        tblfileTime(1,1) = {'[Time (sec)]'};

%ID�ԍ�
        fseek(fid,0,'bof');
        header_array = fread(fid,20,'uchar');
        header_array(end-2:end,:)=[];           %"(0x22)�ƏI�[2����CRLF(0D�C0A)�̍폜
        header_array(1,:)=[];                   %�擪��"(0x22)�̍폜
        for n=1:size(header_array,1)
            if(header_array(end,1)==32)
                header_array(end,:)=[];
            else
                break;
            end
        end
        if(isempty(header_array)==0)
           tblfileID(1,2)={native2unicode(header_array)'};
        end
        clear header_array;

%�^�C�g��
        fseek(fid,30,'bof');
        header_array = fread(fid,44,'uchar');
        header_array(end-2:end,:)=[];           %�I�[2����CRLF(0D�C0A)�Ɓh(0x22)
        header_array(1,:)=[];
        for n=1:size(header_array,1)
            if(header_array(end,1)==32)
                header_array(end,:)=[];
            else
                break;
            end
        end
        if(isempty(header_array)==0)
            tblfileTitle(1,2)={native2unicode(header_array)'};
        end
        clear header_array;

%����`�����l����
        fseek(fid,74,'bof');
        header_array = fread(fid,8,'uchar');
        header_array(end-1:end,:)=[];           %�W�^CH���`�T���v�����O���g���܂ł́h(0x22)������
        for n=1:size(header_array,1)
            if(header_array(end,1)==32)
                header_array(end,:)=[];
            else
                break;
            end
        end
        if(isempty(header_array)==0)
            tblfileCh_num(1,2)={str2double(native2unicode(header_array)')};
        end
        clear header_array;

%�T���v�����O���g��
        fseek(fid,90,'bof');
        header_array = fread(fid,16,'uchar');
        header_array(end-2:end,:)=[];           %�I�[2����CRLF(0D�C0A)�Ɓh(0x22)
        for n=1:size(header_array,1)
            if(header_array(end,1)==32)
                header_array(end,:)=[];
            else
                break;
            end
        end
        if(isempty(header_array)==0)
            tblfileSf(1,2)={str2double(native2unicode(header_array)')};
        end
        clear header_array;

%�ϒ��w�b�_���̃o�C�g���̒��o
        fseek(fid,176,'bof');
        header_array = fread(fid,14,'uchar');    %�ϒ��w�b�_���`�ϒ��t�b�^���܂ł́h(0x22)������
        header_array(end-1:end,:)=[];
        for n=1:size(header_array,1)
            if(header_array(end,1)==32)
                header_array(end,:)=[];
            else
                break;
            end
        end
        if(isempty(header_array)==0)
            var_Header=str2double(native2unicode(header_array)');
        end
        clear header_array;

%�f�B�W�^������CH��
%�ϒ��w�b�_���擪����0x01��0x2C���A������2�o�C�g��T��

    for n=1:var_Header
        fseek(fid,256+n-1,'bof');
        if(fread(fid,1,'uchar')== 1)
            fseek(fid,256+n,'bof');
            if(fread(fid,1,'uchar')== 44)
                fseek(fid,4,'cof');
                lsb_b=fread(fid,1,'uchar');
                msb_b=fread(fid,1,'uchar');
                if((lsb_b == 255 && msb_b == 255) || (lsb_b == 0 && msb_b == 0))
                    tblfileDigi_ch(1,2)={'OFF'};
                elseif((1<=lsb_b && lsb_b<=10) && msb_b==0)
                    tblfileDigi_ch(1,2)={'ON('};
                    tblfileDigi_ch(1,2)={strcat(cell2mat(tblfileDigi_ch(1,2)),num2str(lsb_b),')')};
                else
                    tblfileDigi_ch(1,2)={'OFF'};
                end
                break;
            end
        end
    end

    % �W�^CANCH��0��ݒ�
    tblInfo.CanChNum = 0;

    [strRcvBuf,tblHeader, tblInfo.CanChNum] = DataRead12(fid,tblInfo);
    % �W�J����z��T�C�Y�����ݎg�p�\�ȃ�������Ԉȏ�̏ꍇ
    if strRcvBuf == 999
        strMsgBuf = makeDispMessage(21,tblHeader);
        error(strMsgBuf);
        exit;
    elseif strRcvBuf == 111
        % edit at 2008/01/25 �������ȊO�̃G���[�����������ꍇ
        strMsgBuf = makeDispMessage(22,tblHeader);
        error(strMsgBuf);
        exit;
    end

    KSX = strRcvBuf;
    clear strRcvBuf;

    %CAN-CH�ԍ�������CH�������Z
    tblfileCh_num(1,2)={(tblInfo.CanChNum + tblInfo.chAll)};

%CAN�f�[�^������ꍇ�̏���
    if (tblInfo.CAN ~= 0)
        if(tblInfo.chAll ~= 0)
            tblfileID(      tblInfo.chAll+2:tblInfo.CanChNum+tblInfo.chAll+1)={''};
            tblfileTitle(   tblInfo.chAll+2:tblInfo.CanChNum+tblInfo.chAll+1)={''};
            tblfileCh_num(  tblInfo.chAll+2:tblInfo.CanChNum+tblInfo.chAll+1)={''};
            tblfileDigi_ch( tblInfo.chAll+2:tblInfo.CanChNum+tblInfo.chAll+1)={''};
            tblfileSf(      tblInfo.chAll+2:tblInfo.CanChNum+tblInfo.chAll+1)={''};
            tblfileTime(    tblInfo.chAll+2:tblInfo.CanChNum+tblInfo.chAll+1)={''};
        end
    end

    %���莞�Ԃ̎Z�o    �f�[�^/Ch���T���v�����O�����Ŋ���
     tblfileTime(1,2)={cell2mat(tblHeader(end,2))/cell2mat(tblfileSf(1,2))};

    %�`�����l������1CH�̏ꍇ�C����������3�Z�������̂ɑ΂��C����2�Z���ƂȂ邽�ߋ��3�Z���ڂ�ǉ�

    if(tblInfo.chAll<=1)
        tblfileID(:,3)={''};
        tblfileTitle(:,3)={''};
        tblfileCh_num(:,3)={''};
        tblfileDigi_ch(:,3)={''};
        tblfileSf(:,3)={''};
        tblfileTime(:,3)={''};

        Header = [tblfileID;tblfileTitle;tblfileCh_num;tblfileDigi_ch;tblfileSf;tblHeader;tblfileTime];
    else
        Header = [tblfileID;tblfileTitle;tblfileCh_num;tblfileDigi_ch;tblfileSf;tblHeader;tblfileTime];
    end

    %���^�C�v
    if g_CsvFormat == 0
        %NTB�ȊO
        if g_NtbFlag == 0
            Header=cat(1,Header(1:2,:),Header(end-2,:),Header(3:end,:));
            Header=cat(1,Header(1:6,:),Header(end-1:end,:),Header(7:end,:));
            Header=cat(1,Header(1:11,:),Header(15:17,:));
        %NTB
        else
            Header=cat(1,Header(1:2,:),Header(end-2,:),Header(3:end,:));
            Header=cat(1,Header(1:6,:),Header(end-1:end,:),Header(7:end,:));
            Header(19:end,:)=[];
        end
    %�W���^�C�v
    else
        %NTB�ȊO
        if g_NtbFlag == 0
            Header=cat(1,Header(1:2,:),Header(end-2,:),Header(3:end,:));
            Header=cat(1,Header(1:6,:),Header(end-1:end,:),Header(7:end,:));
            Header=cat(1,Header(1:4,:),Header(6:9,:),Header(11:17,:),Header(10,:));
        %NTB
        else
            Header=cat(1,Header(1:2,:),Header(end-2,:),Header(3:end,:));
            Header=cat(1,Header(1:6,:),Header(end-1:end,:),Header(7:end,:));
            Header=cat(1,Header(1:4,:),Header(6:9,:),Header(11:18,:),Header(10,:));
        end
    end

    fclose(fid);

    clear tblfileCh_num
    clear tblfileDigi_ch
    clear tblfileID
    clear tblfileSf
    clear tblfileTime
    clear tblfileTitle
    clear tblHeader

    %E4A��KS2��ǂݍ��ނȂ�
    if(ReadMode == 2)
        [e4X, e4Header] = e4read(file);

        %E4A�̃f�[�^�s��̒������擾
        [e4M,~] = size(e4X);

        %KS2�̃f�[�^�s��̒������擾
        [ksM,ksN] = size(KSX);

        %E4A�̃f�[�^����KS2��菭�Ȃ��Ȃ�
        if(e4M < ksM)
            %KS2�̃f�[�^�����܂őO�l�ێ�����

            %�ŏI�s�̃f�[�^���擾
            MatrixV= e4X(e4M,:);

            %�ŏI�s��KS2�̒������R�s�[
            e4X = vertcat(e4X,MatrixV(ones(1,ksM-e4M),:));
        end

        %E4A�̃w�b�_���̍��ڗ���폜����
        %���^�C�v�̏ꍇ
        if(g_CsvFormat == 0)

            %ID�ԍ��̍폜
            e4Header(1,2)={''};

            %�^�C�g���̍폜
            e4Header(2,2)={''};

            %���������̍폜
            e4Header(3,2:3)={''};

            %KS2�̑���CH���̒u������
            Header(4,2)= {(cell2mat(Header(4,2)) + cell2mat(e4Header(4,2)))};

            %����CH���̍폜
            e4Header(4,2)={''};

            %�T���v�����O���g���̍폜
            e4Header(6,2)={''};

            %�W�^�f�[�^���̍폜
            e4Header(7,2)={''};

            %���莞�Ԃ̍폜
            e4Header(8,2)={''};

        %�W���^�C�v�̏ꍇ
        else

            %ID�ԍ��̍폜
            e4Header(1,2)={''};

            %�^�C�g���̍폜
            e4Header(2,2)={''};

            %���������̍폜
            e4Header(3,2:3)={''};

            %KS2�̑���CH���̒u������
            Header(4,2)= {(cell2mat(Header(4,2)) + cell2mat(e4Header(4,2)))};     %ver1.03

            %����CH���̍폜
            e4Header(4,2)={''};

            %�T���v�����O���g���̍폜
            e4Header(5,2)={''};

            %�W�^�f�[�^���̍폜
            e4Header(6,2)={''};

            %���莞�Ԃ̍폜
            e4Header(7,2)={''};
        end

        %KS2�̏W�^CH���̍��v��1CH�̏ꍇ�CKS2�̃w�b�_���̎���������3��ڂ�E4A����������2��ڂɃR�s�[
        if(ksN == 2)
            e4Header(3,2) = Header(3,3);

            Header(:,3)=[];
        end
        %E4A�̃w�b�_��KS2�̃w�b�_������
        Header = horzcat(Header,e4Header(:,2:end));

        %E4A�f�[�^��KS2�f�[�^������
        KSX = horzcat(KSX,e4X(:,2:end));
    end

    fileName_saved = file;
    fileName_saved((strfind(fileName_saved, '.') + 1):end) = 'mat';
    disp(['file ', fileName_saved, ' saved!'])
    save(fileName_saved, 'Header', 'KSX')

%--------------------------------------------------------------------------

%% makeDispMessage - �G���[���b�Z�[�W�̐���
%    ����
%        pos       ... �G���[���̔ԍ�
%    �߂�l
%        strSndBuf ... �Ώۂ̕�����
function strSndBuf = makeDispMessage(pos,tblInfo)

    if strcmp(tblInfo.Lang,tblInfo.CmpLang)
        switch pos
            case 1
                strMsgBuf = tblInfo.Error{1};
                strMsgBuf = sprintf('%s:�t�@�C�������g���q�t�œ��͂��ĉ������B', strMsgBuf);
                strMsgBuf = sprintf('%s\n�� : X    = ksread3(''filename'');', strMsgBuf);
                strMsgBuf = sprintf('%s\nor  [X,H] = ksread3(''filename'');', strMsgBuf);
                strMsgBuf = sprintf('%s\nor   X    = ksread3(''filename'',OptNo);', strMsgBuf);
                strMsgBuf = sprintf('%s\nor  [X,H] = ksread3(''filename'',OptNo);\n', strMsgBuf);
                strMsgBuf = sprintf('%s\nX                ... ���o�����f�[�^�z��', strMsgBuf);
                strMsgBuf = sprintf('%s\nH                ... CH���\n', strMsgBuf);
                strMsgBuf = sprintf('%s\nfilename         ... �Ώۃf�[�^�t�@�C��(�g���q���܂�)', strMsgBuf);
                strMsgBuf = sprintf('%s\nOptNo(option)    ... �f�[�^�u���b�N�ԍ�\n', strMsgBuf);
                strMsgBuf = sprintf('%s                     �܂���E4A�t�@�C���̓����ǂݍ���(-1���w�肵�C''filename''��KS2�t�@�C���̏ꍇ)', strMsgBuf);
            case 2
                strMsgBuf = tblInfo.Error{2};
                strMsgBuf = sprintf('%s:�w�肳�ꂽ�I�v�V�����̐����s���ł��B', strMsgBuf);
            case 3
                strMsgBuf = tblInfo.Error{3};
                strMsgBuf = sprintf('%s:�g���q���w�肳��Ă��܂���B:(%s)', strMsgBuf,tblInfo.err);
            case 11
                strMsgBuf = tblInfo.Error{11};
                strMsgBuf = sprintf('%s:�w�肳�ꂽ�t�@�C�������݂��Ȃ����A�t�@�C�������Ԉ���Ă��܂��B', strMsgBuf);
            case 12
                strMsgBuf = tblInfo.Error{12};
                strMsgBuf = sprintf('%s:�w�肳�ꂽ�u���b�N�ԍ��͕s���ł��B', strMsgBuf);
            case 13
                strMsgBuf = tblInfo.Error{13};
                strMsgBuf = sprintf('%s:�w�肳�ꂽ�u���b�N�ԍ������l�ł͂���܂���B', strMsgBuf);
                strMsgBuf = sprintf('%s\n�u���b�N�ԍ��ɂ͐��l���w�肵�Ă��������B', strMsgBuf);
            case 14
                strMsgBuf = tblInfo.Error{14};
                strMsgBuf = sprintf('%s:�w�肳�ꂽ�t�@�C����%s�t�@�C���ł͂���܂���B', strMsgBuf, tblInfo.CmpExt);
            case 15
                strMsgBuf = tblInfo.Error{15};
                strMsgBuf = sprintf('%s:�w�肳�ꂽ�t�@�C���ɑΉ�����E4A�t�@�C�������݂��܂���B', strMsgBuf);
            case 16
                strMsgBuf = tblInfo.Error{16};
                strMsgBuf = sprintf('%s:�w�肳�ꂽE4A�t�@�C����KS2�t�@�C���̏W�^�������قȂ�܂��B', strMsgBuf);
                strMsgBuf = sprintf('%s\nE4A�t�@�C����KS2�t�@�C�����m�F���Ă��������B', strMsgBuf);
            case 17
                strMsgBuf = tblInfo.Error{17};
                strMsgBuf = sprintf('%s:KS2�t�@�C����E4A�t�@�C�����w�肵�Ă��������B', strMsgBuf);
            case 21
                strMsgBuf = tblInfo.Error{21};
                strMsgBuf = sprintf('%s:\n', strMsgBuf);
                strMsgBuf = sprintf('%s�Ώۃt�@�C�����I�[�v�����邽�߂ɂ́A���݃�����������܂���B', strMsgBuf);
                strMsgBuf = sprintf('%s\nHELP MEMORY�ƃ^�C�v���ăI�v�V�������m�F���Ă��������B', strMsgBuf);
            case 22
                strMsgBuf = sprintf('%s:\n%s\n%s\n', tblInfo.Error{22}, tblInfo.err.message, tblInfo.err.identifier);
            case 31
                strMsgBuf = sprintf('�f�[�^�W�^��          = %d',tblInfo.LngHeight);
                disp(strMsgBuf);
                strMsgBuf = '';
            case 32
                strMsgBuf = sprintf('Please wait ... �f�[�^�ϊ���(%s�t�@�C��)',tblInfo.ext);
            case 100
                strMsgBuf = sprintf('�t�@�C��ID            = %s',tblInfo.machine);
                strMsgBuf = sprintf('%s\n�o�[�W����            = %s', strMsgBuf,tblInfo.version);
                strMsgBuf = sprintf('%s\n�ő�f�[�^�u���b�N��   = %d', strMsgBuf,tblInfo.BlockNo);
                strMsgBuf = sprintf('%s\n�w��f�[�^�u���b�N�ԍ� = %d', strMsgBuf,tblInfo.dataBlockNo);
                strMsgBuf = sprintf('%s\n�W�^CH��              = %d', strMsgBuf,tblInfo.chAll);
                strMsgBuf = sprintf('%s\n�ʏW�^CH��          = %d', strMsgBuf,tblInfo.ch);
                strMsgBuf = sprintf('%s\n�T���v�����O���g��(%s) = %d', strMsgBuf,tblInfo.HzChar,tblInfo.Hz);
                disp(strMsgBuf);
                strMsgBuf = '';
            otherwise
        end
    else
        switch pos
            case 1
                strMsgBuf = tblInfo.Error{1};
                strMsgBuf = sprintf('%s:Please insert a file name with extensions.',strMsgBuf);
                strMsgBuf = sprintf('%s\nexp: X    = ksread3(''filename'');', strMsgBuf);
                strMsgBuf = sprintf('%s\nor   X    = ksread3(''filename'',OptNo);', strMsgBuf);
                strMsgBuf = sprintf('%s\nor  [X,H] = ksread3(''filename'',OptNo);\n', strMsgBuf);
                strMsgBuf = sprintf('%s\nX                ... extracted data array', strMsgBuf);
                strMsgBuf = sprintf('%s\nH                ... CH\n', strMsgBuf);
                strMsgBuf = sprintf('%s\nfilename         ... data file(include extension)', strMsgBuf);
                strMsgBuf = sprintf('%s\nOptNo(option)    ... Data block No. \n', strMsgBuf);
                strMsgBuf = sprintf('%s�@�@�@�@�@�@�@�@�@�@�@ Or both KS2 and E4A file Read-mode(If specified value is -1 and specified ''filename'' is KS2 file)\n', strMsgBuf);
            case 2
                strMsgBuf = tblInfo.Error{2};
                strMsgBuf = sprintf('%s:Intended the number of option is incorrect.', strMsgBuf);
            case 3
                strMsgBuf = tblInfo.Error{3};
                strMsgBuf = sprintf('%s:The file which is intended is no extension.(%s)', strMsgBuf,tblInfo.err);
            case 11
                strMsgBuf = tblInfo.Error{11};
                strMsgBuf = sprintf('%s:The file which is intended is nonexistent of filen name is incorrect.', strMsgBuf);
            case 12
                strMsgBuf = tblInfo.Error{12};
                strMsgBuf = sprintf('%s:Intended block No. is incorrect.', strMsgBuf);
            case 13
                strMsgBuf = tblInfo.Error{13};
                strMsgBuf = sprintf('%s:Intended block No. is not numeric.', strMsgBuf);
                strMsgBuf = sprintf('%s\nPlease intend numeric on the block No.', strMsgBuf);
            case 14
                strMsgBuf = tblInfo.Error{14};
                strMsgBuf = sprintf('%s:Specified file is not %s file.', strMsgBuf, tblInfo.CmpExt);
            case 15
                strMsgBuf = tblInfo.Error{15};
                strMsgBuf = sprintf('%s:Specified file is not existent.', strMsgBuf);
            case 16
                strMsgBuf = tblInfo.Error{16};
                strMsgBuf = sprintf('%s:Measurement parameter E4A file and KS2 file is diffrent.', strMsgBuf);
                strMsgBuf = sprintf('%s\nPlease check E4A file and KS2 file.', strMsgBuf);
            case 17
                strMsgBuf = tblInfo.Error{17};
                strMsgBuf = sprintf('%s:Specified KS2 file of E4A file.', strMsgBuf);
            case 21
                strMsgBuf = sprintf('%s:%s\n%s\n', tblInfo.Error{21}, tblInfo.err.message, tblInfo.err.identifier);
                strMsgBuf = sprintf('%s\nThere is insufficient memory spece.', strMsgBuf);
                strMsgBuf = sprintf('%s\nPlease confirm the option by typing HELP MEMORY', strMsgBuf);
            case 22
                strMsgBuf = sprintf('%s:\n%s\n%s\n', tblInfo.Error{22}, tblInfo.err.message, tblInfo.err.identifier);
            case 31
                strMsgBuf = sprintf('Scanning Data Length / CH        = %d',tblInfo.LngHeight);
                disp(strMsgBuf);
                strMsgBuf = '';
            case 32
                strMsgBuf = sprintf('Please wait ... translate data(%s file)',tblInfo.ext);
            case 100
                strMsgBuf = sprintf('FileID                           = %s',tblInfo.machine);
                strMsgBuf = sprintf('%s\nVersion                          = %s', strMsgBuf, tblInfo.version);
                strMsgBuf = sprintf('%s\nThe number of max. data block    = %d', strMsgBuf, tblInfo.BlockNo);
                strMsgBuf = sprintf('%s\nA number of max. data block      = %d', strMsgBuf, tblInfo.dataBlockNo);
                strMsgBuf = sprintf('%s\nThe number of max. recording CH. = %d', strMsgBuf, tblInfo.chAll);
                strMsgBuf = sprintf('%s\nThe number of recording CH.      = %d', strMsgBuf, tblInfo.ch);
                strMsgBuf = sprintf('%s\nRecording frequency(%s)          = %d', strMsgBuf, tblInfo.HzChar,tblInfo.Hz);
                disp(strMsgBuf);
                strMsgBuf = '';
            otherwise
        end
    end
    strSndBuf = strMsgBuf;

%--------------------------------------------------------------------------
%% �e�L�X�g���̏��擾
%    ����
%        fid     ... �t�@�C���|�C���^�I�u�W�F�N�g
%        tblInfo ... �\���̕ϐ�
%    �߂�l
%        info    ... ����ǉ������\���̕ϐ�

function info = getInfo(fid,tblInfo)

    delm = ' ';
    i = 1;
    while 1
        line = fgetl(fid);
        if (i <= 2)
          tbls = split_str(line(2:(length(line)-1)),delm);
          if i == 1
              tblInfo.machine = tbls{1}; % ���O
          else
              tblInfo.version = tbls{1}; % �o�[�W����
              if strcmp(tblInfo.version,'01.00.00')
                  i = i + 1;
              end
          end
        elseif (i > 2) && (i <= 16)
            if i == 7
                tbls = split_str(line(2:(length(line)-1)),delm);
                strRcvBuf = tbls{1};
            else
                strRcvBuf = line;
            end
            if i == 4
                tblInfo.chAll = str2double(strRcvBuf);
            elseif i == 5
                tblInfo.ch    = str2double(strRcvBuf);
            elseif i == 6
                token = str2double(strRcvBuf);
                if token == 0
                    token = 1;
                end
                tblInfo.Hz = token;
            elseif i == 7
                tblInfo.HzChar = strRcvBuf;
            elseif i == 10
                tblInfo.BlockNo = str2double(strRcvBuf);
            elseif i == 11                                       % KS1->0,KS2->1
                check = strcmp(tblInfo.ext,tblInfo.CmpExt);
                if check == 0
                    tblInfo.CAN = 0;
                else
                    token = strRcvBuf(2:length(strRcvBuf));
                    if isempty(token)
                        token = 0;
                    else
                        token = str2double(token(1:(length(token)-1)));
                        if length(token) < 1
                            token = 0;            % token����̏ꍇ
                        end
                    end
                    tblInfo.CAN = token;
                end
            elseif i == 13
                tblInfo.variableHeader = str2double(strRcvBuf);
            elseif i == 14
                tblInfo.dataHeader     = str2double(strRcvBuf);
            end
        else
            break;
        end
        i = i + 1;
    end
    info = tblInfo;



%--------------------------------------------------------------------------
%% DataRead - �f�[�^��ǂݍ��ގ菇���s��
%    ����
%        f           ... �t�@�C���|�C���^�I�u�W�F�N�g
%        tblInfo     ... �w�b�_�e������i�[�����\���̕ϐ�
%    �߂�l
%        strSndBuf ... ���o�����W�^�f�[�^
%        tblHeader ... CH���

function [strSndBuf, tblHeader, CanChNum] = DataRead12(f,tblInfo)
    global g_NtbFlag;         %����킪NTB���������t���O
    global g_CsvFormat;       %�w�b�_���̃t�H�[�}�b�g�̋����E�W����؂�ւ��܂�      0�F���^�C�v  1�F�W���^�C�v
    global g_IndexType;       %�f�[�^�̃C���f�b�N�X��؂�ւ��܂�                     0�F����      1�F�ԍ�

% initalized variable
    lngSeek = tblInfo.HeadSeek;                 % �e�L�X�g���o�C�g��
    delta   = 0;                                % �f�[�^�̓ǂݔ�΂���
    tblCoeff  = zeros(1,tblInfo.ch,'double');   % �H�w�l�ϊ��W��A edit at 2012/09/28   single��double�ɕύX  ����͂ǂ���ł�����
    tblOffset = zeros(1,tblInfo.ch,'double');   % �H�w�l�ϊ��W��B edit at 2012/09/28   single��double�ɕύX  ����͂ǂ���ł�����
    tblName = {};                               % �`���l����
    tblNo = {};                                 % �`���l��No
    tblUnit = {};                               % �P�ʕ�����
    tblrange = {};                              % �����W
    tblCoeff_disp = {};                         % �Z���W��
    tblOffset_disp = {};                        % �I�t�Z�b�g
    tblLowPass = {};                            % ���[�p�X�t�B���^
    tblHighPass = {};                           % �n�C�p�X�t�B���^
    tblDigiFilter = {};                         % �n�C�p�X�t�B���^
    tblfileDate ={};                            % ��������
    tblfileData_num = {};                       % �f�[�^/ch
    tblChMode = {};                             % CH���[�h
    tblGaugeFactor = {};                        % �Q�[�W��
    tblZeroMode = {};                           % ZERO�l�̃��[�h
    tblZeroNum = {};                            % ZERO�l
    blkLMT      = tblInfo.BlockNo;              % �ő�u���b�N��
    dataBlockNo = tblInfo.dataBlockNo;          % �����Ŏw�肵���u���b�N�ԍ�
    flgDebug  = 0;                              % ���\���𑀍삷��t���O(0:��\��,1:�\��)
    g_NtbFlag = 0;                              % ����킪NTB���������t���O
    tblInfo.checkArray = [];                    % �`�F�b�N�p�z��(depend printInfoAbove)

    cell_data = cell(1,tblInfo.chAll+1);        % �f�B�W�^��CH���܂ޑS�`�����l��
    cell_data(:,:)={''};                        % ��f�[�^�ŏ���������

    %�ϒ��w�b�_�����
    [parent,child] = checkFlag(f,lngSeek,delta);
    while parent < 3
        [smlSeek,strCharBuf] = makeSeek(f,parent,child);
        [delta,strRcvBuf,flgCoeff,tblInfo] = printInfoAbove(f,tblInfo, parent,child,...
                                                          smlSeek,strCharBuf, tblCoeff,tblOffset,...
                                                          delta,flgDebug,cell_data);
        [parent,child] = checkFlag(f,lngSeek,delta);
        switch flgCoeff
            case 1,     tblCoeff = strRcvBuf;           %   �H�w�l�ϊ��W��A
            case 2,     tblOffset = strRcvBuf;          %   �H�w�l�ϊ��W��B
            case 3,     tblNo = strRcvBuf;              %   CH�ԍ�
            case 4,     tblName = strRcvBuf;            %   CH����
            case 5,     tblUnit = strRcvBuf;            %   �P��
            case 6,     tblrange = strRcvBuf;           %   �����W
            case 7,     tblCoeff_disp = strRcvBuf;      %   �Z���W��
            case 8,     tblOffset_disp = strRcvBuf;     %   �I�t�Z�b�g
            case 9,     tblLowPass = strRcvBuf;         %   ���[�p�X�t�B���^
            case 10,    tblHighPass = strRcvBuf;        %   �n�C�p�X�t�B���^
            case 11,    tblDigiFilter = strRcvBuf;      %   �f�W�^���t�B���^
            case 12,    tblChMode = strRcvBuf;          %   CH���[�h
            case 13,    tblGaugeFactor = strRcvBuf;     %   �Q�[�W��
            case 14,    tblZeroMode = strRcvBuf;        %   ZERO�l�̃��[�h
        end
    end

    %�f�[�^�����
    for i = 1:blkLMT
        [parent,child] = checkFlag(f,lngSeek,delta);
        flags = parent;
        while flags <= parent
            switch i
             case dataBlockNo
              flgDebug = 1;
            end
            [smlSeek,strCharBuf] = makeSeek(f,parent,child);
            [delta,strRcvBuf,flgCoeff,tblInfo] = printInfoAbove(f,tblInfo, parent,child,...
                                                              smlSeek,strCharBuf, tblCoeff,tblOffset,...
                                                              delta,flgDebug,cell_data);
            [parent,child] = checkFlag(f,lngSeek,delta);

            switch flgCoeff
                case 9                          %   ��������
                    tblfileDate = strRcvBuf;
                case 10                         %   �f�[�^��/ch
                    tblfileData_num = strRcvBuf;
            end

            if flags < parent
                flags = parent;
            elseif parent > 18
                break;
            end
            switch flgCoeff
             case 3, strSndBuf = strRcvBuf;
             case 111
                 strSndBuf = 111;
                 tblHeader = tblInfo;
                 CanChNum = tblInfo.CanChNum;
                 return
             case 999
                 strSndBuf = 999;
                 tblHeader = tblInfo;
                 CanChNum = tblInfo.CanChNum;
                 return
            end
        end
        switch i
         case dataBlockNo, break
        end
    end

%�`�����l�����́C�����W�C�P�ʂ�KS2�t�@�C���ɕK�{�ȍ��ڂł͖������߁C�f�[�^��������Ȃ������ꍇ�̏���

    if(isempty(tblName)==1)
        tblName = cell(1,tblInfo.chAll+tblInfo.CanChNum+1);
        tblName(:,:)={''};
        %tblName(1,1)={'[CH����]'};
        tblName(1,1)={'[CH Name]'};
    end
    if(isempty(tblrange)==1)
        tblrange = cell(1,tblInfo.chAll+tblInfo.CanChNum+1);
        tblrange(:,:)={0};
        %tblrange(1,1)={'[�����W]'};
        tblrange(1,1)={'[Range]'};
    end
    if(isempty(tblUnit)==1)
        tblUnit = cell(1,tblInfo.chAll+tblInfo.CanChNum+1);
        tblUnit(:,:)={''};
        %tblUnit(1,1)={'[�P��]'};
        tblUnit(1,1)={'[Unit]'};
    end
    if(isempty(tblLowPass)==1)
        tblLowPass = cell(1,tblInfo.chAll+tblInfo.CanChNum+1);
        tblLowPass(:,:)={'**'};
        %tblLowPass(1,1)={'[���[�p�X�t�B���^]'};
        tblLowPass(1,1)={'[Low Pass Filter]'};
        for i = tblInfo.ch+1:tblInfo.chAll+tblInfo.CanChNum-1
            tblLowPass(i+2)={''};
        end
    else
    end
    if(isempty(tblHighPass)==1)
        tblHighPass = cell(1,tblInfo.chAll+tblInfo.CanChNum+1);
        tblHighPass(:,:)={'**'};
        %tblHighPass(1,1)={'[�n�C�p�X�t�B���^]'};
        tblHighPass(1,1)={'[High Pass Filter]'};
        for i = tblInfo.ch+1:tblInfo.chAll+tblInfo.CanChNum-1
            tblHighPass(i+2)={''};
        end
    end
    if(isempty(tblDigiFilter)==1)
        tblDigiFilter = cell(1,tblInfo.chAll+tblInfo.CanChNum+1);
        tblDigiFilter(:,:)={'***'};
        %tblDigiFilter(1,1)={'[�f�W�^���t�B���^]'};
        tblDigiFilter(1,1)={'[Digital Filter]'};
        for i = tblInfo.ch++1:tblInfo.chAll+tblInfo.CanChNum-1
            tblDigiFilter(i+2)={''};
        end
    end

    %ZERO�l�̍��ڂ����������ꍇ
    if(isempty(tblZeroMode)==1)
        g_NtbFlag = 0;
    else
        g_NtbFlag = 1;
        %tblZeroNum(1,1) = {'[ZERO�l]'};
        tblZeroNum(1,1) = {'[ZERO Value]'};
        tblZeroMode(1,1) = {'[ZERO]'};
        %ZERO�l��ZERO�̃��[�h�̍��ڂ𕪉�����
        for i = 1:tblInfo.chAll
            TempStr = split_str(cell2mat(tblZeroMode(1,i+1)),',');
            tblZeroNum(1,i+1) = TempStr(1);
            tblZeroMode(1,i+1) = TempStr(2);
        end
    end
%�A�i���OCH�����������ꍇ�̏���
    if (tblInfo.ch == 0)
        %CH�ԍ��Z���̏�����
        if g_CsvFormat == 0
            tblNo(1) = {'[CH No]'};
        else
            if g_IndexType == 0
                tblNo(1) = {'[Time(sec)]'};
            else
                tblNo(1) = {'[No.]'};
            end
        end

        %�Z���W���Z���̏�����
        %tblCoeff_disp(1)={'[�Z���W��]'};
        tblCoeff_disp(1)={'[Calibration Coeff.]'};

        %�I�t�Z�b�g�Z���̏�����
        %tblOffset_disp(1)={'[�I�t�Z�b�g]'};
        tblOffset_disp(1)={'[Offset]'};

        tblInfo.CanChStNo = 1;
    end

%CAN�f�[�^������ꍇ�̏���
    if (tblInfo.CAN ~= 0)
        CanChNum = tblInfo.CanChNum;
        for k = 1:CanChNum
            %CAN-CH�ԍ��̐ݒ�
            tblNo(k+tblInfo.ch+1) = {strcat('CH-',num2str(tblInfo.CanChStNo+(k-1)))};

            %CAN-CH���̂̐ݒ�
            if(isempty(nonzeros(tblInfo.CanCh(k).ChName))==0)
                tblName(k+tblInfo.ch+1) = {native2unicode(nonzeros(tblInfo.CanCh(k).ChName)')};
            else
                tblName(k+tblInfo.ch+1) = {''};
            end

            %CAN-CH�Z���W���̐ݒ�(float��double���̔���ǉ��K�v)
            tblCoeff_disp(k+tblInfo.ch+1) = {tblInfo.CanCh(k).Coeffs};

            %CAN-CH�I�t�Z�b�g�̐ݒ�(float��double���̔���ǉ��K�v)
            tblOffset_disp(k+tblInfo.ch+1) = {tblInfo.CanCh(k).Offset};

            %�P�ʕ�����̐ݒ�
            if(isempty(nonzeros(tblInfo.CanCh(k).UnitStr))==0)
                tblUnit(k+tblInfo.ch+1) = {native2unicode(nonzeros(tblInfo.CanCh(k).UnitStr)')};
            end
        end
    end

%�z��̏�����
    tblInfo.DigiChNum = (tblInfo.chAll-tblInfo.ch);
    tblInfo.MeasChNum = tblInfo.chAll + tblInfo.CanChNum;

    %���������̏�����
    %�W�^CH����2���傫���Ȃ�z���4�Ԗڂ���z��̏��������s��
    if(tblInfo.MeasChNum > 2)
        tblfileDate(4:tblInfo.MeasChNum+1) = {''};
    end

    %�W�^�f�[�^���̏�����
    %�W�^CH����2���傫���Ȃ�z���4�Ԗڂ���z��̏��������s��
    if( (tblInfo.MeasChNum) > 1)
        tblfileData_num(3:tblInfo.MeasChNum+1) = {''};
    else
        %�z���3�Ԗڂ�������
        tblfileData_num(:,3) = {''};
    end

    %CH���́C�Z���W���C�I�t�Z�b�g�C�P�ʂ̏�����
    %DI�̏W�^���������ꍇ����CH�������������s��
    if( (tblInfo.ch + tblInfo.CanChNum) == 0)
        tblName(2:3) = {''};
        tblCoeff_disp(2:3) = {''};
        tblOffset_disp(2:3) = {''};
        tblUnit(2:3) = {''};
    elseif((tblInfo.ch + tblInfo.CanChNum) == 1)
        if(tblInfo.DigiChNum == 1)
            %�z���3�Ԗڂ�������
            tblName(:,3) = {''};
            tblCoeff_disp(:,3) = {''};
            tblOffset_disp(:,3) = {''};
            tblUnit(:,3) = {''};
        elseif(tblInfo.DigiChNum == 2)
            %�z���3,4�Ԗڂ�������
            tblName(3:4) = {''};
            tblCoeff_disp(3:4) = {''};
            tblOffset_disp(3:4) = {''};
            tblUnit(3:4) = {''};
        else
            %�z���3�Ԗڂ�������
            tblName(:,3) = {''};
            tblCoeff_disp(:,3) = {''};
            tblOffset_disp(:,3) = {''};
            tblUnit(:,3) = {''};
        end
    else
        if(tblInfo.DigiChNum ~= 0)
            tblName((tblInfo.ch + tblInfo.CanChNum)+2:tblInfo.MeasChNum+1) = {''};
            tblCoeff_disp((tblInfo.ch + tblInfo.CanChNum)+2:tblInfo.MeasChNum+1) = {''};
            tblOffset_disp((tblInfo.ch + tblInfo.CanChNum)+2:tblInfo.MeasChNum+1) = {''};
            tblUnit((tblInfo.ch + tblInfo.CanChNum)+2:tblInfo.MeasChNum+1) = {''};
        end
    end

    %CH No�̏�����
    %DI�̏W�^���������ꍇ����CH�������������s��
    if( (tblInfo.MeasChNum) == 1)
        tblNo(3) = {''};
    end

    if(tblInfo.DigiChNum == 1)
        tblNo((tblInfo.ch + tblInfo.CanChNum)+2) = {'DI-1'};
    elseif(tblInfo.DigiChNum == 2)
        tblNo((tblInfo.ch + tblInfo.CanChNum)+2) = {'DI-1'};
        tblNo((tblInfo.ch + tblInfo.CanChNum)+3) = {'DI-2'};
    end

    %�����W�C���[�p�X�C�n�C�p�X�C�f�W�^���̏�����
    %�A�i���O��CH����0or1�Ȃ�z���3�Ԗڂ܂ŏ�����
    if(tblInfo.ch == 0)
        tblrange(2:3) = {''};
        tblLowPass(2:3)={''};
        tblHighPass(2:3)={''};
        tblDigiFilter(2:3)={''};
    elseif(tblInfo.ch == 1)
        tblrange(3) = {''};
        tblLowPass(3)={''};
        tblHighPass(3)={''};
        tblDigiFilter(3)={''};
    end
    if( (tblInfo.DigiChNum + tblInfo.CanChNum) ~= 0)
        tblrange(tblInfo.ch+2:tblInfo.MeasChNum+1) = {''};
        tblLowPass(tblInfo.ch+2:tblInfo.MeasChNum+1)={''};
        tblHighPass(tblInfo.ch+2:tblInfo.MeasChNum+1)={''};
        tblDigiFilter(tblInfo.ch+2:tblInfo.MeasChNum+1)={''};
    end



    %NTB�̏ꍇ�CCH���[�h�C�Q�[�W���CZERO,ZERO�l�̍��ڂ�ǉ�����
    if g_NtbFlag == 1
        if(tblInfo.chAll == 1)
            tblChMode(:,3)      = {''};
            tblGaugeFactor(:,3) = {''};
            tblZeroMode(:,3)    = {''};
            tblZeroNum(:,3)     = {''};
        end
        tblHeader = [tblName;tblNo;tblChMode;tblrange;tblCoeff_disp;tblOffset_disp;tblGaugeFactor;tblZeroMode;tblZeroNum;tblUnit;tblfileDate;tblfileData_num];
    else
        tblHeader = [tblName;tblNo;tblrange;tblHighPass;tblLowPass;tblDigiFilter;tblCoeff_disp;tblOffset_disp;tblUnit;tblfileDate;tblfileData_num];
    end

    return
%--------------------------------------------------------------------------
%% checkFlag - �啪��,�����ރt���O��ǂݏo��
%    ����
%        f         ... �t�@�C���|�C���^�I�u�W�F�N�g
%        lngSeek   ... �w�b�_�T�C�Y
%        delta     ... �w�b�_�ȍ~�̓ǂݔ�΂���
%    �߂�l
%        parent    ... �啪�ރt���O
%        child     ... �����ރt���O
function [parent,child] = checkFlag(f,lngSeek,delta)

    fseek(f,lngSeek + delta,'bof');
    if feof(f) == 0                  % �I�[����
        parent = fread(f,1,'uchar');
        child  = fread(f,1,'uchar');
    else
        parent = 0;
        child  = 0;
    end


%--------------------------------------------------------------------------
%% makeSeek - �f�[�^�ǂݍ��݃o�C�g���A����уf�[�^�^��ǂݎ��B
%    ����
%        f          ... �t�@�C���|�C���^�I�u�W�F�N�g
%        parent     ... �啪�ރt���O
%        child      ... �����ރt���O
%    �߂�l
%        smlSeek    ... �f�[�^�ǂݍ��݃o�C�g��
%        strCharBuf ... �f�[�^�^
function [smlSeek,strCharBuf] = makeSeek(f,parent,child)

    flgSeek = checkflgSeek(parent,child);
    if flgSeek == 4
        smlSeek = fread(f,1,'uint32') - 2;
    elseif flgSeek == 8
        smlSeek = fread(f,1,'uint64') - 2;
    else
        smlSeek = fread(f,1,'uint16') - 2;
    end

    if (child == 61)
        strCharBuf = checkCharacter(fread(f,1,'int16'));
    elseif (child == 62)
        strCharBuf = checkCharacter(fread(f,1,'int16'));
    elseif (child == 63)
        strCharBuf = checkCharacter(fread(f,1,'int32'));
    elseif (child == 70)
        strCharBuf = checkCharacter(fread(f,1,'int16'));
    else
        fseek(f,1,'cof');
        pos = fread(f,1,'uchar');
        strCharBuf = checkCharacter(pos);
    end


%--------------------------------------------------------------------------
%% checkflgSeek - �Ǎ��݃o�C�g�ʂ��Z�o
%    ����
%        flgParent     ... �啪�ރt���O
%        flgChild      ... �����ރt���O
%    �߂�l
%        flgSeek       ... �Ή������o�C�g��
%
function flgSeek = checkflgSeek(flgParent,flgChild)
    global g_Ks2VerNum;

    if flgParent == 1
        if flgChild == 61               % CAN ID���
            %KS2��Ver��5�ȏ�Ȃ�{�f�B�o�C�g����4
            if g_Ks2VerNum >= 5
                flgSeek = 4;
            else
                flgSeek = 2;
            end
        elseif flgChild == 62           % CAN CH����(KS2)
            flgSeek = 4;
        elseif flgChild == 63           % CAN�ʐM����
            %KS2��Ver��5�ȏ�Ȃ�{�f�B�o�C�g����4
            if g_Ks2VerNum >= 5
                flgSeek = 4;
            else
                flgSeek = 2;
            end
        elseif flgChild == 70           % CAN CH����(KS2)
            flgSeek = 4;
        else
            flgSeek = 2;
        end
    elseif flgParent == 16
        if flgChild == 34           % MAX/MIN�f�[�^
            %KS2��Ver��5�ȏ�Ȃ�{�f�B�o�C�g����4
            if g_Ks2VerNum >= 5
                flgSeek = 4;
            else
                flgSeek = 2;
            end
        elseif flgChild == 35       % MAX/MIN�O��400�f�[�^(KS2)
                flgSeek = 4;
        elseif flgChild == 36       % MAX/MIN5�f�[�^��MAX/MIN�����|�C���g
            %KS2��Ver��5�ȏ�Ȃ�{�f�B�o�C�g����4
            if g_Ks2VerNum >= 5
                flgSeek = 4;
            else
                flgSeek = 2;
            end
        else
            flgSeek = 2;
        end
    elseif flgParent == 17
        if flgChild == 1            % �f�[�^��(ks1)
            flgSeek = 4;
        elseif flgChild == 2        % �f�[�^��(KS2)
            flgSeek = 8;
        end
    elseif flgParent == 18
        if flgChild == 25           % REC/PAUSE����(KS2)
            flgSeek = 8;
        elseif flgChild == 31
            flgSeek = 2;
        elseif flgChild == 32
            flgSeek = 2;
        else
            flgSeek = 4;
        end
    else
        flgSeek = 2;
    end

%--------------------------------------------------------------------------
%% printInfoAbove - �e����ǂݎ��B
%    ����
%        f          ... �t�@�C���|�C���^�I�u�W�F�N�g
%        tblInfo    ... �w�b�_�e������i�[�����\���̕ϐ�
%        flgParent  ... �啪�ރt���O
%        flgChild   ... �����ރt���O
%        smlSeek    ... �f�[�^�ǂݍ��݃o�C�g��
%        strCharBuf ... �f�[�^�^
%        tblCoeff   ... �Z���W��
%        tblOffset  ... �I�t�Z�b�g
%        delta      ... �ǂݔ�΂���
%        flgDebug   ... ���\���L���𑀍삷��t���O(0:��\��,1:�\��)
%        cell_data  ... CH�����ꎞ�ۊǔz��
%    �߂�l
%        delta      ... �ǂݔ�΂���
%        strSndBuf  ... �Z���W��,�I�t�Z�b�g,���ۂ̃f�[�^��
%        flgCoeff   ... �Z���W��,�I�t�Z�b�g,���ۂ̃f�[�^�̐U�蕪��
%        tblInfo    ... �ύX���������\���̕ϐ�


function [delta,strSndBuf,flgCoeff,tblInfo] = printInfoAbove(f,tblInfo,flgParent,flgChild,smlSeek, strCharBuf,tblCoeff,tblOffset,delta,flgDebug,cell_data)
    global g_Ks2VerNum;
    global g_CsvFormat;       %�w�b�_���̃t�H�[�}�b�g�̋����E�W����؂�ւ��܂�      0�F���^�C�v  1�F�W���^�C�v
    global g_IndexType;       %�f�[�^�̃C���f�b�N�X��؂�ւ��܂�                     0�F����      1�F�ԍ�
    global g_StartNumber;     %�f�[�^�̃C���f�b�N�X�̊J�n�ԍ���؂�ւ��܂�            0�F0�n�܂�   1�F1�n�܂�

    persistent CanIdMax;        %CAN-ID�̍ő吔
    persistent CanChMax;        %CAN-CH�̍ő吔
    persistent DoubleMax;       %Double�^�ő�l
    persistent DoubleMin;       %Double�^�ŏ��l
    persistent FloatMax;        %Float�^�ő�l
    persistent FloatMin;        %Float�^�ŏ��l
    persistent CanIdEndian;     %CAN-ID�G���f�B�A��
    persistent CanIdDataLen;    %CAN-ID�f�[�^��
    persistent CanIdChNum;      %CAN-ID��CH��
    persistent CanChBitShiftR;  %CAN-CH����p�E���r�b�g�V�t�g
    persistent CanChStBit;      %CAN-CH�X�^�[�g�r�b�g
    persistent CanChProcType;   %CAN-CH�f�[�^�^
    persistent CanChDataType;   %CAN-CH�f�[�^�^
    persistent CanChBitLen;     %CAN-CH�r�b�g��
    persistent CanChBitMask;    %CAN-CH�r�b�g�}�X�N
    persistent CanChSignedMask; %CAN-CHSigned�^�ϊ��}�X�N
    persistent CanChCoeffs;     %CAN-CH�Z���W��
    persistent CanChOffset;     %CAN-CH�I�t�Z�b�g
    persistent CanChData;       %CAN-CH�f�[�^(uint64)
    persistent SignedCanChData; %CAN-CH�f�[�^(int64)
    persistent DoubleCanChData; %CAN-CH�f�[�^(double)

%�ȉ��C���ڂ̌Ăяo�����ɍs��̏��������s��
    %CAN-ID���̍ő�l��5120
    if (isempty(CanIdMax))
        CanIdMax = 5120;
    end

    %CAN-CH���̍ő�l��10240
    if (isempty(CanChMax))
        CanChMax = 10240;
    end

    %Double�^�ő�l�̐ݒ�
    if (isempty(DoubleMax))
        DoubleMax = realmax('double');
    end

    %Double�^�ŏ��l�̐ݒ�
    if (isempty(DoubleMin))
        DoubleMin = realmin('double');
    end

    %Float�^�ő�l�̐ݒ�
    if (isempty(FloatMax))
        FloatMax = realmax('single');
    end

    %Float�^�ŏ��l�̐ݒ�
    if (isempty(FloatMin))
        FloatMin = realmin('single');
    end

    if (isempty(CanIdEndian))
        CanIdEndian = zeros(1,5120,'uint32');
    end
    if (isempty(CanIdDataLen))
        CanIdDataLen = zeros(1,5120,'int32');
    end
    if (isempty(CanIdChNum))
        CanIdChNum = zeros(1,5120,'uint32');
    end
    if (isempty(CanChBitShiftR))
        CanChBitShiftR = zeros(10240,1,'int32');
    end
    if (isempty(CanChStBit))
        CanChStBit = zeros(1,10240,'uint32');
    end
    if (isempty(CanChDataType))
        CanChDataType = zeros(1,10240,'uint32');
    end
    if (isempty(CanChProcType))
        CanChProcType = zeros(1,10240,'uint32');
    end
    if (isempty(CanChBitLen))
        CanChBitLen = zeros(10240,1,'uint32');
    end
    if (isempty(CanChBitMask))
        CanChBitMask = zeros(10240,1,'uint64');
    end
    if (isempty(CanChSignedMask))
        CanChSignedMask = zeros(1,10240,'uint64');
    end
    if (isempty(CanChCoeffs))
        CanChCoeffs = zeros(1,10240,'double');
    end
    if (isempty(CanChOffset))
        CanChOffset = zeros(1,10240,'double');
    end
    if (isempty(CanChData))
        CanChData = zeros(64*32,1,'uint64');
    end
    if (isempty(SignedCanChData))
        SignedCanChData = zeros(64*32,1,'int64');
    end
    if (isempty(DoubleCanChData))
        DoubleCanChData = zeros(64*32,1,'double');
    end

    strTmpBuf = [];
    flgCoeff  = 0;
    flgDelta  = 2;

    if flgParent == 1   % �ϒ��w�b�_���S�̏��
        %���ږ�
        if flgChild == 46
            tblInfo.CoefDFlag = 0;

            if g_Ks2VerNum <= 3
                StrBufItem = zeros(1,10,'uint8');

                %15���ږڂ܂Ń|�C���^���ړ�
                fseek(f,252,'cof');

                %�擪��10������ǂݍ���
                for k = 1:10
                    StrBufItem(k) = fread(f,1,'uint8');
                end

                %������֕ϊ�
                StrBuf = char(StrBufItem);

                %������CAN_DOUBLE�Ȃ�Z���W���ƃI�t�Z�b�g��Double�^
                tblInfo.CoefDFlag = strcmp(StrBuf,'CAN_DOUBLE');
            end

        %CAN-ID���
        elseif flgChild == 61
            tblInfo.CanChNum = 0;

            if g_Ks2VerNum >= 5
                %KS2��Ver��5�ȏ�Ȃ�{�f�B�o�C�g����4
                flgDelta = 4;
            else
                flgDelta = 2;
            end

            if(isnan(tblInfo.CAN) == 0)
                %CAN-ID�����ǂݍ���
                for k = 1:tblInfo.CAN

                    %ID�ԍ�
                    tblInfo.CanId(k).IdNo = fread(f,1,'int16');

                    %1ID�ӂ��CH��
                    tblInfo.CanId(k).ChNum = fread(f,1,'int16');

                    %�t�H�[�}�b�g(0�F�W��  1�F�g��)
                    tblInfo.CanId(k).Format = fread(f,1,'int16');

                    %�t���[��ID
                    tblInfo.CanId(k).FrameIdNo = fread(f,1,'int32');

                    %ID��
                    tblInfo.CanId(k).IdSize = fread(f,1,'int16');

                    %�G���f�B�A��(0�FLittle  1�FBig)
                    tblInfo.CanId(k).Endian = fread(f,1,'int16');
                    fseek(f,40,'cof');

                    %CAN-CH���̐ݒ�
                    CanIdChNum(k) = tblInfo.CanId(k).ChNum;

                    %CAN-ID���̐ݒ�
                    CanIdDataLen(k) = tblInfo.CanId(k).IdSize;

                    %�G���f�B�A����Little�Ȃ�1�CBig�Ȃ�2��ݒ�
                    if(tblInfo.CanId(k).Endian == 0)
                       CanIdEndian(k) = 1;
                    else
                       CanIdEndian(k) = 2;
                    end

                    %CAN-CH���̍X�V
                    tblInfo.CanChNum = tblInfo.CanChNum + tblInfo.CanId(k).ChNum;
                end
            end

        %CAN-CH����
        elseif flgChild == 62
            flgDelta = 4;

            %CAN-CH�����̓ǂݍ���
            for k = 1:tblInfo.CanChNum

                %�X�^�[�g�r�b�g�̓ǂݍ���
                CanChStBit(k) = fread(f,1,'int16=>uint32');

                %�r�b�g���̓ǂݍ���
                CanChBitLen(k) = fread(f,1,'int16=>uint32');

                %�f�[�^�^�̓ǂݍ���
                CanChDataType(k) = fread(f,1,'int16=>uint32');

                %6�o�C�g�ǂݔ�΂�
                fseek(f,6,'cof');

                %�P�ʕ�����̓ǂݍ���
                tblInfo.CanCh(k).UnitStr = fread(f,10,'uchar');

                %CAN-DOUBLE�����ڂɏ�����Ă�����Z���W���ƃI�t�Z�b�g��Double�^
                if (tblInfo.CoefDFlag == 0)

                    %�Z���W���̓ǂݍ��� Ver0102
                    tblInfo.CanCh(k).Coeffs = str2double(sprintf('%.7G', fread(f,1,'float')));

                    %�I�t�Z�b�g�̓ǂݍ��� Ver0102
                    tblInfo.CanCh(k).Offset = str2double(sprintf('%.7G', fread(f,1,'float')));

                    %CH���̂̓ǂݍ���
                    tblInfo.CanCh(k).ChName = fread(f,40,'uchar');

                %�Z���W���ƃI�t�Z�b�g��Dobule�^�t���O��ON�Ȃ�
                else
                    %Float�^�̍Z���W���ƃI�t�Z�b�g�͓ǂݔ�΂�
                    fseek(f,8,'cof');

                    %CH���̂�20�o�C�g
                    tblInfo.CanCh(k).ChName = fread(f,20,'uchar');

                    %�\��4�o�C�g��ǂݔ�΂�
                    fseek(f,4,'cof');

                    %�Z���W���ƃI�t�Z�b�g�̓ǂݍ���
                    tblInfo.CanCh(k).Coeffs = fread(f,1,'double');
                    tblInfo.CanCh(k).Offset = fread(f,1,'double');
                end

                %Signed�^�ϊ��p�}�X�N�s��̏�����
                CanChSignedMask(k) = cast(hex2dec('FFFFFFFFFFFFFFFF'), 'uint64');

                %CAN-CH�ϊ��p�E���ւ̃r�b�g�V�t�g�s��̐ݒ�
                CanChBitShiftR(k) = cast(CanChStBit(k),'int32');
                CanChBitShiftR(k) = CanChBitShiftR(k) * -1;

                %�}�X�N�r�b�g��Signed�}�X�N�r�b�g�̐ݒ�
                for kk = 1:CanChBitLen(k)
                    CanChBitMask(k) = bitset(CanChBitMask(k), kk);
                    CanChSignedMask(k) = bitset(CanChSignedMask(k), kk, 0);
                end

                %�Z���W���̐ݒ�
                CanChCoeffs(k) = tblInfo.CanCh(k).Coeffs;

                %�I�t�Z�b�g�̐ݒ�
                CanChOffset(k) = tblInfo.CanCh(k).Offset;
            end

        %CAN�ʐM����
        elseif flgChild == 63
            if g_Ks2VerNum >= 5
                %KS2��Ver��5�ȏ�Ȃ�{�f�B�o�C�g����4
                flgDelta = 4;
            else
                flgDelta = 2;
            end
        %CAN-CH����
        elseif flgChild == 70
            flgDelta = 4;

            %CAN-CH�����̓ǂݍ���
            for k = 1:tblInfo.CanChNum

                %�X�^�[�g�r�b�g�̓ǂݍ���
                CanChStBit(k) = fread(f,1,'int16=>uint32');

                %�r�b�g���̓ǂݍ���
                CanChBitLen(k) = fread(f,1,'int16=>uint32');

                %�f�[�^�^�̓ǂݍ���
                CanChDataType(k) = fread(f,1,'int16=>uint32');

                %6�o�C�g�ǂݔ�΂�
                fseek(f,6,'cof');

                %�P�ʕ�����̓ǂݍ���
                tblInfo.CanCh(k).UnitStr = fread(f,10,'uchar');

                %�Z���W���̓ǂݍ���
                tblInfo.CanCh(k).Coeffs = fread(f,1,'double');

                %�I�t�Z�b�g�̓ǂݍ���
                tblInfo.CanCh(k).Offset = fread(f,1,'double');

                %�����_�����̓ǂݍ���
                tblInfo.CanCh(k).Digit = fread(f,1,'int16');

                %CH���̂̓ǂݍ���
                tblInfo.CanCh(k).ChName = fread(f,40,'uchar');

                %Signed�^�ϊ��p�}�X�N�s��̏�����
                CanChSignedMask(k) = cast(hex2dec('FFFFFFFFFFFFFFFF'), 'uint64');

                %CAN-CH�ϊ��p�E���ւ̃r�b�g�V�t�g�s��̐ݒ�
                CanChBitShiftR(k) = cast(CanChStBit(k),'int32');
                CanChBitShiftR(k) = CanChBitShiftR(k) * -1;

                %�}�X�N�r�b�g��Signed�}�X�N�r�b�g�̐ݒ�
                for kk = 1:CanChBitLen(k)
                    CanChBitMask(k) = bitset(CanChBitMask(k), kk);
                    CanChSignedMask(k) = bitset(CanChSignedMask(k), kk, 0);
                end

                %�Z���W���̐ݒ�
                CanChCoeffs(k) = tblInfo.CanCh(k).Coeffs;

                %�I�t�Z�b�g�̐ݒ�
                CanChOffset(k) = tblInfo.CanCh(k).Offset;
            end
        end

        strSndBuf = strTmpBuf;
    elseif flgParent == 2 % �ϒ��w�b�_���ʏ��
        ch = tblInfo.ch;
        chAll = tblInfo.chAll;
        array = zeros(1,ch,'single');

        j = 1;
        if (flgChild == 2) || (flgChild == 48)    % �L���`���l���ԍ�
            flgCoeff = 3;
            checkArray = zeros(1,ch,'single');
            for i = 1:ch
                temp1 = fread(f,1,'int16');
                if flgChild == 2         % KS1�̏ꍇ(�L��CH�̗L����0/1�̏�񂾂�)
                    checkArray(i) = temp1; % �`�F�b�N�p�̔z��
                    if temp1 > 0
                        temp1 = i;
                        if g_CsvFormat == 0
                            strTmpBuf = makeChStrings(j,strTmpBuf,temp1,'[CH No],CH-',',CH-');
                        else
                            if g_IndexType == 0
                                strTmpBuf = makeChStrings(j,strTmpBuf,temp1,'[Time(sec)],CH-',',CH-');
                            else
                                strTmpBuf = makeChStrings(j,strTmpBuf,temp1,'[No.],CH-',',CH-');
                            end
                        end
                        j = j + 1;
                    end
                else       % KS2�̏ꍇ
                    if g_CsvFormat == 0
                        strTmpBuf = makeChStrings(i,strTmpBuf,temp1,'[CH No],CH-',',CH-');
                    else
                        if g_IndexType == 0
                            strTmpBuf = makeChStrings(i,strTmpBuf,temp1,'[Time(sec)],CH-',',CH-');
                        else
                            strTmpBuf = makeChStrings(i,strTmpBuf,temp1,'[No.],CH-',',CH-');
                        end
                    end
                end
            end
            tblInfo.checkArray = checkArray;

            if(mod(temp1,16)==0)
                tblInfo.CanChStNo = temp1 + 1;
            else
                tblInfo.CanChStNo = (floor(temp1/16)+1)*16+1;
            end
            j = 1;
            for i=ch+1:chAll
                strTmpBuf = [strTmpBuf,',DI-',num2str(j)];
                j = j + 1;
            end
            strSndBuf = split_str(strTmpBuf,',');

%(KS2 ver01.01�`03)�̍H�w�l�ϊ��W��A��B�̒��o(float�^)
        elseif (flgChild == 3) || (flgChild == 4)        % �H�w�l�ϊ��W��A,B
            for i = 1:ch
                %Ver0103 float�^�̓ǂݍ��ݏ����̕ύX
                array(i) = str2double(sprintf('%.7G', fread(f,1,'float')));
            end
            if flgChild == 4
                flgCoeff = 2;
            else
                flgCoeff = 1;
            end
            strSndBuf = array;

%KS2 ver01.04�̍H�w�l�ϊ��W��A��B�̒��o(double�^)
        elseif (flgChild == 67) || (flgChild == 68)
            double_array =zeros(1,8,'double');
            for i = 1:ch
                double_array(i) = fread(f,1,'double');
            end
            if flgChild == 68
                flgCoeff = 2;
            else
                flgCoeff = 1;
            end
            strSndBuf = double_array;
            clear double_array

%�P�ʕ�����̒��o
        elseif flgChild == 5                            %�P��
            int8_array =zeros(1,10,'uint32');
            flgCoeff = 5;
            for i = 1:ch
                for ii = 1:10
                    int8_array(ii) = fread(f,1,'uchar');
                end

                cell_data(i+1)={''};
                if(isempty(nonzeros(int8_array))==0)
                    cell_data(i+1) = {native2unicode(nonzeros(int8_array)')};
                end
            end
            %cell_data(1)={'[�P��]'};
            cell_data(1)={'[Unit]'};
            strSndBuf = cell_data;
            clear int8_array

%�Z���W���C�I�t�Z�b�g�̒��o(ver01.01�`03)
        elseif (flgChild == 8) || (flgChild ==12)            %�Z���W���C�I�t�Z�b�g
            for i = 1:ch
                %Ver0103 float�^�̓ǂݍ��ݏ����̕ύX
                cell_data(1,1+i) = {str2double(sprintf('%.7G', fread(f,1,'float')))};
            end
            if flgChild == 8
                flgCoeff = 7;
                %cell_data(1)={'[�Z���W��]'};
                cell_data(1)={'[Calibration Coeff.]'};
            else
                flgCoeff = 8;
                %cell_data(1)={'[�I�t�Z�b�g]'};
                cell_data(1)={'[Offset]'};
            end
            strSndBuf = cell_data;

%�Z���W���C�I�t�Z�b�g�̒��o(ver01.04�ȍ~)
        elseif (flgChild == 69) || (flgChild ==70)
            for i = 1:ch
                cell_data(1,1+i) = {fread(f,1,'double')};
            end
            if flgChild == 69
                flgCoeff = 7;
                %cell_data(1)={'[�Z���W��]'};
                cell_data(1)={'[Calibration Coeff.]'};
            else
                flgCoeff = 8;
                %cell_data(1)={'[�I�t�Z�b�g]'};
                cell_data(1)={'[Offset]'};
            end
            strSndBuf = cell_data;
%�`�����l�����̂̒��o
        elseif flgChild == 49                               %�`�����l������
            int8_array =zeros(1,40,'uint32');
            flgCoeff = 4;
            for i = 1:ch
                for ii = 1:40
                    int8_array(ii) = fread(f,1,'uchar');
                end

                cell_data(i+1)={''};
                if(isempty(nonzeros(int8_array))==0)
                    cell_data(i+1) = {native2unicode(nonzeros(int8_array)')};
                end
            end
            %cell_data(1)={'[CH����]'};
            cell_data(1)={'[CH Name]'};
            strSndBuf = cell_data;
            clear int8_array
%�����W������̒��o
        elseif flgChild == 51
            flgCoeff = 6;
            int8_array =zeros(1,20,'uint32');
            %CSV���̏ꍇ
            if g_CsvFormat == 0
                for i = 1:ch
                    for ii = 1:20
                        int8_array(ii) = fread(f,1,'uchar');
                    end
                    int8_array=nonzeros(int8_array)';
                    char_array=zeros(size(int8_array,2),1,'uint32');

                        for ii = 1:size(int8_array,2)
                            if( (48<=int8_array(ii) && int8_array(ii)<=57) || int8_array(ii)==46)   %0�`9�ƃs���I�h(�����_)
                                char_array(ii)=int8_array(ii);
                            elseif(int8_array(ii)==32)

                            elseif(int8_array(ii)==75 || int8_array(ii)==107)   %k�CK(�L��)�̎�
                                k_flag=1000;
                                break;
                            elseif(int8_array(ii)==79 || int8_array(ii)==111)   %o�CO(OFF)�̎�
                                char_array(ii)=0;
                                break;
                            else
                                k_flag=1;
                                break;
                            end
                        end
                        cell_data(i+1)={0};
                        if(isempty(nonzeros(char_array))==0)
                            cell_data(i+1) = {single(str2double(native2unicode(nonzeros(char_array)'))*k_flag)'};
                        end
                end
                %cell_data(1)={'[�����W]'};
                cell_data(1)={'[Range]'};
                clear char_array
            %CSV�W���̏ꍇ
            else
                for i = 1:ch
                    for ii = 1:20
                        int8_array(ii) = fread(f,1,'uchar');
                    end

                    cell_data(i+1)={''};
                    if(isempty(nonzeros(int8_array))==0)
                        cell_data(i+1) = {native2unicode(nonzeros(int8_array)')};
                    end
                end
                %cell_data(1)={'[�����W]'};
                cell_data(1)={'[Range]'};
            end

            strSndBuf = cell_data;
            clear int8_array
%���[�p�X�t�B���^������̒��o
        elseif flgChild == 53
            flgCoeff = 9;
            int8_array =zeros(1,20,'uint32');

            for i = 1:ch
                for ii = 1:20
                    int8_array(ii) = fread(f,1,'uchar');
                end

                cell_data(i+1)={''};
                if(isempty(nonzeros(int8_array))==0)
                    cell_data(i+1) = {native2unicode(nonzeros(int8_array)')};
                end
            end
            %cell_data(1)={'[���[�p�X�t�B���^]'};
            cell_data(1)={'[Low Pass Filter]'};
            strSndBuf = cell_data;
            clear int8_array
%�n�C�p�X�t�B���^������̒��o
        elseif flgChild == 54
            flgCoeff = 10;
            int8_array =zeros(1,20,'uint32');

            for i = 1:ch
                for ii = 1:20
                    int8_array(ii) = fread(f,1,'uchar');
                end

                cell_data(i+1)={''};
                if(isempty(nonzeros(int8_array))==0)
                    cell_data(i+1) = {native2unicode(nonzeros(int8_array)')};
                end
            end
            %cell_data(1)={'[�n�C�p�X�t�B���^]'};
            cell_data(1)={'[High Pass Filter]'};
            strSndBuf = cell_data;
            clear int8_array
%�f�W�^���t�B���^������̒��o
        elseif flgChild == 71
            flgCoeff = 11;
            int8_array =zeros(1,40,'uint32');

            for i = 1:ch
                for ii = 1:40
                    int8_array(ii) = fread(f,1,'uchar');
                end

                cell_data(i+1)={''};
                if(isempty(nonzeros(int8_array))==0)
                    cell_data(i+1) = {native2unicode(nonzeros(int8_array)')};
                end
            end
            %cell_data(1)={'[�f�W�^���t�B���^]'};
            cell_data(1)={'[Digital Filter]'};
            strSndBuf = cell_data;
            clear int8_array
%CH���[�h�̒��o
        elseif flgChild == 56
            flgCoeff = 12;
            int8_array =zeros(1,40,'uint32');

            for i = 1:ch
                for ii = 1:40
                    int8_array(ii) = fread(f,1,'uchar');
                end

                cell_data(i+1)={''};
                if(isempty(nonzeros(int8_array))==0)
                    cell_data(i+1) = {native2unicode(nonzeros(int8_array)')};
                end
            end
            %cell_data(1)={'[CH���[�h]'};
            cell_data(1)={'[CH Mode]'};
            strSndBuf = cell_data;
            clear int8_array
%�Q�[�W��
        elseif flgChild == 57
            flgCoeff = 13;
            int8_array =zeros(1,20,'uint32');

            for i = 1:ch
                for ii = 1:20
                    int8_array(ii) = fread(f,1,'uchar');
                end

                cell_data(i+1)={''};
                if(isempty(nonzeros(int8_array))==0)
                    cell_data(i+1) = {native2unicode(nonzeros(int8_array)')};
                end
            end
            %cell_data(1)={'[�Q�[�W��]'};
            cell_data(1)={'[Guuji Rate]'};
            strSndBuf = cell_data;
            clear int8_array
%ZERO�CZERO�l
        elseif flgChild == 72
            flgCoeff = 14;
            int8_array =zeros(1,20,'uint32');

            for i = 1:ch
                for ii = 1:20
                    int8_array(ii) = fread(f,1,'uchar');
                end

                if(isempty(nonzeros(int8_array))==0)
                    StrZeroNum = {native2unicode(nonzeros(int8_array)')};
                end
                for ii = 1:20
                    int8_array(ii) = fread(f,1,'uchar');
                end

                if(isempty(nonzeros(int8_array))==0)
                    StrZeroMode = {native2unicode(nonzeros(int8_array)')};
                end

                cell_data(i+1)={''};
                %�������₷���悤�ɁC','�ŋ�؂�
                cell_data(i+1) = strcat(StrZeroNum,',',StrZeroMode);
            end
            cell_data(1)={'[ZERO]'};
            strSndBuf = cell_data;
            clear int8_array
        else
            strSndBuf = 0;
        end
    elseif flgParent == 16 % �f�[�^���f�[�^�w�b�_��

%����J�n�����̒��o
%csv�f�[�^�� cell(1,1)=20xx/xx/xx�Ccell(1,2)=yy:yy:yy�ŕ\�����Ă���
%�o�C�i���́C20xxxxxxyyyyyy�ł��邽�߁C��؂�(/�C:)��ǉ�����

        if  flgChild == 3 % ����J�n����
            flgCoeff = 9;
            header_array = fread(f,16,'uchar');
            for n=1:size(header_array,1)
                if(48>header_array(end,1) || 57<header_array(end,1))
                    header_array(end,:)=[];
                else
                    break;
                end
            end
            if(isempty(header_array)==0)
                date_1=zeros(1,10);
                date_2=zeros(1,8);
                date_1(5)='/';  date_1(8)='/';
                date_2(3)=':';  date_2(6)=':';
                date_1(1,1:4)=header_array(1:4,1);  date_1(1,6:7)=header_array(5:6,1);  date_1(1,9:10)=header_array(7:8,1);
                date_2(1,1:2)=header_array(9:10,1);  date_2(1,4:5)=header_array(11:12,1);  date_2(1,7:8)=header_array(13:14,1);
                %cell_data(1) = {'[��������]'};
                cell_data(1) = {'[Test Date]'};
                cell_data(2)={native2unicode(date_1)};
                cell_data(3)={native2unicode(date_2)};
            end

            strSndBuf = cell_data;
            clear data_1;
            clear data_2;
            clear header_array;

%�f�[�^��/ch�̒��o
        elseif flgChild == 30 % 1ch������̃f�[�^��
            flgCoeff = 10;
            ch_data=zeros(1,1,'double');
            header_array = fread(f,8,'uchar');

            for n=1:size(header_array,1)
               haeder_array(n)=native2unicode(header_array(size(header_array,1)-n+1));  %header_array��16�i��
               ch_data=ch_data+double(floor(header_array(n)/16)*16^(2*(n-1)+1)+mod(header_array(n),16)*16^(2*(n-1)));   %16�i����10�i���ɕϊ�
            end

            if(isempty(header_array)==0)
                %cell_data(1) = {'[�W�^�f�[�^��/CH]'};
                cell_data(1) = {'[Number of Samples/CH]'};
                cell_data(2)={ch_data};
            end
            strSndBuf = cell_data;
            clear header_array;

        elseif flgChild == 34       % MAX/MIN�f�[�^
            %KS2��Ver��5�ȏ�Ȃ�{�f�B�o�C�g����4
            if g_Ks2VerNum >= 5       % KS201.05�ȏ�̏ꍇ�C�{�f�B���o�C�g����4�o�C�g
                flgDelta = 4;
            else
                flgDelta = 2;
            end
            strSndBuf = 0;
        elseif flgChild == 35       % MAX/MIN�O��400�f�[�^
            flgDelta = 4;
            strSndBuf = 0;
        elseif flgChild == 36       % MAX/MIN�����|�C���g
            %KS2��Ver��5�ȏ�Ȃ�{�f�B�o�C�g����4
            if g_Ks2VerNum >= 5       % KS201.05�ȏ�̏ꍇ�C�{�f�B���o�C�g����4�o�C�g
                flgDelta = 4;
            else
                flgDelta = 2;
            end
            strSndBuf = 0;
        else
            flgDelta = 2;
            strSndBuf = 0;
        end
    elseif flgParent == 17 % ���ۂ̃f�[�^����
        if flgChild == 1
            flgDelta = 4;
        else
            flgDelta = 8;
        end

        lngByte   = checkByteSize(strCharBuf);
        % CAN�̗L���ŁA�f�[�^�̍������ω�
        if (isnan(tblInfo.CAN) == 1)
            lngDiv    = tblInfo.chAll * lngByte;
            lngHeight = smlSeek / lngDiv;
        else
            lngDiv = (tblInfo.chAll * lngByte) + (tblInfo.CAN * 8);
            lngHeight = smlSeek / lngDiv;
        end

        chAll = tblInfo.chAll + 1;
        ch = tblInfo.ch + 1;
        tblInfo.LngHeight = lngHeight;

        if flgDebug == 1
            %makeDispMessage(31,tblInfo);
        end
        try % �G���[�g���b�v
            array = zeros(lngHeight,chAll+tblInfo.CanChNum,'double');
            h = waitbar(0,makeDispMessage(32,tblInfo));

            if strcmp(tblInfo.machine,tblInfo.CmpMachine1) || strcmp(tblInfo.machine,tblInfo.CmpMachine2);
                if(tblInfo.chAll ~= 0)
                    val(tblInfo.chAll) =zeros;
                end
                tblInfo.ChNum =tblInfo.chAll;
            else
                if(tblInfo.ch ~= 0)
                    val(tblInfo.ch) =zeros;
                end
                tblInfo.ChNum =tblInfo.ch;
            end
            for i = 1:lngHeight
                %�f�[�^�����o��
                if g_IndexType == 0
                    if(g_StartNumber == 0)
                        array(i,1) = (i-1) / tblInfo.Hz;
                    else
                        array(i,1) = i / tblInfo.Hz;
                    end
                else
                    if(g_StartNumber == 0)
                        array(i,1) = (i-1);
                    else
                        array(i,1) = i;
                    end
                end
                valLabel = 'float32';

                if(strcmp(strCharBuf,'Int'))
                    valLabel = 'int16';
                elseif(strcmp(strCharBuf,'Long')) %ver1.01
                    valLabel = 'int32';
                elseif(strcmp(strCharBuf,'Double'))
                    valLabel = 'double';
                end

                if strcmp(valLabel, 'float32')
                    for jj = 1:tblInfo.ChNum
                       val(jj) = str2double(sprintf('%.7G', fread(f,1,valLabel)));
                    end
                else
                    val = fread(f,tblInfo.ChNum,valLabel)';
                end

                %�A�i���OCH�f�[�^�̂ݓǂݍ��� Ver0103
                array(i,2:ch) = tblCoeff(1:ch-1).* val(1:ch-1) + tblOffset(1:ch-1);

                %CAN�f�[�^�ǂ݂���
                %CAN�̐ݒ肪�����ꍇ
                SumCanChNum = 0;
                if (isnan(tblInfo.CAN) == 1)
                else
                    %�W�^CAN-ID����1�ł���������
                    if tblInfo.CAN ~= 0

                        %CAN�f�[�^�����p�̃f�[�^�^�ۑ��z��̃R�s�[ Ver0103
                        CanChProcType = CanChDataType;

                        %CAN-ID���̐ݒ�
                        CanIdNum = tblInfo.CAN;

                        %CAN-ID�f�[�^�̓ǂݍ���
                        CanIdData(1,1:CanIdNum) = fread(f,CanIdNum,'uint64=>uint64');

                        %�r�b�N�G���f�B�A���p�Ɏ��O�Ƀ��g���G���f�B�A���ɕϊ������z���p�ӂ���
                        CanIdData(2,1:CanIdNum) = swapbytes(CanIdData(1,1:CanIdNum));
                        CanIdData(2,1:CanIdNum) = bitshift(CanIdData(2,1:CanIdNum),-8*(8-CanIdDataLen(1:CanIdNum)));

                        %CAN-ID�f�[�^���Y������CAN-CH�f�[�^�փR�s�[����(�G���f�B�A�������g���Ȃ�1�s�ځC�r�b�N�Ȃ�2�s�ڂ�ǂݍ���)
                        CanChNum = 1;
                        for k = 1:CanIdNum
                            SumCanChNum = (CanChNum+CanIdChNum(k)-1);
                            CanChData(CanChNum:SumCanChNum) = CanIdData(CanIdEndian(k),k);
                            CanChNum = SumCanChNum+1;
                        end

                        %�s�K�v�ȃr�b�g��폜�̂��߉E���փV�t�g
                        CanChData(1:SumCanChNum) = bitshift(CanChData(1:SumCanChNum),CanChBitShiftR(1:SumCanChNum));

                        %�K�v�ȃr�b�g�����c�����߃}�X�N
                        CanChData(1:SumCanChNum) = bitand(CanChData(1:SumCanChNum), CanChBitMask(1:SumCanChNum));

                        %CAN-CH�����f�[�^����
                        for kk = 1:SumCanChNum

                            %Signed�^�̏ꍇ
                            if (CanChDataType(kk) == 0)

                                %�L���r�b�g���̍Ōオ1��������C��������
                                if( bitget(CanChData(kk), CanChBitLen(kk)))

                                    %Signed�}�X�N�ɂ�蕉�̃f�[�^�ɕϊ�
                                    SignedCanChData(kk) = typecast(bitor(bitset(CanChData(kk),CanChBitLen(kk)+1), CanChSignedMask(kk)),'int64');

                                    %�f�[�^�^�C�v�^�������p�ɕύX
                                    CanChProcType(kk) = 4;
                                else
                                end
                            %UnSigned�^�̏ꍇ
                            elseif(CanChDataType(kk) == 1)
                            %Float�^�̏ꍇ
                            elseif(CanChDataType(kk) == 2)

                                %uint64�^����Float�ɓǂݍ��݌^�̕ύX
                                FloatCanData = typecast(CanChData(kk),'single');

                                %Float�^�͈̔͂𒴂��Ă�����f�[�^��0�Ƃ���
                                if( abs(FloatCanData(1,1))<FloatMin || abs(FloatCanData(1,1))>FloatMax )
                                    FloatCanData(1,1) = 0;
                                end

                                %(1,2)�͂��݃f�[�^�C(1,1)��Float�^�ɕϊ����ꂽ�f�[�^
                                %Ver0103 float�^�f�[�^�̗L��
                                DoubleCanChData(kk) =  str2double(sprintf('%.7G', FloatCanData(1,1)));

                                %�f�[�^�^�C�v�^�������p�ɕύX
                                CanChProcType(kk) = 3;
                            %Double�^�̏ꍇ
                            else

                                %uint64�^����Double�ɓǂݍ��݌^�̕ύX
                                DoubleCanData = typecast(CanChData(kk),'double');

                                %Double�^�͈̔͂𒴂��Ă�����f�[�^��0�Ƃ���
                                if( abs(DoubleCanData(1,1))<DoubleMin || abs(DoubleCanData(1,1))>DoubleMax )
                                    DoubleCanData = 0;
                                end

                                %Double�^�f�[�^�̐ݒ�
                                DoubleCanChData(kk) = DoubleCanData;
                            end
                        end

                        %Double�^�̃f�[�^�Ƃ��Č^�ϊ����Ȃ���ݒ�
                        array(i,ch+1:ch+SumCanChNum)= ...
                            (CanChProcType(1:SumCanChNum) == 0 | CanChProcType(1:SumCanChNum) == 1).*cast(CanChData(1:SumCanChNum),'double')'...
                            + (CanChProcType(1:SumCanChNum) == 3).*DoubleCanChData(1:SumCanChNum)'...
                            + (CanChProcType(1:SumCanChNum) == 4).*cast(SignedCanChData(1:SumCanChNum),'double')';

                        %�Z���W���ƃI�t�Z�b�g�ɂ�蕨���ʂɕϊ�
                        array(i,ch+1:ch+SumCanChNum) = array(i,ch+1:ch+SumCanChNum).* CanChCoeffs(1:SumCanChNum) + CanChOffset(1:SumCanChNum);
                    end
                end

                %�f�W�^��CH�f�[�^�̓ǂݍ���
                for j = 1:(chAll - ch)
                    if strcmp(strCharBuf,'Int')
                        array(i,ch+SumCanChNum+j) = fread(f,1,'uint16');
                    else
                        array(i,ch+SumCanChNum+j) = fread(f,1,valLabel);
                    end
                end
                if fix(rem(i,100)) < 1
                    waitbar(i / lngHeight);
                end
            end % i
            close(h);clear h;
            flgCoeff = 3;
            strSndBuf = array;

            clear CanIdMax;        %CAN-ID�̍ő吔
            clear CanChMax;        %CAN-CH�̍ő吔
            clear DoubleMax;       %Double�^�ő�l
            clear DoubleMin;       %Double�^�ŏ��l
            clear FloatMax;        %Float�^�ő�l
            clear FloatMin;        %Float�^�ŏ��l
            clear CanIdEndian;     %CAN-ID�G���f�B�A��
            clear CanIdDataLen;    %CAN-ID�f�[�^��
            clear CanIdChNum;      %CAN-ID��CH��
            clear CanChBitShiftR;  %CAN-CH����p�E���r�b�g�V�t�g
            clear CanChStBit;      %CAN-CH�X�^�[�g�r�b�g
            clear CanChDataType;   %CAN-CH�f�[�^�^
            clear CanChBitLen;     %CAN-CH�r�b�g��
            clear CanChBitMask;    %CAN-CH�r�b�g�}�X�N
            clear CanChSignedMask; %CAN-CHSigned�^�ϊ��}�X�N
            clear CanChCoeffs;     %CAN-CH�Z���W��
            clear CanChOffset;     %CAN-CH�I�t�Z�b�g
            clear CanChData;       %CAN-CH�f�[�^(uint64)
            clear SignedCanChData; %CAN-CH�f�[�^(int64)
            clear FloatCanChData;  %CAN-CH�f�[�^(float)
            clear DoubleCanChData; %CAN-CH�f�[�^(double)
        catch
            if tblInfo.MATLAB_Ver >= 6.5
                err = lasterror;
                tblInfo.err.message = err.message;
                tblInfo.err.identifier = err.identifier;
                tblInfo.err.stack = err.stack;
            else
                [message,msgid] = lasterr;
                tblInfo.err.message = message;
                tblInfo.err.identifier = msgid;
                disp(lasterr);
            end
            strSndBuf = tblInfo;
            % �������G���[����
            [~, num] = split_str(err.message, 'MEMORY');
            if num > 1
                flgCoeff = 999;
            else
                flgCoeff = 111;
            end
            return
        end
    elseif flgParent== 18
        if flgChild == 25
            flgDelta = 8;
        else
            flgDelta = 4;
        end
        strSndBuf = 0;
    else
        strSndBuf = 0;
    end

    if flgDelta ==  4
        delta = delta + tblInfo.InfoSeek + 2 + smlSeek;      %  8 = 1 + 1 + 4(body) + 2
    elseif flgDelta == 8
        delta = delta + tblInfo.InfoSeek + 6 + smlSeek;      % 12 = 1 + 1 + 8(body) + 2
    else
        delta = delta + tblInfo.InfoSeek + smlSeek;          %  6 = 1 + 1 + 2(body) + 2
    end

%--------------------------------------------------------------------------
%% makeChStrings - �J���}�ŋ�؂�ꂽ������𐶐��B
%    ����
%       pos       ... �����ʒu
%       strRcvBuf ... �A��������
%       array     ... �Ώە�����
%       headStr   ... �擪�ɂ��镶����
%       midStr    ... ����ȍ~�̋�؂蕶����
%    �߂�l
%       strSndBuf ... �A������������
function strSndBuf = makeChStrings(pos,strRcvBuf,array,headStr,midStr)
    if pos == 1
        strSndBuf = [headStr,num2str(array)];
    else
        strSndBuf = [strRcvBuf,midStr,num2str(array)];
    end


%--------------------------------------------------------------------------
%% checkCharacter - �w�肳�ꂽ�f�[�^�^��Ԃ��B
%    ����
%       check     ... �`�F�b�N�p�f�[�^
%    �߂�l
%       strSndBuf ... �Y���̃f�[�^�^�C�v
function strSndBuf = checkCharacter(check)

    switch check
     case 0
      strSndBuf = 'Char';
     case 1
      strSndBuf = 'Int';
     case 2
      strSndBuf = 'Long';
     case 3
      strSndBuf = 'Float';
     case 4
      strSndBuf = 'Double';
     case 5
      strSndBuf = 'UChar';
     case 6
      strSndBuf = 'UShort';
     case 7
      strSndBuf = 'ULong';
     case 8
      strSndBuf = 'Int64';
     case 9
      strSndBuf = 'UInt64';
     otherwise
      strSndBuf = check;
    end


%--------------------------------------------------------------------------
%% checkByteSize - �w�肳�ꂽ�f�[�^�^�̃o�C�g����Ԃ��B
%    ����
%       check     ... �`�F�b�N�p�f�[�^
%    �߂�l
%       strSndBuf ... �Y���̃o�C�g�^�C�v
function strSndBuf = checkByteSize(check)

    if strcmp(check,'Char') || strcmp(check,'UChar')
        strSndBuf = 1;
    elseif strcmp(check,'Int') || strcmp(check,'UShort')
        strSndBuf = 2;
    elseif strcmp(check,'Long') || strcmp(check,'ULong') || strcmp(check,'Float') %| strcmp(check,'Double')
        strSndBuf = 4;
    else
        strSndBuf = 8;
    end

%------------------------------------------------------------
%% split_str():
%
% usage :
%    split_str(str,Delm);
%    tbls = split_str(str,Delm);
%    [tbls,num] = split_str(str,Delm);
%
% arguments:
%    str  ... original Character strings
%    Delm ... delimiter
%
% return values
%    tbls ... Character array
%    num  ... number of elements of character array
function [tbls,num] = split_str(str,Delm)
    tbls = {};

    [pos,rem] = strtok(str,Delm);
    if isempty(rem)
        tbls = str;
        num = 1;
        return;
    end

    tbls{1} = pos;
    num = 1;
    while(~isempty(rem))
        num = num + 1;
        [tbls{num}, rem] = strtok(rem,Delm);
    end

%--------------------------------------------------------------------------
%% e4aread();
function [e4X, Header, ErrNo] = e4read(file)

    global g_E4aVerNum;     %E4A��Ver���

    global g_LanguageType;  %�{�X�N���v�g���s���̃R�}���h�v�����v�g��ɕ\�����錾���؂�ւ��܂�
                            %0:���{��     1:�p��

    tblInfo = [];

    delm = '.';

    tblInfo.Error{1}       = 'MATLAB:ksread3:FileName';
    tblInfo.Error{2}       = 'MATLAB:ksread3:Argument';
    tblInfo.Error{3}       = 'MATLAB:ksread3:Argument';
    tblInfo.Error{11}      = 'MATLAB:ksread3:FileExist';
    tblInfo.Error{14}      = 'MATLAB:ksread3:FileExtension';
    tblInfo.Error{15}      = 'MATLAB:ksread3:FileExist';
    tblInfo.Error{21}      = 'MATLAB:ksread3:OutOfMemory';
    tblInfo.Error{22}      = 'MATLAB:ksread3:Error Ocurred';
    tblInfo.err.message    = '';
    tblInfo.err.identifier = '';
    tblInfo.err.stack      = [];
    tblInfo.CmpExt       = 'e4a';
    e4X = 0;
    Header = 0;

% MATLAB��version�`�F�b�N
    vers = version;
    tblInfo.MATLAB_Ver   = str2double(vers(1:3));
    tblInfo.HeadSeek     = 960; % �Œ蒷�w�b�_���̑傫��

% MATLAB��Ver(R2008�ȍ~)�ɂ���Č���؂�ւ�������̂��߁C�p�����[�^�Őݒ肷��
    tblInfo.CmpLang = 'jhelp';
    if g_LanguageType == 0
        tblInfo.Lang = 'jhelp';
    else
        tblInfo.Lang = 'Dummy';
    end
  % (1)�������w�肳��Ă��Ȃ��ꍇ
    if nargin < 1 || isempty(file)
        ErrNo = 1;
        return
    elseif nargin > 1
        % (2)�����̐����K�؂łȂ�
        ErrNo = 2;
        return
    end

    [tbls,num] = split_str(file,delm);
    % (3)�g���q������
    if num < 2
        ErrNo = 3;
        return
    end
    tblInfo.ext = lower(tbls{2}); % �擾�����g���q

    % (14)�g���q���قȂ�
    if(strcmpi(tblInfo.CmpExt, tblInfo.ext) == 0)
        ErrNo = 14;
        return
    end

    fid = fopen(file,'r');
    % (11)�t�@�C�������݂��Ȃ��ꍇ
    if fid < 0
        ErrNo = 11;
        return
    end

    %E4A���e�L�X�g���̎擾
    tblInfo = getE4aInfo(fid,tblInfo);

    %E4A�̃o�[�W�����ԍ��̎擾
    VerStr = split_str(tblInfo.version,delm);
    g_E4aVerNum = str2double(cell2mat(VerStr(2)));

    %ID���̎擾
    CanIdDataLen = getIdInfo(fid,tblInfo);

    %�f�[�^���̎擾
    tblInfo.e4XLen = getDataNum(fid,tblInfo);

    %CH�����̎擾
    [CanChStBit, CanChBitLen, CanChDataType, CanChEndian, CanChIdNo, CanChChNo, CanChEdxId, CanChUnitStr, CanChCoeffs, CanChOffset, CanChName] = getChInfo(fid,tblInfo);

    %CAN-CH�����ɕK�v�ȕϐ��̗p��
    [CanChBitShiftR, CanChBitMask, CanChSignedMask, CanChDataLen] = getCanChDecompPrm(tblInfo, CanChStBit, CanChBitLen, CanChIdNo, CanIdDataLen);

    %�W�^�f�[�^�̎擾
    [e4X, e4XIndex, ErrNo]= getCanData(fid, tblInfo, CanChIdNo, CanChEndian, CanChDataType, CanChBitLen, ...
                                CanChBitShiftR, CanChBitMask, CanChSignedMask, CanChDataLen, CanChCoeffs, CanChOffset);

    %�G���[�����̏ꍇ�������΂�
    if(ErrNo ~= 0)
        fclose(fid);
        return
    end

    %�s�K�v�ȍs��̍폜
    clear CanChBitLen
    clear CanChBitMask
    clear CanChBitShiftR
    clear CanChDataLen
    clear CanChDataType
    clear CanChEndian
    clear CanChIdNo
    clear CanChSignedMask
    clear CanChStBit
    clear CanIdDataLen

    %�w�b�_���̍쐬
    Header = getHeaderInfo(tblInfo, CanChChNo, CanChEdxId, CanChCoeffs, CanChOffset, CanChName, CanChUnitStr, e4XIndex);

    %�s�K�v�ȍs��̍폜
    clear CanChChNo
    clear CanChEdxId
    clear CanChCoeffs
    clear CanChOffset
    clear CanChName
    clear CanChUnitStr

    fclose(fid);

%--------------------------------------------------------------------------
%%

function [tblInfo, ErrNo] = e4readHeader(file)


    global g_LanguageType;  %�{�X�N���v�g���s���̃R�}���h�v�����v�g��ɕ\�����錾���؂�ւ��܂�
                            %0:���{��     1:�p��
    tblInfo = [];

    delm = '.';

    tblInfo.Error{1}       = 'MATLAB:ksread3:FileName';
    tblInfo.Error{2}       = 'MATLAB:ksread3:Argument';
    tblInfo.Error{3}       = 'MATLAB:ksread3:Argument';
    tblInfo.Error{11}      = 'MATLAB:ksread3:FileExist';
    tblInfo.Error{14}      = 'MATLAB:ksread3:FileExtension';
    tblInfo.Error{15}      = 'MATLAB:ksread3:FileExist';
    tblInfo.Error{21}      = 'MATLAB:ksread3:OutOfMemory';
    tblInfo.Error{22}      = 'MATLAB:ksread3:Error Ocurred';
    tblInfo.err.message    = '';
    tblInfo.err.identifier = '';
    tblInfo.err.stack      = [];
    tblInfo.CmpExt       = 'e4a';

% MATLAB��version�`�F�b�N
    vers = version;
    tblInfo.MATLAB_Ver   = str2double(vers(1:3));
    tblInfo.HeadSeek     = 960; % �Œ蒷�w�b�_���̑傫��

% MATLAB��Ver(R2008�ȍ~)�ɂ���Č���؂�ւ�������̂��߁C�p�����[�^�Őݒ肷��
    tblInfo.CmpLang = 'jhelp';
    if g_LanguageType == 0
        tblInfo.Lang = 'jhelp';
    else
        tblInfo.Lang = 'Dummy';
    end
  % (1)�������w�肳��Ă��Ȃ��ꍇ
    if nargin < 1 || isempty(file)
        ErrNo = 1;
        return
    elseif nargin > 1
        % (2)�����̐����K�؂łȂ�
        ErrNo = 2;
        return
    end

    [tbls,num] = split_str(file,delm);
    % (3)�g���q������
    if num < 2
        ErrNo = 3;
        return
    end
    tblInfo.ext = lower(tbls{2}); % �擾�����g���q

    % (14)�g���q���قȂ�
    if(strcmpi(tblInfo.CmpExt, tblInfo.ext) == 0)
        ErrNo = 14;
        return
    end

    fid = fopen(file,'r');
    % (11)�t�@�C�������݂��Ȃ��ꍇ
    if fid < 0
        ErrNo = 11;
        return
    end

    %E4A���e�L�X�g���̎擾
    tblInfo = getE4aInfo(fid,tblInfo);

    %�f�[�^���̎擾
    tblInfo.e4XLen = getDataNum(fid,tblInfo);

    fclose(fid);
%--------------------------------------------------------------------------
%% ID���̎擾
%    ����
%        fid     ... �t�@�C���|�C���^�I�u�W�F�N�g
%        tblInfo ... �\���̕ϐ�
%    �߂�l
%        IdLen    ... CANID�f�[�^���z��
function IdLen = getIdInfo(fid,tblInfo)

    IdLen = zeros(1,tblInfo.TransIdInfoNum,'int32');

    SeekByte = tblInfo.HeadSeek...
                + (tblInfo.TransStsSize*tblInfo.TransStsNum)...
                + (tblInfo.TransNodeSize*tblInfo.TransNodeNum);
    fseek(fid,SeekByte,'bof');

    fseek(fid,8,'cof');
    IdLen(1) = fread(fid,1,'uint8=>int32');

    for i = 1:(tblInfo.TransIdInfoNum-1)
        fseek(fid,(tblInfo.TransIdInfoSize-1),'cof');
        IdLen(i+1) = fread(fid,1,'uint8=>int32');
    end

%--------------------------------------------------------------------------
%% CAN-CH���̎擾
%    ����
%        fid     ... �t�@�C���|�C���^�I�u�W�F�N�g
%        tblInfo ... �\���̕ϐ�
%    �߂�l
%        CanChStBit     ... CAN-CH�̃X�^�[�g�r�b�g
%        CanChBitLen    ... CAN-CH�̃r�b�g��
%        CanChDataType  ... CAN-CH�̃f�[�^�^
%        CanChEndian    ... CAN-CH�̃G���f�B�A��
%        CanChIdNo      ... CAN-CH��ID�ԍ�
%        CanChChNo      ... CAN-CH��CH�ԍ�
%        CanChEdxId     ... CAN-CH��EDX��ID�ԍ�
%        CanChUnitStr   ... CAN-CH�̒P�ʕ�����
%        CanChCoeffs    ... CAN-CH�̍Z���W��
%        CanChOffset    ... CAN-CH�̃I�t�Z�b�g
%        CanChName      ... CAN-CH��CH����
function [CanChStBit, CanChBitLen, CanChDataType, CanChEndian, CanChIdNo, CanChChNo, CanChEdxId, CanChUnitStr, CanChCoeffs, CanChOffset, CanChName] = getChInfo(fid,tblInfo)

    CanChStBit = zeros(1,tblInfo.TransChStsNum,'uint32');
    CanChBitLen = zeros(1,tblInfo.TransChStsNum,'uint32');
    CanChDataType = zeros(1,tblInfo.TransChStsNum,'uint32');
    CanChEndian = zeros(1,tblInfo.TransChStsNum,'uint32');
    CanChIdNo = zeros(1,tblInfo.TransChStsNum,'uint32');
    CanChChNo = zeros(1,tblInfo.TransChStsNum,'uint32');
    CanChEdxId = zeros(1,tblInfo.TransChStsNum,'uint32');
    CanChUnitStr(tblInfo.TransChStsNum) = {''};
    CanChCoeffs = zeros(1,tblInfo.TransChStsNum,'double');
    CanChOffset = zeros(1,tblInfo.TransChStsNum,'double');
    CanChName(tblInfo.TransChStsNum) = {''};

    SeekByte = tblInfo.HeadSeek...
                + (tblInfo.TransStsSize*tblInfo.TransStsNum)...
                + (tblInfo.TransNodeSize*tblInfo.TransNodeNum)...
                + (tblInfo.TransIdInfoSize*tblInfo.TransIdInfoNum);
    fseek(fid,SeekByte,'bof');

    for i = 1:tblInfo.TransChStsNum
        CanChStBit(i) = fread(fid,1,'uint8=>int32');
        CanChBitLen(i) = fread(fid,1,'uint8=>int32');
        CanChDataType(i) = fread(fid,1,'uint8=>int32');

        fseek(fid,2,'cof');

        CanChEndian(i) = fread(fid,1,'uint8=>int32');

        fseek(fid,1,'cof');

        CanChEdxId(i) = fread(fid,1,'uint8=>int32');

        CanChIdNo(i) = fread(fid,1,'int16=>int32');
        CanChChNo(i) = fread(fid,1,'int16=>int32');

        uchar_array = fread(fid,10,'uchar');
        CanChUnitStr(i) = cellstr(native2unicode(uchar_array'));

        fseek(fid,2,'cof');

        CanChCoeffs(i) = fread(fid,1,'double');
        CanChOffset(i) = fread(fid,1,'double');

        uchar_array = fread(fid,44,'uchar');
        CanChName(i) = cellstr(native2unicode(uchar_array'));

        fseek(fid,12,'cof');
    end

%--------------------------------------------------------------------------
%% CAN-CH����p�̕ϐ��̎擾
%    ����
%        tblInfo      ... �\���̕ϐ�
%        CanChStBit   ... CAN-CH�X�^�[�g�r�b�g
%        CacChBitLen  ... CAN-CH�̃r�b�g��
%        CanChDataLen ... CAN-CH�ɊY������ID�̃f�[�^��
%    �߂�l
%        CanChBitShiftR     ... CAN-CH�̃r�b�g��
%        CanChBitMask       ... CAN-CH�̃f�[�^�^
%        CanChSignedMask    ... CAN-CH�̃G���f�B�A��
%        CanChIdNo          ... CAN-CH��ID�ԍ�
%        CanIdDataLen       ... CAN-ID�̃f�[�^��
function [CanChBitShiftR, CanChBitMask, CanChSignedMask, CanChDataLen] = getCanChDecompPrm(tblInfo, CanChStBit, CanChBitLen, CanChIdNo, CanIdDataLen)

    CanChNum = tblInfo.TransChStsNum;

    CanChBitShiftR = zeros(1,CanChNum,'int32');
    CanChBitMask = zeros(1,CanChNum,'uint64');
    CanChSignedMask = zeros(1,CanChNum,'uint64');
    CanChDataLen = zeros(1,CanChNum,'int32');

    for i = 1:CanChNum
        %Signed�^�ϊ��p�}�X�N�s��̏�����
        CanChSignedMask(i) = cast(hex2dec('FFFFFFFFFFFFFFFF'), 'uint64');

        %CAN-CH�ϊ��p�E���ւ̃r�b�g�V�t�g�s��̐ݒ�
        CanChBitShiftR(i) = cast(CanChStBit(i),'int32');
        CanChBitShiftR(i) = CanChBitShiftR(i) * -1;

        %�}�X�N�r�b�g��Signed�}�X�N�r�b�g�̐ݒ�
        for kk = 1:CanChBitLen(i)
            CanChBitMask(i) = bitset(CanChBitMask(i), kk);
            CanChSignedMask(i) = bitset(CanChSignedMask(i), kk, 0);
        end
    end

    for i = 1:CanChNum
        CanChDataLen(i) = CanIdDataLen(CanChIdNo(i)+1);
    end

%--------------------------------------------------------------------------

%% CAN�f�[�^���̎擾
%    ����
%        fid     ... �t�@�C���|�C���^�I�u�W�F�N�g
%        tblInfo ... �\���̕ϐ�
%    �߂�l
%        e4XLen  ... E4a�f�[�^�s��̒���
function e4XLen = getDataNum(fid,tblInfo)

    %CAN�f�[�^���̍ŏI�f�[�^�܂ł̃o�C�g����ݒ�
    SeekByte = tblInfo.HeadSeek...
                + (tblInfo.TransStsSize*tblInfo.TransStsNum)...
                + (tblInfo.TransNodeSize*tblInfo.TransNodeNum)...
                + (tblInfo.TransIdInfoSize*tblInfo.TransIdInfoNum)...
                + (tblInfo.TransChStsSize*tblInfo.TransChStsNum)...
                + (tblInfo.CanDataSize*(tblInfo.DataNum-1));

    %�Ō��CAN�f�[�^�܂œǂݔ�΂�
    fseek(fid,SeekByte,'bof');

    %ID���ԍ�(2�o�C�g)�Ɨ\��(2�o�C�g)��ǂݔ�΂�
    fseek(fid,4,'cof');

    %�ŏI�̏W�^�J�E���^�l�̎擾
    e4XLen = fread(fid, 1, 'uint64=>uint64');

    e4XLen = cast(e4XLen, 'double') + 1;
%--------------------------------------------------------------------------
%% CAN�f�[�^�̎擾
%    ����
%        fid             ... �t�@�C���|�C���^�I�u�W�F�N�g
%        tblInfo         ... �\���̕ϐ�
%        CanChIdNo       ... CAN-CH��ID�ԍ�
%        CanChEndian     ... CAN-CH�̃G���f�B�A��
%        CanChDataType   ... CAN-CH�̃f�[�^�^
%        CanChBitLen     ... CAN-CH�̃r�b�g��
%        CanChBitShiftR  ... CAN-CH�̃r�b�g��
%        CanChBitMask    ... CAN-CH�̃f�[�^�^
%        CanChSignedMask ... CAN-CH�̃G���f�B�A��
%        CanIdDataLen    ... CAN-ID�̃f�[�^��
%        CanChCoeffs     ... CAN-CH�̍Z���W��
%        CanChOffset     ... CAN-CH�̃I�t�Z�b�g
%    �߂�l
%        e4XIndex ... CAN�f�[�^�ŏI�ԍ�
%        e4X      ... CAN�f�[�^�s��
function [e4X, e4XIndex, ErrNo] = getCanData(fid, tblInfo, CanChIdNo, CanChEndian, CanChDataType, CanChBitLen,...
                                    CanChBitShiftR, CanChBitMask, CanChSignedMask, CanChDataLen, CanChCoeffs, CanChOffset)

    global g_IndexType;     %�ǂݍ��񂾏W�^�f�[�^�s��̐擪��ɕt������f�[�^�`����؂�ւ��܂�
                            %0�F����      1�F�ԍ�

    global g_StartNumber;   %�ǂݍ��񂾏W�^�f�[�^�s��̐擪��ɕt������f�[�^�̐擪�̊J�n�ԍ���؂�ւ��܂��B
                            %0�F0�n�܂�   1�F1�n�܂�

    e4X = 0;
    e4XIndex = 0;
    ErrNo = 0;

    %Double�^�ő�l�̐ݒ�
    DoubleMax = realmax('double');

    %Double�^�ŏ��l�̐ݒ�
    DoubleMin = realmin('double');

    %Float�^�ő�l�̐ݒ�
    FloatMax = realmax('single');

    %Float�^�ŏ��l�̐ݒ�
    FloatMin = realmin('single');

    %CAN-CH���̎擾
    CanChNum = tblInfo.TransChStsNum;

    %CAN�f�[�^�ǂݍ��ݐ�(�J�E���^�l)
    CanDataReadNum = 1;

    %CAN�f�[�^�ǂݍ��ݏI���t���O
    CanDataReadEnd = 0;

    %CAN-CH�f�[�^�s��̏�����
    CanChData = zeros(1,CanChNum,'uint64');

    %Signed�^�f�[�^�s��̏�����
    SignedCanChData = zeros(CanChNum,1,'int64');

    %Double�^�f�[�^�s��̏�����
    DoubleCanChData = zeros(CanChNum,1,'double');

    %CAN-ID�f�[�^�s��̏�����
    CanIdData = zeros(1,CanChNum,'uint64');

    %CAN-CH�f�[�^���݃t���O�s��
    NonZerosIndex= zeros(1,CanChNum);

    %CAN�f�[�^���܂ł̃o�C�g����ݒ�
    SeekByte = tblInfo.HeadSeek...
                + (tblInfo.TransStsSize*tblInfo.TransStsNum)...
                + (tblInfo.TransNodeSize*tblInfo.TransNodeNum)...
                + (tblInfo.TransIdInfoSize*tblInfo.TransIdInfoNum)...
                + (tblInfo.TransChStsSize*tblInfo.TransChStsNum);

    %CAN�f�[�^���܂œǂݔ�΂�
    fseek(fid,SeekByte,'bof');

    %ID�ԍ��̎擾
    CanIdNo = fread(fid, 1, 'uint16');

    %�\��(2�o�C�g)��ǂݔ�΂�
    fseek(fid,2,'cof');

    %�W�^�J�E���^�l�̎擾
    CanAgCnt = fread(fid, 1, 'uint64=>uint64');

    %CAN�f�[�^�̎擾
    CanData = typecast(fread(fid, 8, 'uint8=>uint8'),'uint64');

    %�\��(4�o�C�g)�ǂݔ�΂�
    fseek(fid,4,'cof');

    %�擾����CANID�ԍ��ɊY������CAN-ID�ԍ��̃C���f�b�N�X���s�񂩂�擾
    Index=find(CanChIdNo == CanIdNo);

    %�擾�����C���f�b�N�X�ԍ���CAN�f�[�^��ݒ�
    CanIdData(Index) = CanData;

    %CAN-CH�f�[�^���݃t���O�s���ON
    NonZerosIndex(Index) = 1;

    %�s��̒������擾
    MatrixLen = cast(tblInfo.e4XLen,'double');

    try
        %CAN�f�[�^�s���NaN�ŏ�����
        e4X(1:MatrixLen-tblInfo.StCnt,1:CanChNum) = NaN;
    catch
        ErrNo = 21;
        return
    end
    %�E�F�C�g�o�[��\��
    h = waitbar(0,makeDispMessage(32,tblInfo));

%CAN�f�[�^�ǂݍ��ݏ�����
    while(1)
        while (1)
            %�O�f�[�^�̃J�E���^�l��ݒ�
            CanPreAgCnt = CanAgCnt;

            %CAN-ID�ԍ��̎擾
            CanIdNo = fread(fid, 1, 'uint16');

            %�\��(2�o�C�g)�ǂݍ���
            fseek(fid,2,'cof');

            %�W�^�J�E���^�l�̎擾
            CanAgCnt = fread(fid, 1, 'uint64=>uint64');

            %CAN�f�[�^�̎擾
            CanData = typecast(fread(fid, 8, 'uint8=>uint8'),'uint64');

            %�\��(4�o�C�g)�ǂݔ�΂�
            fseek(fid,4,'cof');

            %�O�J�E���^�l�ƌ��݂̃J�E���^�l���قȂ�ꍇ
            if(CanPreAgCnt ~= CanAgCnt)
                %���݂̃J�E���^�l��CAN�f�[�^�̓ǂݍ��݂͏I����1�f�[�^���|�C���^��߂�
                fseek(fid,-24,'cof');
                break;
            %�O�J�E���^�l�ƌ��݂̃J�E���^�l����v�����ꍇ
            else
                %�擾����CANID�ԍ��ɊY������CAN-ID�ԍ��̃C���f�b�N�X���s�񂩂�擾
                Index=find(CanChIdNo == CanIdNo);

                %�擾�����C���f�b�N�X�ԍ���CAN�f�[�^��ݒ�
                CanIdData(Index) = CanData;

                %CAN-CH�f�[�^���݃t���O�s���ON
                NonZerosIndex(Index) = 1;

                %CAN�f�[�^�ǂݍ��ݐ����C���N�������g
                CanDataReadNum = CanDataReadNum + 1;
            end

            %CAN�f�[�^�ǂݍ��ݐ���CAN�f�[�^���ƈ�v������
            if(CanDataReadNum == tblInfo.DataNum)

                %�ǂݍ��ݏI���t���O��ON
                CanDataReadEnd = 1;

                %�O�J�E���^�l�����݂̃J�E���^�l�ɐݒ�(���[�����p)
                CanPreAgCnt = CanAgCnt;
                break;
            end
        end

        %�r�b�N�G���f�B�A���p�Ɏ��O�Ƀ��g���G���f�B�A���ɕϊ������z���p�ӂ���
        CanIdData(2,1:CanChNum) = swapbytes(CanIdData(1,1:CanChNum));
        CanIdData(2,1:CanChNum) = bitshift(CanIdData(2,1:CanChNum),-8*(8-CanChDataLen(1:CanChNum)));

       %CAN-CH�f�[�^�փR�s�[����(�G���f�B�A�������g���Ȃ�1�s�ځC�r�b�N�Ȃ�2�s�ڂ�ǂݍ���)
        CanChData(CanChEndian==0) = CanIdData(1,CanChEndian==0);
        CanChData(CanChEndian==1) = CanIdData(2,CanChEndian==1);

        %�s�K�v�ȃr�b�g��폜�̂��߉E���փV�t�g
        CanChData(1:CanChNum) = bitshift(CanChData(1:CanChNum),CanChBitShiftR(1:CanChNum));

        %�K�v�ȃr�b�g�����c�����߃}�X�N
        CanChData(1:CanChNum) = bitand(CanChData(1:CanChNum), CanChBitMask(1:CanChNum));

        %Ver0103
        CanChProcType =CanChDataType;

        %CAN-CH�����f�[�^����
        for kk = 1:CanChNum

            %Signed�^�̏ꍇ
            if (CanChDataType(kk) == 0)
                %�L���r�b�g���̍Ōオ1��������C��������
                if( bitget(CanChData(kk), CanChBitLen(kk)))

                    %Signed�}�X�N�ɂ�蕉�̃f�[�^�ɕϊ�
                    SignedCanChData(kk) = typecast(bitor(bitset(CanChData(kk),CanChBitLen(kk)+1), CanChSignedMask(kk)),'int64');

                    %�f�[�^�^�C�v�^�������p�ɕύX
                    CanChProcType(kk) = 4;
                end
            %UnSigned�^�̏ꍇ
            elseif(CanChDataType(kk) == 1)
            %Float�^�̏ꍇ
            elseif(CanChDataType(kk) == 2)

                %uint64�^����Float�ɓǂݍ��݌^�̕ύX
                FloatCanData = typecast(CanChData(kk),'single');

                %Float�^�͈̔͂𒴂��Ă�����f�[�^��0�Ƃ���
                if( abs(FloatCanData(1,1))<FloatMin || abs(FloatCanData(1,1))>FloatMax )
                    FloatCanData(1,1) = 0;
                end

                %(1,2)�͂��݃f�[�^�C(1,1)��Float�^�ɕϊ����ꂽ�f�[�^
                %Ver0103 float�^�f�[�^�̗L��
                DoubleCanChData(kk) =  str2double(sprintf('%.7G', FloatCanData(1,1)));

                %�f�[�^�^�C�v�^�������p�ɕύX
                CanChProcType(kk) = 3;
            %Double�^�̏ꍇ
            else

                %uint64�^����Double�ɓǂݍ��݌^�̕ύX
                DoubleCanData = typecast(CanChData(kk),'double');

                %Double�^�͈̔͂𒴂��Ă�����f�[�^��0�Ƃ���
                if( abs(DoubleCanData(1,1))<DoubleMin || abs(DoubleCanData(1,1))>DoubleMax )
                    DoubleCanData = 0;
                end

                %Double�^�f�[�^�̐ݒ�
                DoubleCanChData(kk) = DoubleCanData;
            end
        end

        %���݂̍s��C���f�b�N�X�ԍ��̎擾
        e4XIndex = cast(CanPreAgCnt,'double')+1-tblInfo.StCnt;

        %Double�^�̃f�[�^�Ƃ��Č^�ϊ����Ȃ���ݒ�
        e4X(e4XIndex,1:CanChNum) = ...
            (CanChProcType(1:CanChNum) == 0 | CanChProcType(1:CanChNum) == 1).*cast(CanChData(1:CanChNum),'double')...
            + (CanChProcType(1:CanChNum) == 3).*DoubleCanChData(1:CanChNum)'...
            + (CanChProcType(1:CanChNum) == 4).*cast(SignedCanChData(1:CanChNum),'double')';

        %�Z���W���ƃI�t�Z�b�g�ɂ�蕨���ʂɕϊ�
        e4X(e4XIndex,1:CanChNum) = e4X(e4XIndex,1:CanChNum).* CanChCoeffs(1:CanChNum) + CanChOffset(1:CanChNum);

        %CAN�f�[�^�����݂��Ȃ��ӏ���NaN�Ŗ��߂�
        e4X(e4XIndex,NonZerosIndex==0) = NaN;

        %CAN�f�[�^�ǂݍ��ݏI���t���O��ON�Ȃ�I��
        if(CanDataReadEnd == 1)
            waitbar(100);
            break;
        end

        %CAN-ID�f�[�^�s��̏�����
        CanIdData = zeros(1,CanChNum,'uint64');

        %CAN-CH�f�[�^�s��̏�����
        CanChData = zeros(1,CanChNum,'uint64');

        %Signed�^�f�[�^�s��̏�����
        SignedCanChData = zeros(CanChNum,1,'int64');

        %Double�^�f�[�^�s��̏�����
        DoubleCanChData = zeros(CanChNum,1,'double');

        %CAN-CH�f�[�^���݃t���O�s��̏�����
        NonZerosIndex = zeros(1,CanChNum);

        if fix(rem(CanDataReadNum,100)) < tblInfo.DataNum
            waitbar(CanDataReadNum / tblInfo.DataNum);
        end
    end

    %�s�K�v�ȍs��̍폜
    clear CanIdData
    clear CanChData
    clear DoubleCanChData
    clear SignedCanChData

    %�O�l�ێ�����
    %CAN�f�[�^�s��̐擪��NaN��0��
    e4X(1,isnan(e4X(1,:))==1) = 0;

    %CAN�f�[�^�s����NaN�łȂ��C���f�b�N�X���擾
    [n,m] = find(isnan(e4X)==0);

    %CH���ƂɑO�l�ێ�����
    for i = 1:CanChNum
        %i�Ԗڂ�CAN�|CH��NaN�łȂ��C���f�b�N�X�s����擾
        DataIndex = n(m==i);

        %num�ɃC���f�b�N�X�����擾
        [num,~]=size(DataIndex);

        for j = 1:(num-1)
            %NaN�łȂ��C���f�b�N�X�ԍ����玟��NaN�łȂ��C���f�b�N�X�ԍ���1�O�܂Ńf�[�^���R�s�[
            e4X((DataIndex(j):DataIndex(j+1)-1),i) = e4X(DataIndex(j),i);
        end

        %�Ō��NaN�łȂ��C���f�b�N�X�ԍ�����s��̍Ō�܂Ńf�[�^���R�s�[
        e4X((DataIndex(num):e4XIndex),i) = e4X(DataIndex(num),i);
    end

    %���ԕ���\�̎擾
    TimeDiv = 1/tblInfo.Fs;

    %�W�^���Ԃ̎擾
    RecTime = (e4XIndex)/tblInfo.Fs;

    %���Ԍ`���̏ꍇ
    if (g_IndexType==0)
        %0�n�܂�̏ꍇ
        if(g_StartNumber == 0)
            xdiv=(0:TimeDiv:RecTime-TimeDiv)';
        %1�n�܂�̏ꍇ
        else
            xdiv=(TimeDiv:TimeDiv:RecTime)';
        end
    %�ԍ��`���̏ꍇ
    else
        %0�n�܂�̏ꍇ
        if(g_StartNumber == 0)
            xdiv=(0:e4XIndex-1)';
        %1�n�܂�̏ꍇ
        else
            xdiv=(1:e4XIndex)';
        end
    end

    %�f�[�^�ԍ��s��ƃf�[�^�s�������
    e4X=horzcat(xdiv,e4X);


    close(h);
    clear h;
%--------------------------------------------------------------------------
%% �e�L�X�g���̏��擾
%    ����
%        fid     ... �t�@�C���|�C���^�I�u�W�F�N�g
%        tblInfo ... �\���̕ϐ�
%    �߂�l
%        info    ... ����ǉ������\���̕ϐ�

function info = getE4aInfo(fid,tblInfo)


    uchar_array = fread(fid,20,'uchar');
    tblInfo.machine = native2unicode(uchar_array');

    uchar_array = fread(fid,12,'uchar');
    tblInfo.version = native2unicode(uchar_array');

    uchar_array = fread(fid,44,'uchar');
    tblInfo.title = native2unicode(uchar_array');

    uchar_array = fread(fid,16,'uchar');
    tblInfo.Date = native2unicode(uchar_array');

    tblInfo.DataNum = fread(fid,1,'int64');
    tblInfo.StCnt = fread(fid,1,'uint64');

    fseek(fid,8,'cof');

    tblInfo.CanTrgSize = fread(fid,1,'uint16');
    tblInfo.TransStsSize = fread(fid,1,'uint16');
    tblInfo.TransStsNum = fread(fid,1,'uint16');
    tblInfo.TransNodeSize = fread(fid,1,'uint16');
    tblInfo.TransNodeNum = fread(fid,1,'uint16');
    tblInfo.TransIdInfoSize = fread(fid,1,'uint16');
    tblInfo.TransIdInfoNum = fread(fid,1,'uint16');
    tblInfo.TransChStsSize = fread(fid,1,'uint16');
    tblInfo.TransChStsNum = fread(fid,1,'uint16');
    tblInfo.CanDataSize = fread(fid,1,'uint16');

    tblInfo.OverFlow = fread(fid,1,'uint32');
    tblInfo.Fs = fread(fid,1,'uint32');

    fseek(fid,8,'cof');

    uchar_array = fread(fid,12,'uchar');
    tblInfo.Language = native2unicode(uchar_array');

    fseek(fid,24,'cof');

    tblInfo.StTrgCnt = fread(fid,1,'uint64');
    tblInfo.EdTrgCnt = fread(fid,1,'uint64');
    clear header_array;

    info = tblInfo;



%--------------------------------------------------------------------------
%% �w�b�_���̍쐬
%    ����
%        tblInfo      ... �\���̕ϐ�
%        CanChNo      ... CAN-CH�X�^�[�g�r�b�g
%        CanChEdxId   ... CAN-CH��EDX��ID�ԍ�
%        CacChCoeffs  ... CAN-CH�̃r�b�g��
%        CanChOffset  ... CAN-CH�ɊY������ID�̃f�[�^��
%        CanChName    ... CAN-CH����
%        CanChUnitStr ... CAN-CH�P�ʕ�����
%    �߂�l
%        Header       ... �w�b�_���

function Header = getHeaderInfo(tblInfo, CanChChNo, CanChEdxId, CanChCoeffs, CanChOffset, CanChName, CanChUnitStr, e4XIndex)

    global g_CsvFormat;     %�w�b�_���`���̋��^�C�v�E�W���^�C�v��؂�ւ��܂�
                            %0�F���^�C�v  1�F�W���^�C�v
                            %���^�C�v�FDAS-200A�̏����ۑ��`��
                            %�W���^�C�v�FVer01.06�Œǉ����ꂽ�V����CSV�ۑ��`��
    %CAN-CH���̎擾
    CanChNum = tblInfo.TransChStsNum;

%�w�b�_���̍쐬
%�e�Z���f�[�^�̏�����
        tblfileID = cell(1,CanChNum+1);
        tblfileID(:,:) = {''};
        %tblfileID(1,1) = {'[ID�ԍ�]'};
        tblfileID(1,1) = {'[ID No.]'};

        tblfileTitle = cell(1,CanChNum+1);
        tblfileTitle(:,:) = {''};
        %tblfileTitle(1,1) = {'[�^�C�g��]'};
        tblfileTitle(1,1) = {'[Title]'};

        tblfileDate = cell(1,CanChNum+1);
        tblfileDate(:,:) = {''};
        %tblfileDate(1,1) = {'[��������]'};
        tblfileDate(1,1) = {'[Test Date]'};

        tblfileCh_num = cell(1,CanChNum+1);
        tblfileCh_num(:,:) = {''};
        %tblfileCh_num(1,1) = {'[����CH��]'};
        tblfileCh_num(1,1) = {'[Number of Channels]'};

        tblfileDigi_ch = cell(1,CanChNum+1);
        tblfileDigi_ch(:,:) = {''};
        %tblfileDigi_ch(1,1) = {'[�f�W�^������]'};
        tblfileDigi_ch(1,1) = {'[Digital Input]'};

        tblfileSf = cell(1,CanChNum+1);
        tblfileSf(:,:) = {''};
        %tblfileSf(1,1) = {'[�T���v�����O���g��(Hz)]'};
        tblfileSf(1,1) = {'[Sampling Frequency (Hz)]'};

        tblfileData_num = cell(1,CanChNum+1);
        tblfileData_num(:,:) = {''};
        %tblfileData_num(1,1) = {'[�W�^�f�[�^��/CH]'};
        tblfileData_num(1,1) = {'[Number of Samples/CH]'};

        tblfileTime = cell(1,CanChNum+1);
        tblfileTime(:,:) = {''};
        %tblfileTime(1,1) = {'[���莞��(sec)]'};
        tblfileTime(1,1) = {'[Time (sec)]'};

        tblName = cell(1,CanChNum+1);
        tblName(:,:) = {''};
        %tblName(1,1) = {'[CH����]'};
        tblName(1,1) = {'[CH Name]'};

        tblNo = cell(1,CanChNum+1);
        tblNo(:,:) = {''};
        tblNo(1,1) = {'[CH No]'};

        tblrange = cell(1,CanChNum+1);
        tblrange(:,:) = {''};
        %tblrange(1,1) = {'[�����W]'};
        tblrange(1,1) = {'[Range]'};

        tblCoeff_disp = cell(1,CanChNum+1);
        tblCoeff_disp(:,:) = {''};
        %tblCoeff_disp(1,1) = {'[�Z���W��]'};
        tblCoeff_disp(1,1) = {'[Calibration Coeff.]'};

        tblOffset_disp = cell(1,CanChNum+1);
        tblOffset_disp(:,:) = {''};
        %tblOffset_disp(1,1) = {'[�I�t�Z�b�g]'};
        tblOffset_disp(1,1) = {'[Offset]'};

        tblUnit = cell(1,CanChNum+1);
        tblUnit(:,:) = {''};
        %tblUnit(1,1) = {'[�P��]'};
        tblUnit(1,1) = {'[Unit]'};

        tblLowPass = cell(1,CanChNum+1);
        tblLowPass(:,:) = {''};
        %tblLowPass(1,1) = {'[���[�p�X�t�B���^]'};
        tblLowPass(1,1) = {'[Low Pass Filter]'};

        tblHighPass = cell(1,CanChNum+1);
        tblHighPass(:,:) = {''};
        %tblHighPass(1,1) = {'[�n�C�p�X�t�B���^]'};
        tblHighPass(1,1) = {'[High Pass Filter]'};

        tblDigiFilter = cell(1,CanChNum+1);
        tblDigiFilter(:,:) = {''};
        %tblDigiFilter(1,1) = {'[�f�W�^���t�B���^]'};
        tblDigiFilter(1,1) = {'[Digital Filter]'};

%�w�b�_���̐ݒ�
    %������s�񂪋�(0)�̃C���f�b�N�X�ԍ��̎擾
    StrEndIndex = find(tblInfo.title == 0,1,'first');

    %�����񂪋�̏ꍇ
    if StrEndIndex == 1
    %�����񂪂���ꍇ
    else
        %�]���ȍs�񕔂��폜
        tblInfo.title(StrEndIndex:end) = [];

        %�@����ɐݒ�
        tblfileTitle(1,2) = {tblInfo.title};
    end

    %������s�񂪋�(0)�̃C���f�b�N�X�ԍ��̎擾
    StrEndIndex = find(tblInfo.machine == 0,1,'first');

    %�����񂪋�̏ꍇ
    if StrEndIndex == 1
    %�����񂪂���ꍇ
    else
        %�]���ȍs�񕔂��폜
        tblInfo.machine(StrEndIndex:end) = [];

        %�@����ɐݒ�
        tblfileID(1,2) = {tblInfo.machine};
    end

    %������s�񂪋�(0)�̃C���f�b�N�X�ԍ��̎擾
    StrEndIndex = find(tblInfo.title==0,1,'first');

    %�����񂪋�̏ꍇ
    if StrEndIndex == 1
    %�����񂪂���ꍇ
    else
        %�]���ȍs�񕔂��폜
        tblfileTitle(StrEndIndex:end) = [];

        %�@����ɐݒ�
        tblfileTitle(1,2) = {tblInfo.title};
    end

    %�ꎞ�I�ȕ����s���������
    TempChar = zeros(1,12);

    %���������f�[�^�����������������������������^�����^�����ɕϊ�
    TempChar(1:4) = tblInfo.Date(1:4);
    TempChar(5) = '/';
    TempChar(6:7) = tblInfo.Date(5:6);
    TempChar(8) = '/';
    TempChar(9:10) = tblInfo.Date(7:8);

    %������s�񂪋�(0)�̃C���f�b�N�X�ԍ��̎擾
    StrEndIndex = find(TempChar==0,1,'first');

    %�����񂪋�̏ꍇ
    if StrEndIndex == 1
    %�����񂪂���ꍇ
    else
        %�]���ȍs�񕔂��폜
        TempChar(StrEndIndex:end) = [];

        %�@����ɐݒ�
        tblfileDate(1,2)={native2unicode(TempChar)};
    end

    %�ꎞ�I�ȕ����s���������
    TempChar = zeros(1,12);

    %���������f�[�^���������������������F�����F�����ɕϊ�
    TempChar(1:2) = tblInfo.Date(9:10);
    TempChar(3) = ':';
    TempChar(4:5) = tblInfo.Date(11:12);
    TempChar(6) = ':';
    TempChar(7:8) = tblInfo.Date(13:14);

    %������s�񂪋�(0)�̃C���f�b�N�X�ԍ��̎擾
    StrEndIndex = find(TempChar==0,1,'first');

    %�����񂪋�̏ꍇ
    if StrEndIndex == 1
    %�����񂪂���ꍇ
    else
        %�]���ȍs�񕔂��폜
        TempChar(StrEndIndex:end) = [];

        %�@����ɐݒ�
        tblfileDate(1,3)={native2unicode(TempChar)};
    end

    %����CH���̐ݒ�
    tblfileCh_num(1,2) = {tblInfo.TransChStsNum};

    %�T���v�����O���g���̐ݒ�
    tblfileSf(1,2) = {tblInfo.Fs};

    %�W�^�f�[�^���̐ݒ�
    tblfileData_num(1,2) = {e4XIndex};

    %�W�^���Ԃ̎擾
    RecTime = (e4XIndex)/tblInfo.Fs;

    %�W�^���Ԃ̐ݒ�
    tblfileTime(1,2) = {RecTime};

    %CAN-CH���̂̐ݒ�
    tblName(2:end) = CanChName(1:end);

    %�P�ʕ�����̐ݒ�
    tblUnit(2:end) = CanChUnitStr(1:end);

    for i = 1:CanChNum
        %CH�ԍ��̐ݒ�
        if(CanChChNo(i) < 10)
            tblNo(i+1) = {strcat('E', int2str(CanChEdxId(i)), '-00', int2str(CanChChNo(i)))};
        elseif(CanChChNo(i) < 100)
            tblNo(i+1) = {strcat('E', int2str(CanChEdxId(i)), '-0', int2str(CanChChNo(i)))};
        else
            tblNo(i+1) = {strcat('E', int2str(CanChEdxId(i)), '-', int2str(CanChChNo(i)))};
        end

        %�Z���W���̐ݒ�
        tblCoeff_disp(i+1) = {CanChCoeffs(i)};

        %�I�t�Z�b�g�̐ݒ�
        tblOffset_disp(i+1) = {CanChOffset(i)};
    end

    %�w�b�_���
    %���^�C�v
    if (g_CsvFormat == 0)
        %CH����1�̏ꍇ���������̃w�b�_���3�񂠂邽�߁C���̑��̃w�b�_����1�񕪑��₷
        if (CanChNum == 1)
            tblfileID(3)={''};
            tblfileTitle(3)={''};
            tblfileCh_num(3)={''};
            tblfileDigi_ch(3)={''};
            tblfileSf(3)={''};
            tblfileData_num(3)={''};
            tblfileTime(3)={''};
            tblName(3)={''};
            tblNo(3)={''};
            tblrange(3)={''};
            tblCoeff_disp(3)={''};
            tblOffset_disp(3)={''};
            tblUnit(3)={''};
        end

        Header = [tblfileID; tblfileTitle; tblfileDate; tblfileCh_num; tblfileDigi_ch; tblfileSf;...
                        tblfileData_num; tblfileTime; tblName; tblNo; tblrange; tblCoeff_disp; tblOffset_disp; tblUnit; ];
    %�W���^�C�v
    else
        %CH����1�̏ꍇ���������̃w�b�_���3�񂠂邽�߁C���̑��̃w�b�_����1�񕪑��₷
        if (CanChNum == 1)
            tblfileID(3)={''};
            tblfileTitle(3)={''};
            tblfileCh_num(3)={''};
            tblfileSf(3)={''};
            tblfileData_num(3)={''};
            tblfileTime(3)={''};
            tblName(3)={''};
            tblrange(3)={''};
            tblHighPass(3)={''};
            tblLowPass(3)={''};
            tblDigiFilter(3)={''};
            tblCoeff_disp(3)={''};
            tblOffset_disp(3)={''};
            tblUnit(3)={''};
            tblNo(3)={''};
        end

        Header = [tblfileID; tblfileTitle; tblfileDate; tblfileCh_num; tblfileSf;...
                        tblfileData_num; tblfileTime; tblName; tblrange; tblHighPass; tblLowPass; tblDigiFilter; tblCoeff_disp; tblOffset_disp; tblUnit; tblNo;];
    end
%--------------------------------------------------------------------------
