close all
clc
clear 

%% Este script reescala las imágenes originales de cada base de datos a un valor tal que el resultado del corte sea aprox. 500*500
% Es por esto que cada base de datos tiene un valor de reescalado diferente. Porque por ejemplo las imágenes de HRF comparadas con las de
% Autogla parece que tuvieran zoom.


option = 'sd'; % Puede ser 'sd' para solo el disco o 'ven' para coger un poco más que el disco
pixelPlus = 100; % Se decide el número de pixeles que se quieren tener más alrededor del disco


dirResul = '.\ResultadosCorte\';

if(exist(dirResul,'dir'))
	rmdir(dirResul,'s')
end


listaBBDD = dir('.\InputImages');
BBDD = listaBBDD(3:end);

for i=1:length(BBDD)
    
   lista{i} = dir(strcat('.\InputImages\',BBDD(i).name,'\Originales'));
   lista{i} = lista{i}(3:end);
   mkdir(strcat(dirResul,BBDD(i).name,'\Originales'));
   mkdir(strcat(dirResul,BBDD(i).name,'\Disco Optico'));
   mkdir(strcat(dirResul,BBDD(i).name,'\Copa'));
   
   % Solo DRIVE y HRF tienen GT vasos                
   if strcmp(BBDD(i).name,'Drive') ||  strcmp(BBDD(i).name,'HRF')
      mkdir(strcat(dirResul,BBDD(i).name,'\Vasos'));                   
   end
    
end




for k=1:length(BBDD) % Este for es para cada base de datos
    
    listDisk = dir(strcat('.\InputImages\',BBDD(k).name,'\Disco Optico'));
    listDisk = listDisk(3:end);

    listCopa = dir(strcat('.\InputImages\',BBDD(k).name,'\Copa'));
    listCopa = listCopa(3:end);
        
    disp(['Processing database ' BBDD(k).name])

        for j=1:length(lista{k})  % Este for es para cada imagen en la base de datos 

            
            
            im = imread(strcat('.\InputImages\',BBDD(k).name,'\Originales\',lista{k}(j).name));

            [fil,col,m]=size(im);  

            scale = max([fil col]);    
            
            disk = imread(strcat('.\InputImages\',BBDD(k).name,'\Disco Optico\',listDisk(j).name));

            copa = imread(strcat('.\InputImages\',BBDD(k).name,'\Copa\',listCopa(j).name));    


        switch BBDD(k).name

            case 'RIM'

             im  =  imresize(im, 180/scale);   
             disk = imresize(disk, 180/scale);  
             copa = imresize(copa, 180/scale); 

             disk = disk > 128;
             copa = copa > 128;


            case 'HRF'

              listVasosHRF = dir(strcat('.\InputImages\',BBDD(k).name,'\Vasos'));
              listVasosHRF = listVasosHRF(3:end);
              
              vasos = imread(strcat('.\InputImages\',BBDD(k).name,'\Vasos\',listVasosHRF(j).name));  
                
            % Reescalando imagenes
             im  =  imresize(im, 1200/scale);   
             disk = imresize(disk, 1200/scale); 
             copa = imresize(copa, 1200/scale);
             vasos = imresize(vasos, 1200/scale);


             disk = disk > 128;
             copa = copa > 128;

            case 'Drive'

              listVasosDRIVE = dir(strcat('.\InputImages\',BBDD(k).name,'\Vasos'));
              listVasosDRIVE = listVasosDRIVE(3:end);
              
              vasos = imread(strcat('.\InputImages\',BBDD(k).name,'\Vasos\',listVasosDRIVE(j).name));                

            % Reescalando imagenes
              im  =  imresize(im, 800/scale);   
              disk = imresize(disk, 800/scale);       
              copa = imresize(copa, 800/scale);
              vasos = imresize(vasos, 800/scale);              


              disk = disk > 128;
              copa = copa > 128;

            case '12Octubre'  
                
            % El tamaño de estas imágenes son las de referencia.

            disk = disk > 128;
            copa = copa > 128;

            case 'Drishti'

             im = imresize(im, 768/scale);   
             disk = imresize(disk, 768/scale);  
             copa = imresize(copa, 768/scale);


             disk = disk == 255;
             copa = copa == 255;


            case 'Autogla'
            % Reescalando imagenes
             im = imresize(im, 768/scale);   
             disk = imresize(disk, 768/scale);  
             copa = imresize(copa, 768/scale); 


             disk = disk > 128;
             copa = copa > 128;

            otherwise
                      disp('BBDD no disponible')


        end



            %% Se recorta la imagen    

            if strcmp(option, 'ven')

                Imzeros = zeros(size(disk));
                cenDisk = regionprops(disk,'centroid');
                diaDisk = regionprops(disk,'EquivDiameter');
                filL = round(cenDisk.Centroid(1)) - round(diaDisk.EquivDiameter/2) - pixelPlus;
                filH = round(cenDisk.Centroid(1)) + round(diaDisk.EquivDiameter/2) + pixelPlus;
                colL = round(cenDisk.Centroid(2)) - round(diaDisk.EquivDiameter/2) - pixelPlus;
                colH = round(cenDisk.Centroid(2)) + round(diaDisk.EquivDiameter/2) + pixelPlus;
                
                if filL < 1
                    filL = 1;
                end
                
                if colL < 1
                    colL = 1;
                end
                
                if colH > size(im,1)
                    colH = size(im,1);
                end                
                
                if filH > size(im,2)
                    filH = size(im,2);
                end

                im = im(colL:colH,filL:filH,:);
                disk = disk(colL:colH,filL:filH,:);
                copa = copa(colL:colH,filL:filH,:);
                
                % Solo DRIVE y HRF tienen GT vasos
                if strcmp(BBDD(k).name,'Drive') ||  strcmp(BBDD(k).name,'HRF')
                    vasos = vasos(colL:colH,filL:filH,:);
                    
                end
                

            else     

                s = regionprops(disk,'boundingbox');
                disk = imcrop(disk,s.BoundingBox);
                im = imcrop(im,s.BoundingBox);
                copa = imcrop(copa,s.BoundingBox);
                
                % Solo DRIVE y HRF tienen GT vasos                
                if strcmp(BBDD(k).name,'Drive') ||  strcmp(BBDD(k).name,'HRF')
                    vasos = imcrop(vasos,s.BoundingBox);                    
                end

            end
           
            imwrite(im,strcat(dirResul,BBDD(k).name,'\Originales\',lista{k}(j).name));
            imwrite(disk,strcat(dirResul,BBDD(k).name,'\Disco Optico\',listDisk(j).name));
            imwrite(copa,strcat(dirResul,BBDD(k).name,'\Copa\',listCopa(j).name));
            
            % Solo DRIVE y HRF tienen GT vasos                
            if strcmp(BBDD(k).name,'Drive') 
               imwrite(vasos,strcat(dirResul,BBDD(k).name,'\Vasos\',listVasosDRIVE(j).name));                    
            end
            
            if strcmp(BBDD(k).name,'HRF')
               imwrite(vasos,strcat(dirResul,BBDD(k).name,'\Vasos\',listVasosHRF(j).name));                    
            end            
    
    
        end
        
end

       

