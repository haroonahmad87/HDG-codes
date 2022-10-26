function [xi,w_g] = GaussLegendreCubature2D(order)
% Funcion que, dado un n de puntos de Gauss, devuelve la posici?n de estos 
% y los correspondientes pesos de integracion
%
% Input:    order:        order for the cubature rule 
% Output:   xi, w_g:      posicion y pesos de los puntos de Gauss en el  
%                         elemento de referencia 
%


if order==1
  gPts =  1;
elseif order==2
  gPts =  3;
elseif order==3
  gPts =  4;
elseif order==4
  gPts =  6;
elseif order==5
  gPts =  7;
elseif order==6
  gPts = 12;
elseif order==7
  gPts = 13;
elseif order==8
    order=10;
    gPts = 25;
elseif order==10
  gPts = 25;
elseif order ==15 
  gPts =  54;
elseif order ==20
  gPts =  85;
elseif order ==25
  gPts = 126;
elseif order ==30
  gPts = 175;
end

xi  = zeros(gPts, 2);
w_g = zeros(gPts, 1);

if gPts==1
  xi(1,1:2)=[1/3,1/3];
  w_g=1;
elseif gPts==3
  xi(1,:)=[2/3,1/6];
  xi(2,:)=[1/6,2/3];
  xi(3,:)=[1/6,1/6];
  w_g=[1/3 1/3 1/3];
elseif gPts==4
  xi(1,1) = 1.0/3.0; 	xi(1,2) = 1.0/3.0;
  xi(2,1) = 0.6;      xi(2,2) = 0.2;
  xi(3,1) = 0.2;      xi(3,2) = 0.6;
  xi(4,1) = 0.2;      xi(4,2) = 0.2;

  w_g(1) = -27.0/48.0;
  w_g(2) =  25.0/48.0;
  w_g(3) =  25.0/48.0;
  w_g(4) =  25.0/48.0;
elseif gPts==6
  a=0.659027622374092;
  b=0.231933368553031;
  c=0.109039009072877;
  xi(1,:)=[a,b];
  xi(2,:)=[b,a];
  xi(3,:)=[a,c];
  xi(4,:)=[c,a];
  xi(5,:)=[b,c];
  xi(6,:)=[c,b];
  w_g=[1/6 1/6 1/6 1/6 1/6 1/6];
elseif gPts==12
  a=0.873821971016996;
  b=0.063089014491502;
  xi(1,:)=[a,b];
  xi(2,:)=[b,b];
  xi(3,:)=[b,a];
  a=0.501426509658179;
  b=0.249286745170910;
  xi(4,:)=[a,b];
  xi(5,:)=[b,b];
  xi(6,:)=[b,a];
  a=0.636502499121399;
  b=0.310352451033785;
  c=0.053145049844816;
  xi( 7,:)=[a,b];
  xi( 8,:)=[b,a];
  xi( 9,:)=[a,c];
  xi(10,:)=[c,a];
  xi(11,:)=[b,c];
  xi(12,:)=[c,b];
  w_g=[  0.050844906370207,0.050844906370207,0.050844906370207, ...
    0.116786275726379,0.116786275726379,0.116786275726379, ...
    0.082851075618374,0.082851075618374,0.082851075618374, ...
    0.082851075618374,0.082851075618374,0.082851075618374];
elseif gPts==7
  [pospg,pespg]=QuadratureTri(order);
  if (gPts~=size(pospg,1))
    disp('error integration')
  end
  F=[2/3 0;-1/3 1/sqrt(3)];u=[1/3 1/3]';
  pospg=pospg*F';
  for i=1:gPts
    pospg(i,:)=pospg(i,:) + u';
  end
  pespg=pespg/sum(pespg);
  xi=pospg;
  w_g=pespg;
