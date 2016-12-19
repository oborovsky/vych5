
//функция
 deff('y=fi(x)','y=sin(x)+2*log(x*3)');
  //правая часть диф. уравнения
  deff('z=f(x,u,k)','z=cos(x)+2/x+k*(u-sin(x)-2*log(x*3))');
    a=1;
    b=12;
    
 
//метод Эйлера
//на отрезке [a,b]
//c узлами i=0,N;
//и начальным значением y0;
//где f(x,y) правая часть задачи Коши
// dy/dx = f(x,y)
// y(x0) = y0
function res=method1(a,b,N,y0,k,step)
    h=(b-a)/N;
    x=a:h:b;
    y=x;
    y(1) = y0;
    for i=2:length(x)
        y0 = y(i-1);
        hh = h/(2^step);
        x0 = x(i-1);
        for j=1:(2^step)
            y1 = y0 + hh*f(x0,y0,k);
            x0 = x0 + hh;
            y0 = y1;
        end
        y(i) = y0;
    end
    res = y;
endfunction

function writeInFile(file,N,k,s,emax,erel,x,y,y1,y2,y3)
    fd= mopen(file,'a+');
    
        p1=Emax(y,y1)/Emax(y,y2);
        p2=(Emax(y,y1)-Emax(y,y2))/(Emax(y,y2)-Emax(y,y3));

        mfprintf(fd,"%1.15f\t%1.15f\t%1.15f\t%1.15f\n",(b-a)/N,emax,log2(p1),log2(p2));

        mclose(fd);
endfunction
function writeInFile2(file,N,e,e1)
    fd= mopen(file,'a+');
        mfprintf(fd,"%1.15f\t%1.15f\t%1.15f\t\n",(b-a)/N,e,e1);
        mclose(fd);
endfunction
function writeInFile3(file,y,y1,y2)
    fd= mopen(file,'a+');
    for i= i:length(y)
        mfprintf(fd,"%1.15f\t%1.15f\t%1.15f\t%1.15f\t%1.15f\t\n",y(i), y1(i), y2(i), abs(y(i)-y1(i)), abs(y(i)-y2(i)) );
    end
        
        mclose(fd);
endfunction
function logGraphics(ep,nn)
//    xgrid();
//    xtitle("Зависимость е от N в методе Эйлера","N","e");
    
    plot2d("ll",nn,ep,style=color('blue'));
endfunction
file='method1.txt';
    fd=mopen(file,'w');
    mclose(fd);
    km=[0.15];
    step = 1;
   
    for j=1:length(km)
        k = km(j);
        N = 20;
        leg = "";
         ep1=[0 2];
         nn=[0 3];
        for i=1:1

            N = N*2;
           
            leg=leg +"N="+string(N);
            h=(b-a)/N;
            x=a:h:b;
            y=fi(x);
            y0=fi(a);

            y1=method1(a,b,N,y0,k,0);
            y2=method1(a,b,N,y0,k,1);
            y3=method1(a,b,N,y0,k,2);

            epr=y2-y1;
            ee = abs(y - y2);
            yr1 = y2 + epr;
            epr2=y3-y2;
            yr2= y3 + epr2;
            i1 = Emax(y,yr1);
            i2 = Emax(y,yr2);
            printf("p=%1.15f\n",log2(i1/i2));
            
            e=abs(y1-y);
            tmp = y(1);
            erel = e./y;
            y(1) = tmp;
            emax = max(e);
             nn(i)=N;
            ep1(i)=emax;
            leg=leg+",e="+string(emax)+" ";
//            graphics(x,y1,leg);

            s=step;
//            writeInFile(file,N,k,s,emax,erel,x,y,y1,y2,y3);
//              writeInFile2(file,N,max(ee), max(abs(epr)));
               writeInFile3(file,y,y1,yr1);
        end
        
    end
//    logGraphics(ep1,nn);
printf("end\n");
