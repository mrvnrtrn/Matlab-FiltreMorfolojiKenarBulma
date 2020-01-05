resim = imread('DaireOkBaloncuk.png'); %resim alýndý
resimGray = resim(:,:,1)*0.2989 + resim(:,:,2)*0.5870 + resim(:,:,3)*0.1140;%resmi griye çevirdik

% medyan filtresi uygulamasý
[r,c]=size(resimGray);
resimMedyan=resimGray;
for i=2:r-3
    for j=2:c-3
        flt=[resimGray(i-1,j+3) resimGray(i,j+3) resimGray(i+1,j+3) resimGray(i+2,j+3) resimGray(i+3,j+3) resimGray(i+1,j+2) resimGray(i+3,j+1) resimGray(i+3,j) resimGray(i+3,j-1) resimGray(i-1,j+2) resimGray(i,j+2) resimGray(i+1,j+2) resimGray(i+2,j+2) resimGray(i+2,j-1) resimGray(i+2,j) resimGray(i+2,j+1) resimGray(i-1,j-1) resimGray(i-1,j) resimGray(i-1,j+1) resimGray(i,j-1) resimGray(i,j) resimGray(i,j+1) resimGray(i+1,j-1) resimGray(i+1,j) resimGray(i+1,j+1)];
        resimMedyan(i,j)=median(flt);
    end
end
% /medyan filtre uygulamasý sonu

% histogram bulma
histog = zeros(1,256);
[r,c] = size(resimMedyan);
for i = 1:r
    for j = 1:c
        histog(1, resimMedyan(i,j)+1) = histog(1, resimMedyan(i,j)+1) + 1;
    end
end
% /histogram bulma sonu

% resmi siyah beyaz yapma
[r,c] = size(resimMedyan);
resimSiyahBeyaz = false(r,c);
for i = 1:r
    for j = 1:c
        if resimMedyan(i,j) < 254
            resimSiyahBeyaz(i,j) = true;
        end
        
    end
end
% /resmi siyah beyaz yapma

% Dilation(genleþme) kodu
genlesmeMatrisi=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;];
KenarDoldurma=padarray(resimSiyahBeyaz,[0 3]);
resimDilation=true(size(resimSiyahBeyaz));
for i=1:size(KenarDoldurma,1)
    for j=1:size(KenarDoldurma,2)-24
        resimDilation(i,j)=sum(genlesmeMatrisi&KenarDoldurma(i,j:j+24));
    end
end
% /Dilation(genleþme) kodu sonu

% Erosion(aþýnma) kodu
asinmaMatrisi=[1 1 0];
kenarDoldurma=padarray(resimDilation,[0 1],1);
resimErosion=false(size(resimDilation));
for i=1:size(kenarDoldurma,1)
    for j=1:size(kenarDoldurma,2)-2
        In=kenarDoldurma(i,j:j+2);
        In1=find(asinmaMatrisi==1);
        if(In(In1)==1)
        resimErosion(i,j)=1;
        end
    end
end
% /Erosion(aþýnma) kodu sonu

% /Sobel algoritmasý ile kenar bulma
resminAynasi=double(resimErosion);
for i=1:size(resminAynasi,1)-2
    for j=1:size(resminAynasi,2)-2
        Gx=((2*resminAynasi(i+2,j+1)+resminAynasi(i+2,j)+resminAynasi(i+2,j+2))-(2*resminAynasi(i,j+1)+resminAynasi(i,j)+resminAynasi(i,j+2)));
        Gy=((2*resminAynasi(i+1,j+2)+resminAynasi(i,j+2)+resminAynasi(i+2,j+2))-(2*resminAynasi(i+1,j)+resminAynasi(i,j)+resminAynasi(i+2,j)));
        kenarBul(i,j)=sqrt(Gx.^2+Gy.^2);
    end
end
% /Sobel algoritmasý ile kenar bulma

figure,
subplot(3,3,1);
imshow(resim);
title('Orjinal Resim');
subplot(3,3,2);
imshow(resimGray);
title('Gri Resim');
subplot(3,3,3);
imshow(resimMedyan);
title('Medyan Filtresi');
subplot(3,3,4);
imshow(resimSiyahBeyaz);
title('Siyah Beyaz Resim');
subplot(3,3,5);
imshow(resimDilation);
title('Genleþmiþ Resim');
subplot(3,3,6);
imshow(resimErosion);
title('Aþýnmýþ Resim');
subplot(3,3,8);
imshow(kenarBul);
title('Kenarý Bulunan Resim');