elseif gPts==25
  [pospg,pespg]=QuadratureTri(order);
  if (gPts~=size(pospg,1))
    disp('error integration')
  end
  F=[2/3 0;-1/3 1/sqrt(3)];u=[1/3 1/3];
  pospg=pospg*F';
  for i=1:gPts
    pospg(i,:)=pospg(i,:) + u;
  end
  pespg=pespg/sum(pespg);
  xi=pospg;
  w_g=pespg;
elseif gPts==54
  [pospg,pespg]=QuadratureTri(order);
  if (gPts~=size(pospg,1))
    disp('error integration')
  end
  F=[2/3 0;-1/3 1/sqrt(3)];u=[1/3 1/3];
  pospg=pospg*F';
  for i=1:gPts
    pospg(i,:)=pospg(i,:) + u;
  end
  pespg=pespg/sum(pespg);
  xi=pospg;
  w_g=pespg;
elseif gPts==85
  [pospg,pespg]=QuadratureTri(order);
  if (gPts~=size(pospg,1))
    disp('error integration')
  end
  F=[2/3 0;-1/3 1/sqrt(3)];u=[1/3 1/3];
  pospg=pospg*F';
  for i=1:gPts
    pospg(i,:)=pospg(i,:) + u;
  end
  pespg=pespg/sum(pespg);
  xi=pospg;
  w_g=pespg;
elseif gPts==126
  [pospg,pespg]=QuadratureTri(order);
  if (gPts~=size(pospg,1))
    disp('error integration')
  end
  F=[2/3 0;-1/3 1/sqrt(3)];u=[1/3 1/3];
  pospg=pospg*F';
  for i=1:gPts
    pospg(i,:)=pospg(i,:) + u;
  end
  pespg=pespg/sum(pespg);
  xi=pospg;
  w_g=pespg;
elseif gPts==175
  [pospg,pespg]=QuadratureTri(order);
  if (gPts~=size(pospg,1))
    disp('error integration')
  end
  F=[2/3 0;-1/3 1/sqrt(3)];u=[1/3 1/3]';
  pospg=pospg*F';
  for i=1:gPts
    pospg(i,:)=pospg(i,:) + u';
  end
  pespg=pespg/sum(pespg);
  xi=pospg;
  w_g=pespg;
else
  error('Nonavailable triangle cubature');
end

%%
%%
function [pospg,pespg,XeTri]=QuadratureTri(order)
%
%
% Define una cuadratura simetrica sobre el 
% triangulo XeTri de orden = 5, 10, 15, 20, 25, 30
% Referencia:
%   S. Wandzura and H. Xiao. "Symmetric quadrature rules on a triangle".
%   Computers and Mathematics with Applications, Volume 45, Number 12, 
%   June 2003 , pp. 1829-1840(12).


% Coordenadas del triangulo equilatero sobre el 
% que se define la cuadratura 
t1 = [1 0];
t2 = [-1/2,  sqrt(3)/2];
t3 = [-1/2, -sqrt(3)/2];
XeTri = [t1;t2;t3];

% Elementos del grupo D3 
fi1 = 2*pi/3;
fi2 = 4*pi/3;
A = [cos(fi1) sin(fi1); -sin(fi1) cos(fi1)];
B = [cos(fi2) sin(fi2); -sin(fi2) cos(fi2)];
C = [1 0; 0 1];
D = [cos(fi1) -sin(fi1); -sin(fi1) -cos(fi1)];
E = [1 0; 0 -1];
F = [cos(fi2) -sin(fi2); -sin(fi2) -cos(fi2)];

if order==5

    M = [1  3  3];
    X = [0 -0.4104261923153453   0.6961404780296310 ];
    Y = [0  0  0];
    w = [0.225  0.13239415278850623  0.12593918054482713];

elseif order==10

    M = [1 3 3 3 3 6 6];
    X = [0 -0.49359629886342453 -0.28403734918716863  0.44573076177032633 ...
            0.9385563442849673  -0.4474955151540920  -0.4436763946123360];
    Y = [0  0  0  0  0  -0.5991595522781586 -0.2571781329392130];
    w = [0.08352339980519638 0.007229850592056743 0.07449217792098051  ...
         0.07864647340310853 0.006928323087107504 0.0295183203347794 0.03957936719606124];

