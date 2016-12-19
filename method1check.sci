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

//метод предиктор-корректор с итерационной обработко
function res=method2(a,b,N,y0,s,k,step)
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

function  e=Emax(y,y1)
    ee=abs(y1-y);
    e= max(ee);
endfunction

function graphics(x,y,l)
    xgrid();
    xtitle("f(x) = sin(x)+2ln(3x)","X","Y");
    xx=a:0.1:b;
    yy=fi(xx);
    plot(xx,yy);
    plot2d(x,y,style=color('red'),leg=l);
endfunction
function logGraphics(ep,nn)
    xgrid();
    xtitle("Зависимость е от N в методе Эйлера","N","e");
    
    plot2d("ll",nn,ep,style=color('blue'));
endfunction

function writeInFile(file,N,k,s,emax,erel,x,y,y1,y2,y3)
    fd= mopen(file,'a+');
    
        p1=Emax(y,y1)/Emax(y,y2);
        p2=(Emax(y,y1)-Emax(y,y2))/(Emax(y,y2)-Emax(y,y3));

        mfprintf(fd,"%1.15f\t%1.15f\t%1.15f\t%1.15f\n",(b-a)/N,emax,log2(p1),log2(p2));

        mclose(fd);
endfunction

function printBrif(file,N,k,h,emax)
        fd=mopen(file,'a+');
        mfprintf(fd,"на [%1.2f,%1.2f] при N=%d, k=%1.3f,h=%1.15f\n",a,b,N,k,h);
        mfprintf(fd,"emax=%1.15f\n",emax);
        mclose(fd);
endfunction

//function checkMethod1
    file='method1e.txt';
    fd=mopen(file,'w');
    mclose(fd);
    km=[0.15];
    step = 1;
   // km = 0.01:0.001:0.02;
    
//    Kmin = 0;
//    Emin = -1;
//    Nopt = 0;
//    Hmin = 0;
    ep=[0 2];
    nn=[0 3];
    for j=1:length(km)
        k = km(j);
        N = 5;
        leg = "";
        for i=1:1

            N = N*2;
           
            leg=leg +"N="+string(N);
            h=(b-a)/N;
            x=a:h:b;
            y=fi(x);
            y0=fi(a);
            s=2;
            y1=method1(a,b,N,y0,k,0);
            y2=method1(a,b,N,y0,k,1);
            y3=method1(a,b,N,y0,k,2);
//            y1=method2(a,b,N,y0,s,k,1);
//            y2=method2(a,b,N,y0,s,k,2);
//            y3=method2(a,b,N,y0,s,k,3);
            epr=y2-y1;
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
            eprmax=max(abs(epr));
             nn(i)=N;
            ep(i)=emax;
            leg=leg+",e="+string(emax)+" ";
//            graphics(x,y1,leg);
//            leg=leg+"\n";
            s=step;
            writeInFile('method1.txt',N,k,s,emax,erel,x,y,y1,y2,y3);
            printBrif(file,N,k,h,emax);
            printBrif(file,N,k,h/2,eprmax);
           // if Emin == -1 then
             //   Emin = emax;
               // Nopt = N;
               // Kmin = k;
               // Hmin = h;
           // else
             //   if Emin > emax then
               //     Emin = emax;
                 //   Nopt = N;
                //    Kmin = k;
                //    Hmin = h;
            //    end
        //    end
        end
        
    end
//    printf("Nopt=%d,Kmin=%1.5f,Hmin = %1.15f, Emin=%1.15f\n",Nopt,Kmin,Hmin,Emin);
//    logGraphics(ep,nn);
//    h=(b-a)/Nopt;
//    x=a:h:b;
//    y=fi(x);
//    y0=fi(a);
//    y1=method1(a,b,Nopt,y0,Kmin,step);
//    graphics(x,y,y1);
    
//endfunction

//checkMethod1;
