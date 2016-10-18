close all
clc
clear

pTrain = 0.7;


dirResul = '.\ResultadosTestTrai\';
dirInput = '.\ResultadosCorte\';
ResulG_NG = {'.\ResultadosTestTrai\TestG_NG' '.\ResultadosTestTrai\TrainingG_NG'};

namesFolder = {'Test' 'Training'};

listaBBDD = dir('.\ResultadosCorte\');
BBDD = listaBBDD(3:end); 

% Se crean todas las carpetas necesarias

if(exist(dirResul,'dir'))
	rmdir('.\ResultadosTestTrai\','s')
end

mkdir(strcat(dirResul,'\Glaucoma\Originales'));
mkdir(strcat(dirResul,'\Glaucoma\Disco Optico'));
mkdir(strcat(dirResul,'\Glaucoma\Copa'));
mkdir(strcat(dirResul,'\NoGlaucoma\Originales'));
mkdir(strcat(dirResul,'\NoGlaucoma\Disco Optico'));
mkdir(strcat(dirResul,'\NoGlaucoma\Copa'));


for n=1:length(ResulG_NG)
    
    mkdir(strcat(ResulG_NG{n},'\Glaucoma\Originales'));
    mkdir(strcat(ResulG_NG{n},'\Glaucoma\Disco Optico'));
    mkdir(strcat(ResulG_NG{n},'\Glaucoma\Copa'));
    mkdir(strcat(ResulG_NG{n},'\NoGlaucoma\Originales'));
    mkdir(strcat(ResulG_NG{n},'\NoGlaucoma\Disco Optico'));
    mkdir(strcat(ResulG_NG{n},'\NoGlaucoma\Copa'));
    
end


for i=1:length(namesFolder)
    
    mkdir(strcat(dirResul,namesFolder{i},'\Originales'));
    mkdir(strcat(dirResul,namesFolder{i},'\Disco Optico'));
    mkdir(strcat(dirResul,namesFolder{i},'\Copa'));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Se crean las carpetas con las imágenes de Glaucoma y No Glaucoma  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(BBDD)    
    
   lista{i} = dir(strcat(dirInput,BBDD(i).name,'\Originales'));
   lista{i} = lista{i}(3:end); 
   
   listDisk{i} = dir(strcat(dirInput,BBDD(i).name,'\Disco Optico'));
   listDisk{i} = listDisk{i}(3:end);

   listCopa{i} = dir(strcat(dirInput,BBDD(i).name,'\Copa'));
   listCopa{i} = listCopa{i}(3:end);
   
   for l=1:length(lista{i})
       
      if strcmp(lista{i}(l).name(7),'g')      
          
           im = imread(strcat(dirInput,BBDD(i).name,'\Originales\',lista{i}(l).name));
           disco = imread(strcat(dirInput,BBDD(i).name,'\Disco Optico\',listDisk{i}(l).name));
           copa = imread(strcat(dirInput,BBDD(i).name,'\Copa\',listCopa{i}(l).name));

           imwrite(im,strcat(dirResul,'\Glaucoma\Originales\',lista{i}(l).name));
           imwrite(disco,strcat(dirResul,'\Glaucoma\Disco Optico\',listDisk{i}(l).name));
           imwrite(copa,strcat(dirResul,'\Glaucoma\Copa\',listCopa{i}(l).name));

       
      else 
          
          im = imread(strcat(dirInput,BBDD(i).name,'\Originales\',lista{i}(l).name));
          disco = imread(strcat(dirInput,BBDD(i).name,'\Disco Optico\',listDisk{i}(l).name));
          copa = imread(strcat(dirInput,BBDD(i).name,'\Copa\',listCopa{i}(l).name));
       
          imwrite(im,strcat(dirResul,'\NoGlaucoma\Originales\',lista{i}(l).name));
          imwrite(disco,strcat(dirResul,'\NoGlaucoma\Disco Optico\',listDisk{i}(l).name));
          imwrite(copa,strcat(dirResul,'\NoGlaucoma\Copa\',listCopa{i}(l).name));          
          
      end
   end
   
end

%%%%%%%%%%%%%%% Aqui se obtienen los índices de la permutación aleatoria para escoger las imágenes de Test y Training %%%%%%%%%%%%%%%%%%%%%%%%%%%


% Listas para Glaucoma
listG = dir(strcat(dirResul,'\Glaucoma\Originales\'));
listG = listG(3:end);

listDiskG = dir(strcat(dirResul,'\Glaucoma\Disco Optico\'));
listDiskG = listDiskG(3:end);

listCopaG = dir(strcat(dirResul,'\Glaucoma\Copa\'));
listCopaG = listCopaG(3:end);


listaGla = randperm(length(listG));
numG = round(length(listaGla)*pTrain);
listTraG = listaGla(1:numG);
listTestG = listaGla(numG+1:end);


% Listas para NO Glaucoma

listNG = dir(strcat(dirResul,'\NoGlaucoma\Originales\'));
listNG = listNG(3:end);

listDiskNG = dir(strcat(dirResul,'\NoGlaucoma\Disco Optico\'));
listDiskNG = listDiskNG(3:end);

listCopaNG = dir(strcat(dirResul,'\NoGlaucoma\Copa\'));
listCopaNG = listCopaNG(3:end);

listNoGla = randperm(length(listNG));
numNG = round(length(listNoGla)*pTrain);
listTraNG = listNoGla(1:numNG);
listTestNG = listNoGla(numNG+1:end);

dirGlaucoma = '.\ResultadosTestTrai\Glaucoma\';
dirNoGlaucoma = '.\ResultadosTestTrai\NoGlaucoma\';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Carpetas de Test y Training %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Training 
% Glaucoma

for i=1:numG
       
    im_g = imread(strcat(dirGlaucoma,'Originales\',listG(listTraG(i)).name));
    copa_g = imread (strcat(dirGlaucoma,'Disco Optico\',listCopaG(listTraG(i)).name));
    disk_g = imread (strcat(dirGlaucoma,'Copa\',listDiskG(listTraG(i)).name));    
    
    name_im = strcat(dirResul,'\Training\Originales\',listG(listTraG(i)).name);
    name_copa = strcat(dirResul,'\Training\Copa\',listCopaG(listTraG(i)).name);
    name_disk = strcat(dirResul,'\Training\Disco Optico\',listDiskG(listTraG(i)).name);    
  
    imwrite(im_g, name_im); 
    imwrite(copa_g, name_copa); 
    imwrite(disk_g, name_disk); 
    
end

% No Glaucoma

for i=1:numNG
      
    im_ng = imread(strcat(dirNoGlaucoma,'Originales\',listNG(listTraNG(i)).name));
    copa_ng = imread (strcat(dirNoGlaucoma,'Disco Optico\',listCopaNG(listTraNG(i)).name));
    disk_ng = imread (strcat(dirNoGlaucoma,'Copa\',listDiskNG(listTraNG(i)).name));    
    
    name_im = strcat(dirResul,'\Training\Originales\',listNG(listTraNG(i)).name);
    name_copa = strcat(dirResul,'\Training\Copa\',listCopaNG(listTraNG(i)).name);
    name_disk = strcat(dirResul,'\Training\Disco Optico\',listDiskNG(listTraNG(i)).name);    
  
    imwrite(im_ng, name_im); 
    imwrite(copa_ng, name_copa); 
    imwrite(disk_ng, name_disk); 
    
end


%% Test 
% Glaucoma

for i=1:length(listG) - numG
    
    
    im_g = imread(strcat(dirGlaucoma,'Originales\',listG(listTestG(i)).name));
    copa_g = imread (strcat(dirGlaucoma,'Disco Optico\',listCopaG(listTestG(i)).name));
    disk_g = imread (strcat(dirGlaucoma,'Copa\',listDiskG(listTestG(i)).name));    
    
    name_im = strcat(dirResul,'\Test\Originales\',listG(listTestG(i)).name);
    name_copa = strcat(dirResul,'\Test\Copa\',listCopaG(listTestG(i)).name);
    name_disk = strcat(dirResul,'\Test\Disco Optico\',listDiskG(listTestG(i)).name);      
  
    imwrite(im_g, name_im); 
    imwrite(copa_g, name_copa); 
    imwrite(disk_g, name_disk); 
    
end

% No Glaucoma

for i=1:length(listNG)-numNG
    
    im_ng = imread(strcat(dirNoGlaucoma,'Originales\',listNG(listTestNG(i)).name));
    copa_ng = imread (strcat(dirNoGlaucoma,'Disco Optico\',listCopaNG(listTestNG(i)).name));
    disk_ng = imread (strcat(dirNoGlaucoma,'Copa\',listDiskNG(listTestNG(i)).name));    
    
    name_im = strcat(dirResul,'\Test\Originales\',listNG(listTestNG(i)).name);
    name_copa = strcat(dirResul,'\Test\Copa\',listCopaNG(listTestNG(i)).name);
    name_disk = strcat(dirResul,'\Test\Disco Optico\',listDiskNG(listTestNG(i)).name);      
  
    imwrite(im_ng, name_im); 
    imwrite(copa_ng, name_copa); 
    imwrite(disk_ng, name_disk); 
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Carpetas de Test N_NG y Training G_NG %%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Glaucoma

for i=1:numG
       
    im_g = imread(strcat(dirGlaucoma,'Originales\',listG(listTraG(i)).name));
    copa_g = imread (strcat(dirGlaucoma,'Disco Optico\',listCopaG(listTraG(i)).name));
    disk_g = imread (strcat(dirGlaucoma,'Copa\',listDiskG(listTraG(i)).name));    
    
    name_im = strcat(ResulG_NG{2},'\Glaucoma\Originales\',listG(listTraG(i)).name);
    name_copa = strcat(ResulG_NG{2},'\Glaucoma\Copa\',listCopaG(listTraG(i)).name);
    name_disk = strcat(ResulG_NG{2},'\Glaucoma\Disco Optico\',listDiskG(listTraG(i)).name);    
  
    imwrite(im_g, name_im); 
    imwrite(copa_g, name_copa); 
    imwrite(disk_g, name_disk); 
    
end

% No Glaucoma

for i=1:numNG
      
    im_ng = imread(strcat(dirNoGlaucoma,'Originales\',listNG(listTraNG(i)).name));
    copa_ng = imread (strcat(dirNoGlaucoma,'Disco Optico\',listCopaNG(listTraNG(i)).name));
    disk_ng = imread (strcat(dirNoGlaucoma,'Copa\',listDiskNG(listTraNG(i)).name));    
    
    name_im = strcat(ResulG_NG{2},'\NoGlaucoma\Originales\',listNG(listTraNG(i)).name);
    name_copa = strcat(ResulG_NG{2},'\NoGlaucoma\Copa\',listCopaNG(listTraNG(i)).name);
    name_disk = strcat(ResulG_NG{2},'\NoGlaucoma\Disco Optico\',listDiskNG(listTraNG(i)).name);    
  
    imwrite(im_ng, name_im); 
    imwrite(copa_ng, name_copa); 
    imwrite(disk_ng, name_disk); 
    
end


%% Test G_NG

% Glaucoma

for i=1:length(listG) - numG
    
    
    im_g = imread(strcat(dirGlaucoma,'Originales\',listG(listTestG(i)).name));
    copa_g = imread (strcat(dirGlaucoma,'Disco Optico\',listCopaG(listTestG(i)).name));
    disk_g = imread (strcat(dirGlaucoma,'Copa\',listDiskG(listTestG(i)).name));    
    
    name_im = strcat(ResulG_NG{1},'\Glaucoma\Originales\',listG(listTestG(i)).name);
    name_copa = strcat(ResulG_NG{1},'\Glaucoma\Copa\',listCopaG(listTestG(i)).name);
    name_disk = strcat(ResulG_NG{1},'\Glaucoma\Disco Optico\',listDiskG(listTestG(i)).name);      
  
    imwrite(im_g, name_im); 
    imwrite(copa_g, name_copa); 
    imwrite(disk_g, name_disk); 
    
end

% No Glaucoma

for i=1:length(listNG)-numNG
    
    im_ng = imread(strcat(dirNoGlaucoma,'Originales\',listNG(listTestNG(i)).name));
    copa_ng = imread (strcat(dirNoGlaucoma,'Disco Optico\',listCopaNG(listTestNG(i)).name));
    disk_ng = imread (strcat(dirNoGlaucoma,'Copa\',listDiskNG(listTestNG(i)).name));    
    
    name_im = strcat(ResulG_NG{1},'\NoGlaucoma\Originales\',listNG(listTestNG(i)).name);
    name_copa = strcat(ResulG_NG{1},'\NoGlaucoma\Copa\',listCopaNG(listTestNG(i)).name);
    name_disk = strcat(ResulG_NG{1},'\NoGlaucoma\Disco Optico\',listDiskNG(listTestNG(i)).name);      
  
    imwrite(im_ng, name_im); 
    imwrite(copa_ng, name_copa); 
    imwrite(disk_ng, name_disk); 
    
end





