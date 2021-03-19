%In The Name Of GOD
%------------------------------------------------
% HW#1 : Hardware Security
% Professor: Dr Jahanian
% TA : hamed HosseinTalaee - Farshideh Kordi
% Elham Gholami & Mohammad Rostami
%------------------------------------------------
%Hamming Weights
%------------------------------------------------
clc;
clear group0;
clear group1;
clear group2;
clear group3;
clear group4;
clear group5;
clear group6;
clear group7;
clear group8;
clear traces;
SBOX=[099 124 119 123 242 107 111 197 048 001 103 043 254 215 171 118 ...
    202 130 201 125 250 089 071 240 173 212 162 175 156 164 114 192 ...
    183 253 147 038 054 063 247 204 052 165 229 241 113 216 049 021 ...
    004 199 035 195 024 150 005 154 007 018 128 226 235 039 178 117 ...
    009 131 044 026 027 110 090 160 082 059 214 179 041 227 047 132 ...
    083 209 000 237 032 252 177 091 106 203 190 057 074 076 088 207 ...
    208 239 170 251 067 077 051 133 069 249 002 127 080 060 159 168 ...
    081 163 064 143 146  157 056 245 188 182 218 033 016 255 243 210 ...
    205 012 019 236 095 151 068 023 196 167 126 061 100 093 025 115 ...
    096 129 079 220 034 042 144 136 070 238 184 020 222 094 011 219 ...
    224 050 058 010 073 006 036 092 194 211 172 098 145 149 228 121 ...
    231 200 055 109 141 213 078 169 108 086 244 234 101 122 174 008 ...
    186 120 037 046 028 166 180 198 232 221 116 031 075 189 139 138 ...
    112 062 181 102 072 003 246 014 097 053 087 185 134 193 029 158 ...
    225 248 152 017 105 217 142 148 155 030 135 233 206 085 040 223 ...
    140 161 137 013 191 230 066 104 065 153 045 015 176 084 187 022];

%--------------------------------------------------------------------------
%                     LOADING the DATA
%--------------------------------------------------------------------------
tic
numberOfTraces = 108000;
offset = 100;
segmentLength1 = 800;
load('traces.mat')
plaintext = load('inputs.mat');
plaintext = plaintext.inputs(1:numberOfTraces,:);
traces = traces(1:numberOfTraces,offset : segmentLength1);
segmentLength = size(traces,2);
%--------------------------------------------------------------------------
%  Key recovery
%--------------------------------------------------------------------------
byteStart = 1;
byteEnd = 16;
keyCandidateStart = 0;
keyCandidateStop = 255;
solvedKey = zeros(1,byteEnd);

for BYTE=byteStart:byteStart
    groupFin(1,:) = zeros(1,segmentLength);
    Hypothesis = zeros(numberOfTraces,256);
        Hypothesis(:,BYTE+1)=bitxor(plaintext(:,BYTE),BYTE);
        Hypothesis(:,BYTE+1)=SBOX(Hypothesis(:,BYTE+1)+1);
        group0 = zeros(1,segmentLength);
        group1 = zeros(1,segmentLength);
        group2 = zeros(1,segmentLength);
        group3 = zeros(1,segmentLength);
        group4 = zeros(1,segmentLength);
        group5 = zeros(1,segmentLength);
        group6 = zeros(1,segmentLength);
        group7 = zeros(1,segmentLength);
        group8= zeros(1,segmentLength);
        nbTracesG0 = 0;
        nbTracesG1 = 0;
        nbTracesG2 = 0;
        nbTracesG3 = 0;
        nbTracesG4 = 0;
        nbTracesG5 = 0;
        nbTracesG6 = 0;
        nbTracesG7 = 0;
        nbTracesG8 = 0;
        for L = 1:numberOfTraces
            w=0;
            for i=1:8
                if bitget( Hypothesis(L,BYTE+1), i ) == 1
                     w = w + 1;
                end
            end
            if w == 0
                nbTracesG0 = nbTracesG0 + 1 ;
                group0(nbTracesG0,:) = traces(L,17);
            elseif w == 1 
                 nbTracesG1 = nbTracesG1 + 1 ;
                group1(nbTracesG1,:) = traces(L,17);
            elseif w == 2
                 nbTracesG2 = nbTracesG2 + 1 ;
                group2(nbTracesG2,:) = traces(L,17);
            elseif w == 3
                 nbTracesG3 = nbTracesG3 + 1 ;
                group3(nbTracesG3,:) = traces(L,17);
            elseif w == 4
                 nbTracesG4 = nbTracesG4 + 1 ;
                group4(nbTracesG4,:) = traces(L,17);
            elseif w == 5
                 nbTracesG5 = nbTracesG5 + 1 ;
                group5(nbTracesG5,:) = traces(L,17);
            elseif w == 6
                 nbTracesG6 = nbTracesG6 + 1 ;
                group6(nbTracesG6,:) = traces(L,17);
            elseif w == 7
                 nbTracesG7 = nbTracesG7 + 1 ;
                group7(nbTracesG7,:) = traces(L,17);
            elseif w == 8
                 nbTracesG8 = nbTracesG8 + 1 ;
                group8(nbTracesG8,:) = traces(L,17);
            end
        end
	figure;
    plot(group0,'y');
    hold on;
    plot(group1,'r');
    hold on;
    plot(group2,'g');
    hold on;
    plot(group3,'b');
    hold on;
    plot(group4,'k');
    hold on;
    plot(group5,'m');
    hold on;
    plot(group6,'c');
    hold on;
    plot(group7,'w');
    hold on;
    plot(group8,'y');
    %-----------
    figure;
    hist(group0);
    hold on;
    hist(group1);
    hold on;
    hist(group2);
    hold on;
    hist(group3);
    hold on;
    hist(group4);
    hold on;
    hist(group5);
    hold on;
    hist(group6);
    hold on;
    hist(group7);
    hold on;
    hist(group8);
end
toc