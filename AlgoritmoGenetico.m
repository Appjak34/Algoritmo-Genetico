%%%%%%%%%% ALGORITMO GENETICO DE ALINEAMIENTO DE SECUENCIAS %%%%%%%%%%% 
%%Angel Emilio Lopez Fernandez
%%Cervantes Melendez Georgina

%%%%%% Funciones%%%%%%%%%%%%%%%%
function z = convertirletrasanum(letra)
    if letra == 'A'
        z=1;
    elseif letra == 'G'
        z=2;
    elseif letra == 'T'
        z=3;
    elseif letra == 'C'
        z=4;
    end
end


function C =convertirnumaletr(matriz)
    for n=1:size(matriz,1)
        for n2=1:size(matriz,2)
            letra =matriz(n,n2);
            if letra == 1
                z='A';
                C(n,n2) = cellstr(z);
            elseif letra == 2
                z='G';
                C(n,n2) = cellstr(z);
            elseif letra == 3
                z='T';
                C(n,n2) = cellstr(z);
            elseif letra == 4
                z='C';
                C(n,n2) = cellstr(z);
            elseif letra == 0
                z='-';
                C(n,n2) = cellstr(z);
            end
        end
    end
end

function NM = filamaslarga(matriz)
e=matriz(1,:);
NM=matriz;
   for n=1:size(matriz,1)-1
       for n2=n+1:size(matriz,1)
        if size(find(matriz(n,:)==0),2) <= size(find(matriz(n2,:)==0),2)
            NM(1,:)= matriz(n,:);
            NM(n,:)=e;
        elseif size(find(matriz(n2,:)==0),2) <= size(find(matriz(n,:)==0),2)
            NM(1,:)= matriz(n2,:);
            NM(n2,:)=e;
        end
   end
end

function y = revisacadenas(v1,v2,colum)
    evaluacion = 0;
        for n=1:colum
            if v1(n) == v2(n)
                if v1(n) ~= 0 
                    evaluacion = evaluacion + 1;
                end
            else
                if v1(n) == 0 || v2(n) == 0
                    evaluacion = evaluacion - 1;
                else
                    evaluacion = evaluacion - 0 ;
                end
            end 
        end
    y=evaluacion;
end

%%%%%%%%% INICIO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all,clc

numiter=1000;
nv1=input('Ingrese el numero de vectores a leer: ')
disp(' ')
vect2=[];

for n1=1:nv1
    nv=input('Ingrese el numero de elemento a leer: ')
    disp(' ')
    vect=[];
    for  n=1:nv
        nv=input(['Ingrese el valor de V(',num2str(n),'): '])
        vect2(n1,n)=convertirletrasanum(nv);
    end
end

vect2;
numfila= size(vect2,1);    
numcol= size(vect2,2);
porciento= round((20*numcol)/100);

if porciento ~=0
    auxPorciento(numfila, porciento)=0;
else
    auxPorciento(numfila, 1)=0;
end

vect2= [vect2 auxPorciento];
numcol=size(vect2,2);
vect3=vect2;
    
for conv=1:15
    vect2=vect3
    for n=1:numfila;
        num = size(find(vect2(n,:)==0),2);
        nuevapos = randi(numcol,[1,num]);
        fila=vect2(n,:);
        for j=1:num
            subfila=fila(1 :nuevapos(j));
            subfila(nuevapos(j))=0;
            subfila1=fila(nuevapos(j) :numcol-1);
            fila=[subfila subfila1];
        end
        vect2(n,:)=fila;
    end

    for i=1:numiter  
        for n=1:numfila-1
        aux=vect2(n,:);
            for p=n+1:numfila 
                aux2=vect2(p,:);
                num = size(find(aux2==0),2);
                nuevapos = randi(numcol-porciento,[1,num]);
                fila=[aux2 revisacadenas(aux,aux2,numcol)];
                s=vect3(p, :);
                    for n2=1:num
                        subfila=s(1 :nuevapos(n2));
                        subfila(nuevapos(n2))=0;
                        subfila1=s(nuevapos(n2) :numcol-1);
                        fila2=[subfila subfila1 ];
                        auxfila2=[fila2 revisacadenas(aux,fila2,numcol)];
                        if auxfila2(1,numcol+1) >= fila(1,numcol+1)
                            fila=[fila2(1 :numcol) revisacadenas(aux,fila,numcol)];
                        end
                        s=fila2(1 ,:);
                    end
                    vect2(p,:)=fila(1 :numcol);
            end  
        end       
    end                

    LM(:,:,conv)=vect2;
    LM2(:,:,conv)=vect2;
    LMX2(:,:,conv)=vect2; 
end

K=[];
K2=[];

for i=2:15
    for n=1:numfila
        for p=n+1:numfila
            K=[K ; revisacadenas(LMX2(n,:,i-1),LMX2(p,:,i-1),numcol)];
            K2=[K2 ; revisacadenas(LMX2(n,:,i),LMX2(p,:,i),numcol)];
        end
    end
    S = sum(K);
    S2 = sum(K2);
    if S >= S2
        LMX=LMX2(:,:,i-1);
        LMX2(:,:,i)=LMX2(:,:,i-1);
    elseif S2 >= S
        LMX=LMX2(:,:,i);
        LMX2(:,:,i) = LMX2(:,:,i);
    end
    S = 0;
    S2 = 0;
    K=[];
    K2=[];
end
fin = LMX;
convertirnumaletr(fin)