clear all;
vid = videoinput('winvideo', 1,'YUY2_640x480');
%vid = videoinput('matrox', 1,'RGB24_640x480');
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb');
vid.FrameGrabInterval = 5;
num=0;
count=0;
%start the video aquisition here
cnt(1)=100;
cnt(2)=100;
import java.awt.Robot;
mouse = Robot;
t=0;
 mouse.mouseMove(0, 0);
screenSize = get(0, 'screensize');

while(num<10)
 
%dialogue box
t=0;
str={'static gsture','dynamic gesture','virtual mouse','exit'} ;
[s,v] = listdlg('PromptString','SELECT THE OPERATION:',...
                 'name','HAND GESTURE RECOGNITION SYSTEM','SelectionMode','single',...
                'ListSize',[250 250],'ListString',str,'uh',30);
    
           
   if(v==0)
       break;
   end
   
switch s
    
case 1
%-------------------------------------------------------------------------
%static gesture
%-------------------------------------------------------------------------
prompt = {'Enter k value','enter the angle threshold'};
dlg_title = 'threshold values';
num_lines = 1;
def = {'33','60'};
th = inputdlg(prompt,dlg_title,num_lines,def);


while(t<10)
 start(vid);
    
 %CH=0;
while(vid.FramesAvailable<=30)
    
    % Get the snapshot of the current frame
    data = getsnapshot(vid);
    %SKIN COLOUR EXTRACTION
    J=rgb2ycbcr(data);
    L=graythresh(J(:,:,2));
    BW=im2bw(J(:,:,2),L);
    BW1=~BW;
    M=graythresh(J(:,:,3));
    BW2=im2bw(J(:,:,3),M);
    o=BW1.*BW2;
    roi=o;
%     
   % se = strel('line',11,90);
   se = strel('diamond', 4) ;
   I2 = imdilate(roi,se);
    
    Lw=bwlabel(I2);
    stat = regionprops(Lw,'Area');
    [cal,index] = max([stat.Area]);
    tf = ismember(Lw, index);
    stats1 = regionprops(tf, 'BoundingBox', 'Centroid');
    %---clc--------------------------------------------------
    
    grayFrame=tf;
    %canny for hand coutour extraction
    canny_op = edge(grayFrame,'canny');
    L = bwlabel(canny_op,8);
    stats = regionprops(L,'Area');
    [cal,index] = max([stats.Area]);
    %%% display(cal);
    pix = ismember(L,index);
    
    %k = ceil(sqrt(cal)/3);
    k = str2num(th{1});
    
      % k=33;
    % imshow(L);
    % figure,imshow(pix);
  
    Q=pix;
    [start_row,start_col]=find(Q,1);
    hand_boundary_canny = bwtraceboundary(Q,[start_row,start_col],'ne',8,Inf,'clockwise');
    Q=hand_boundary_canny;

  
    len=size(Q);
    l=len(1);
    %theta=zeros(l,1);
    for i=k:1:l-k
        if (i==k)
            continue;
        end
        X1=Q(i,1);
        X2=Q(i+k,1);
        X3=Q(i-k,1);
        Y1=Q(i,2);
        Y2=Q(i+k,2);
        Y3=Q(i-k,2);
        m1=(Y2-Y1)/(X2-X1);
        m2=(Y3-Y1)/(X3-X1);
        theta(i)=atand((m2-m1)/(1+m1*m2));

    end
% imshow(qq);
% % qq=zeros(pp);
% L3 = zeros(size(Q,1),size(Q,2));
% 
% 
% yy=size(theta);
% t=1:yy(:,2);
%plot(t,theta,'r*');
[ww ee]=find(theta> str2num(th{2})& theta<90);
es=size(ee);
%imshow(pix);
%plot(Q(:,1),Q(:,2),'r.');
[pp bb]=size(L);
ab=zeros(pp,bb);
%ab=[];
%ab(Q)=1;
% figure,imshow(ab)
   for j=1:es(1,2)
      m=ee(j);
              if(m>size(Q,1))
                  continue;
              end
      % ab(Q(m,1),Q(m,2))=250;
      ab(Q(m,1)-1:Q(m,1)+1,Q(m,2)-1:Q(m,2)+1)=250;
      %hold on;
%    plot(Q(m,1),Q(m,2),'g*','LineWidth',20,...
%                  'MarkerEdgeColor','y',...
%                  'MarkerFaceColor','r',...
%                  'MarkerSize',20);
   end

   
     m=ab|L;
    % imshow(m);
     se = strel('disk',14);
     closeBW = imdilate(ab,se);
     
   
    
     %imshow(~closeBW);
     [L num]=bwlabel(closeBW);
     %disp(num)
     f=regionprops(L,'centroid','BoundingBox');
      box=cat(1,f.BoundingBox);
     centroids = cat(1, f.Centroid);
      if(numel(centroids)==0)
          centroids=[start_row,start_col];
      end
     
    imshow(data)
    hold on
    plot(centroids(:,1), centroids(:,2),'g.','LineWidth',5,...
                 'MarkerEdgeColor','y',...
                 'MarkerFaceColor','y',...
                'MarkerSize',20);

     %figure,imshow(ab)
     % figure,plot(t,theta)
    switch num
        
           case 1
            m=text(600,150,'1');
            k=1;
            %disp('1');
           case 2
            %disp('1');
            m=text(600,150,'1');
            k=1;
           case 3
            % disp('2');
            m=text(600,150,'2');
            k=2;
           case 4
            %disp('2');
            m=text(600,150,'2');
            k=2;
           case 5
            %disp('3');
            m=text(600,150,'3');
            k=3;
           case 6
            %disp('3');
            m=text(600,150,'3');
            k=3;
           case 7
            %disp('4');
            m=text(600,150,'4');
            k=4;
           case 8
            %disp('4');
            m=text(600,150,'4');
            k=4;
           case 9
            %disp('5');
            m=text(600,150,'5');
            k=5;
           case 10
            %disp('5');
            m=text(600,150,'5');
            k=5;
           otherwise
            %disp('5');
            m=text(600,150,'5');
            k=5;
             
    end
    
   %...................................................
    

    
    
    %-----------------------------------------------------
    
    
    %This is a loop to bound the skin colour in a rectangular box.
    for object = 1:length(stats1)
        bb = stats1(object).BoundingBox;
        bc = stats1(object).Centroid;
        rectangle('Position',bb,'EdgeColor','b','LineWidth',1)
        plot(bc(1),bc(2), '-m+')
              
