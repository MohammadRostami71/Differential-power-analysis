%In The Name Of GOD
%------------------------------------------------
% HW#1 : Hardware Security
% Professor: Dr Jahanian
% TA : hamed HosseinTalaee - Farshideh Kordi
% Elham Gholami & Mohammad Rostami
%------------------------------------------------
%DPA Result
%Plot group 1 & group 2
%histogram group 1 & group 2
%histogram group 1 & 2 in 1 figure 
%------------------------------------------------
clc;
clear group1;
clear group2;
clear groupFin;
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
plaintext = plaintext.inputs;
traces = traces(:,offset : segmentLength1);
segmentLength = size(traces,2);
%--------------------------------------------------------------------------
%  Key recovery
%--------------------------------------------------------------------------
byteStart = 1;
byteEnd = 16;
keyCandidateStart = 0;
keyCandidateStop = 255;
solvedKey = zeros(1,byteEnd);

for BYTE=byteStart:byteEnd
    groupFin(1,:) = zeros(1,segmentLength);
    Hypothesis = zeros(numberOfTraces,256);
    for K = keyCandidateStart:keyCandidateStop
        Hypothesis(:,K+1)=bitxor(plaintext(:,BYTE),K);
        Hypothesis(:,K+1)=SBOX(Hypothesis(:,K+1)+1);
        K;
        group1 = zeros(1,segmentLength);
        group2 = zeros(1,segmentLength);
        nbTracesG1 = 0;
        nbTracesG2 = 0;
        for L = 1:numberOfTraces
            LSBsbox = bitget(Hypothesis(L,K+1),1);
            if LSBsbox == 1
                group1(1,:) = group1(1,:) + traces(L,:);
                nbTracesG1 = nbTracesG1 + 1;
            else
                group2(1,:) = group2(1,:) + traces(L,:);
                nbTracesG2 = nbTracesG2 + 1;
            end
        end
        
        group1(1,:) = group1(1,:) / nbTracesG1;
        group2(1,:) = group2(1,:) / nbTracesG2;
        groupFin(K+1,:) = abs(group1(1,:)-group2(1,:));
    end
    [row,column]=ind2sub(size(groupFin), find(groupFin==max(groupFin(:))));
    solvedKey(1,BYTE) = row - 1;
end
figure;
plot(groupFin);
title('Final DPA Result','FontSize',18,'FontWeight','bold','Color','r')
figure;
plot(group1);
title('Group 1','FontSize',18,'FontWeight','bold','Color','r')
figure;
plot(group2,'k')
title('Group 2','FontSize',18,'FontWeight','bold','Color','r')
figure;
histfit(group1);
title('Hist Group 1')
figure;
histfit(group2);
title('Hist Group 2')
figure;
plot(group1,'LineWidth',1.5)
title('Group 1','FontSize',18,'FontWeight','bold','Color','r')
hold on
plot(group2,'r')
title('Group 2 & 1','FontSize',18,'FontWeight','bold','Color','r')
legend('Group 1','Group 2')
toc