elseif order==15

    M = [3 3 3 3 3 3 6 6 6 6 6 6];
    X = [-0.3748423891073751 -0.2108313937373917   0.12040849626092393  0.5605966391716812 ...
          0.8309113970031897  0.95027461942488903 -0.4851316950361628  -0.4762943440546580 ...
         -0.4922845867745440 -0.4266165113705168  -0.3968468770512212  -0.2473933728129512];
    Y = [ 0  0  0  0  0  0   -0.4425551659467111  -0.1510682717598242  -0.6970224211436132 ...
         -0.5642774363966393 -0.3095105740458471  -0.2320292030461791];
    w = [ 0.03266181884880529  0.027412818031364363 0.02651003659870330  0.02921596213648611 ...
          0.01058460806624399  0.003614643064092035 0.008527748101709436 0.01391617651669193 ...
          0.004291932940734835 0.01623532928177489  0.02560734092126239  0.033088195531645673];

elseif order==20
    
    M = [1 3 3 3 3 3 3 3 3 6 6 6 6 6 6 6 6 6 6];
    X = [0 -0.4977490260133565 -0.35879037209157373 -0.19329181386571043 0.20649939240163803 0.3669431077237697 ... 
         0.6767931784861860 0.8827927364865920 0.9664768608120111 -0.4919755727189941 -0.4880677744007016 ...
         -0.4843664025781043 -0.4835533778058150 -0.4421499318718065 -0.44662923827417273 ...
         -0.4254937754558538 -0.4122204123735024 -0.31775331949340863 -0.2889337325840919 ];
    Y = [0  0  0  0  0  0  0  0  0  -0.7513212483763635 -0.5870191642967427   -0.17172709841143283 ...
         -0.3833898305784408 -0.6563281974461070 -0.06157647932662624 -0.47831240826600273 ...
         -0.2537089901614676  -0.3996183176834929 -0.18441839672339823];
    w = [ 0.02761042699769952  0.00177902954732674  0.02011239811396117  0.02681784725933157 ...
          0.02452313380150201  0.01639457841069539  0.01479590739864960  0.004579282277704251 ...
          0.001651826515576217 0.002349170908575584 0.004465925754181793 0.006099566807907972 ...
          0.006891081327188203 0.007997475072478163 0.0073861342853360243 0.01279933187864826 ...
          0.01725807117569655  0.01867294590293547  0.02281822405839526];
    
elseif order==25        
     
    M = [3 3 3 3 3 3 3 3 3 3 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6];
    X = [ -0.4580802753902387 -0.3032320980085228 -0.1696674057318916  0.1046702979405866  0.2978674829878846 ...
           0.5455949961729473  0.6617983193620190  0.7668529237254211  0.8953207191571090  0.9782254461372029 ...
          -0.4980614709433367 -0.4919004480918257 -0.4904239954490375 -0.4924576827470104 -0.4897598620673272 ...
          -0.4849757005401057 -0.4613632802399150 -0.4546581528201263 -0.4542425148392569 -0.4310651789561460 ...
          -0.3988357991895837 -0.3949323628761341 -0.3741327130398251 -0.3194366964842710 -0.2778996512639500  -0.2123422011990124];
    Y = [ 0  0  0  0  0  0  0  0  0  0  -0.4713592181681879  -0.1078887424748246  -0.3057041948876942  -0.7027546250883238  ...
         -0.7942765584469995 -0.5846826436376921 -0.4282174042835178 -0.2129434060653430 -0.6948910659636692 -0.5691146659505208 ...
         -0.3161666335733065 -0.1005941839340892 -0.4571406037889341 -0.2003599744104858 -0.3406754571040736 -0.1359589640107579 ];
    w = [ 0.008005581880020417  0.01594707683239050   0.01310914123079553  0.019583000965635623  0.01647088544153727  0.008547279074092100 ...
          0.008161885857226492  0.0061211465399837793 0.002908498264936665 0.0006922752456619963 0.001248289199277397 0.003404752908803022 ...
          0.003359654326064051  0.001716156539496754  0.001480856316715606 0.003511312610728685  0.007393550149706484 0.007983087477376558 ...
          0.0043559626131580413 0.007365056701417832  0.01096357284641955  0.01174996174354112   0.01001560071379857  0.01330964078762868 ...
          0.01415444650522614   0.01488137956116801];
    
