
//функция
 deff('y=fi(x)','y=sin(x)+2*log(x*3)');
  //правая часть диф. уравнения
  deff('z=f(x,u,k)','z=cos(x)+2/x+k*(u-sin(x)-2*log(x*3))');
    a=1;
    b=12;
    
//метод предиктор-корректор с итерационной обработко
function res=method2(a,b,N,y0,s,k,step,lb)
    h=(b-a)/N;
    x=a:h:b;
    y=x;
    y(1)=y0;
    for i=2:length(x)
      y0=y(i-1);
      hh=h/(2^step);
      x0=x(i-1);
      x1=x0+hh;
      for j=1:(2^step) 
          ys0 = y0 + hh*f(x0,y0,k);
            for j=1:s
                ysi = y0 + hh*(f(x0,y0,k) + f(x1,ys0,k))/2;
                if abs(ysi-ys0)/abs(ys0) <= lb then
                    printf("s=%d",j);
                    break;
                end
                ys0 = ysi;
            end
          x0 = x1;
          x1 = x1 + hh;
          y0 = ys0;
      end
      y(i) = ys0;
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
function writeInFile4(file,N,e)
    fd= mopen(file,'a+');
        mfprintf(fd,"%1.15f\t%1.15f\t\n",(b-a)/N,e);
        mclose(fd);
endfunction
function logGraphics(ep,nn)
//    xgrid();
//    xtitle("Зависимость е от N","N","e");
    
    plot2d("ll",nn,ep,style=color('red'));
endfunction
file='method2.txt';
    fd=mopen(file,'w');
    mclose(fd);
//    lb=[0.01 0.001 0.0001 0.00001 0.000001 0.0000001 0.00000001 0.000000001 0.0000000001];
      lb = 0.0000000001;
    step = 1;
    ep2=[0 2];
    nn=[0 3];
    for j=1:1
        k = 0.15;
        N = 5;
        leg = "";
        for i=1:15

            N = N*2;
           
            leg=leg +"N="+string(N);
            h=(b-a)/N;
            x=a:h:b;
            y=fi(x);
            y0=fi(a);

            s=100;

            y1=method2(a,b,N,y0,s,k,0,lb);
//            y2=method2(a,b,N,y0,s,k,1,lb(j));
//            y3=method2(a,b,N,y0,s,k,2,lb(j));
//            printf("\n");
//            epr=abs(y2-y1)/3;
//            ee = abs(y - y2);
//            yr1 = y2 + epr;
//            epr2=y3-y2;
//            yr2= y3 + epr2;
//            i1 = Emax(y,yr1);
//            i2 = Emax(y,yr2);

//            printf("p=%1.15f\n",log2(i1/i2));
           
            e=abs(y1-y);
//            tmp = y(1);
//            erel = e./y;
//            y(1) = tmp;
            emax = max(e);
//            eprmax=max(abs(epr));
//             nn(i)=N;
//            ep2(i)=emax;
//            leg=leg+",e="+string(emax)+" ";
//            graphics(x,y1,leg);

//            s=step;
//            writeInFile(file,N,k,s,emax,1,x,y,y1,y2,y3);
//            writeInFile2(file,N,max(ee), max(epr));
                writeInFile4(file,N,emax);
        end
        
    end
//    logGraphics(ep2,nn);
printf("end\n");