%          if(bc(:,1)>700)   
%             a=text(200,50,'left');
%         else
%             a=text(200,50,'right');
%         end
%         
%         if (bc(:,2)>350)
%             b=text(600,50,'down');
%         else
%             b=text(600,50,'up');
%         end
% 
%         set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 30, 'Color', 'red');
%         set(b, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 30, 'Color', 'red');
%        set(m, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 30, 'Color', 'red');
%        set(text(60,500,'DYNAMIC GESTURE RECOGNITION'), 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'green'); 
%         mouse.mouseMove(bc(:,1), bc(:,2));
%         pause(0.00001);
        count=[];
       if(vid.FramesAvailable>=15)
            set(text(50,50,'.'), 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 50, 'Color', 'red');
            set(m, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 10, 'Color', 'black');
            count=[count ;k]
             
       end
        
    end
    
    
   
end
hold off;

num=mode(count);
count=[];

disp(num);
%warndlg(num2str(num));
mm=num2str(num);
st=' is the count';
mm=[mm st];
% Construct a questdlg with three options
choice = questdlg(mm, ...
	'count', ...
	'I WANT TO CONTINUE','NO','NO');
% Handle response
if(strcmp(choice,'I WANT TO CONTINUE'))

        CH = 1;
        t=t+1;
        stop(vid);
        flushdata(vid);
end
 if(strcmp(choice,'NO'))     		
     stop(vid) ; 
     break;
 end
       
 
    close all;
   
end
stop(vid);  
flushdata(vid);

    
case 2

%-------------------------------------------------------------------------
%dynamic gesture
%-------------------------------------------------------------------------
start(vid); 
while(vid.FramesAvailable<=30)

    % Get the snapshot of the current frame
    data = getsnapshot(vid);
    
    %SKIN COLOUR EXTRACTION
    
    J=rgb2ycbcr(data);
    L=graythresh(J(:,:,2));
    BW=im2bw(J(:,:,2),L);
    BW1=~BW;
    M=graythresh(J(:,:,3));
    BW2=im2bw(J(:,:,3),M);
    o=BW1.*BW2;
    roi=o;

     % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(roi, 'BoundingBox', 'Centroid');
    
    % Display the image
    imshow(data)
    
    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        %rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        %a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        
         if(bc(:,1)>350)   
            a=text(200,50,'left');
        else
            a=text(200,50,'right');
        end
        
        if (bc(:,2)>250)
            b=text(600,50,'down');
        else
            b=text(600,50,'up');
        end
%         if(bc(:,1)>512)   
%             a=text(bc(:,1)+15,bc(:,2),'right');
%         else
%             a=text(bc(:,1)+15,bc(:,2),'left');
%         end
%         
%         if (bc(:,2)>384)
%             b=text(bc(:,1)+100,bc(:,2),'down');
%         else
%             b=text(bc(:,1)+100,bc(:,2),'up');
%         end
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 20, 'Color', 'red');
        set(b, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 20, 'Color', 'red');
    %    set(text(60,500,'DYNAMIC GESTURE RECOGNITION'), 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'green'); 
       % mouse.mouseMove(bc(:,1), bc(:,2));

     %-------------------------------------------------------------------
 end
 end
stop(vid);  
flushdata(vid);
 
    
case 3
    
%-------------------------------------------------------------------
%mouse 
%-------------------------------------------------------------------

start(vid);
while(vid.FramesAvailable<=100)
   

    
    % Get the snapshot of the current frame
    data = getsnapshot(vid);
    
    %SKIN COLOUR EXTRACTION
    
    J=rgb2ycbcr(data);
    L=graythresh(J(:,:,2));
    BW=im2bw(J(:,:,2),L);
    BW1=~BW;
    M=graythresh(J(:,:,3));
    BW2=im2bw(J(:,:,3),M);
    o=BW1.*BW2;
    roi=o;

     % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(roi, 'BoundingBox', 'Centroid');
    
    % Display the image
    imshow(data)
    
    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        bb1=[bc(1) bc(2) bb(3)/4  bb(4)/4];
        rectangle('Position',bb1,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        %a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        
         
        mouse.mouseMove(bc(:,1), bc(:,2));


    end
end
stop(vid);  
flushdata(vid);


case 4
close all;
break;
otherwise
 break;

end

end