elseif order==30
    
    M = [1 3 3 3 3 3 3 3 3 3 3 3 3 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6];
    X = [ 0  -0.489004825350852  -0.375506486295553  -0.273528565811884  -0.146141210161750   0.157036462611772 ...
              0.317953072437897   0.476322665473811   0.630224718395690   0.759747313323409   0.856676597776304 ...
              0.934838455959575   0.985705967153689  -0.498611943209980  -0.497921111216654  -0.494476376816134 ... 
             -0.494145164863761  -0.495150127767484  -0.490298851831645  -0.495128786763001  -0.486987363789869 ...
             -0.476604460299029  -0.473034918119472  -0.474313631969166  -0.465674891980127  -0.450893604068350 ... 
             -0.449268481486489  -0.446678578309977  -0.424190314539700  -0.414477927626402  -0.403770790368195 ... 
             -0.379248277568562  -0.343449397798204  -0.329232658356873  -0.281954768426714  -0.215081520767032];
    Y = [ 0  0  0  0  0  0  0  0  0  0  0  0  0      -0.145911499458133  -0.758841124126978  -0.577206108525577 ...   
             -0.819283113385993  -0.333106124712369  -0.674968075724015  -0.464914848460198  -0.274747981868076 ...   
             -0.755078734433048  -0.153390877058151  -0.429173048901523  -0.559744628102069  -0.665677920960733 ...   
             -0.302435402004506  -0.037339333379264  -0.443257445349149  -0.159839002260082  -0.562852040975635 ...   
             -0.304872368029416  -0.434881627890658  -0.151014758677329  -0.290117766854826  -0.143940337075373];
     w = [ 0.015579960202899  0.003177233700534  0.010483426635731  0.013209459577744  0.014975006966272  0.014987904443384  ...
           0.013338864741022  0.010889171113902  0.008189440660893  0.005575387588608  0.003191216473412  0.001296715144327  ...
           0.000298262826135  0.000998905685079  0.000462850849173  0.001234451336382  0.000570719852243  0.001126946125878  ...
           0.001747866949407  0.001182818815032  0.001990839294675  0.001900412795036  0.004498365808817  0.003478719460275  ...
           0.004102399036724  0.004021761549744  0.006033164660795  0.003946290302130  0.006644044537680  0.008254305856078  ...
           0.006496056633406  0.009252778144147  0.009164920726294  0.011569524628098  0.011761116467609  0.013824702182165 ];
else
    disp('Cuadratura no definida')    
end

% Calcular los puntos de multiplicidad > 1 (con las transformaciones de D3)

m = size(M,2);

pospg = [];
pespg = [];
k=1;
for i=1:m
    x = X(i);
    y = Y(i);

    % Se calculan los puntos de integracion a partir de los 
    % valores tabulados
    pospg = [pospg; (C*[x;y])'];
   
    if M(i)>1
        % Orbita de multiplicidad 3
        pospg = [pospg; (A*[x;y])'];
        pospg = [pospg; (B*[x;y])'];
%         [x y (B*[x;y])']
    end
    if M(i)>3
        % Orbita de multiplicidad 6
        pospg = [pospg; (D*[x;y])'];
        pospg = [pospg; (E*[x;y])'];
        pospg = [pospg; (F*[x;y])'];
    end

    % Se modifican los pesos (sobre XeTri)
    for j=1:M(i)
        pespg(k) = w(i)*sqrt(27)/4;
        k = k+1;
    end
end

