 //функция
// deff('y=fi(x)','y=sin(x)+2*log(x*3)');
deff('y=fi(x)','y=exp(-x)+x-1');

deff('z=f(x,y,k)','z=x - y');
  //правая часть диф. уравнения
//  deff('z=f(x,u,k)','z=cos(x)+2/x+k*(u-sin(x)-2*log(x*3))');
    a=0;
    b=1;
    
 
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
//        y(i) = y(i-1) + h*f(x(i-1),y(i-1),k);
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
        ys0 = y(i-1) + h*f(x(i-1),y(i-1),k);
        for j=1:s
            ysi = y(i-1) + h*(f(x(i-1),y(i-1),k) + f(x(i),ys0,k))/2;
            ys0 = ysi;
        end
        y(i) = ys0;
    end
    res = y;
endfunction
function graphics(x,y,y1)
    xgrid();
    xtitle("f(x) = sin(x)+2ln(3x)","X","Y");
    plot(x,y);
    plot(x,y1,'r--');
endfunction
function writeInFile(file,N,k,s,emax,erel,x,y,y1)
    fd= mopen(file,'w');
    
        mfprintf(fd,"на [%1.2f,%1.2f] при N=%d, k=%1.3f s=%d\n",a,b,N,k,s);
        mfprintf(fd,"h=%1.15f hh=%1.15f\n",h,h/(2^s));
        mfprintf(fd,"emax=%1.15f\n",emax);
        for i=1:length(erel)
            mfprintf(fd,"x(%2d)=%1.15f \t y(%2d)=%1.15f \t y1(%2d)=%1.15f \t eabs(%2d)=%1.15f\n",i,x(i),i,y(i),i,y1(i),i,erel(i)*100);
        end
        mclose(fd);
endfunction
function printBrif(file,N,k,h,emax)
        fd=mopen(file,'a+');
        mfprintf(fd,"на [%1.2f,%1.2f] при N=%d, k=%1.3f,h=%1.15f\n",a,b,N,k,h);
        mfprintf(fd,"emax=%1.15f\n",emax);
        mclose(fd);
endfunction
function checkMethod1
    file='method1e.txt';
    km=[0.12752];
    step = 2;
   // km = 0.01:0.001:0.02;
    
    Kmin = 0;
    Emin = -1;
    Nopt = 0;
    Hmin = 0;
    for j=1:length(km)
        k = km(j);
        N = 5;
        for i=1:1
            N = N*2;
            h=(b-a)/N;
            x=a:h:b;
            y=fi(x);
            y0=0;//fi(a);
            y1=method1(a,b,N,y0,k,step);
            e=abs(y1-y);
            tmp = y(1);
            y(1) = 1;
            erel = e./y;
            y(1) = tmp;
            emax = max(e);
            s=step;
            writeInFile('method1.txt',N,k,s,emax,erel,x,y,y1);
           printBrif(file,N,k,h,emax);
            if Emin == -1 then
                Emin = emax;
                Nopt = N;
                Kmin = k;
                Hmin = h;
            else
                if Emin > emax then
                    Emin = emax;
                    Nopt = N;
                    Kmin = k;
                    Hmin = h;
                end
            end
        end
    end
    printf("Nopt=%d,Kmin=%1.5f,Hmin = %1.15f, Emin=%1.15f\n",Nopt,Kmin,Hmin,Emin);
    h=(b-a)/Nopt;
    x=a:h:b;
    y=fi(x);
    y0=fi(a);
    y1=method1(a,b,Nopt,y0,Kmin,step);
    graphics(x,y,y1);
    
endfunction
//function checkMethod2
//
//    k=0.2;
//    s=3;
//    N=10;
//    h=(b-a)/N;
//    x=a:h:b;
//    y=fi(x);
//    y0=fi(a);
//
//    y1=method2(a,b,N,y0,s,k);
//    
//    graphics(x,y,y1);
//    
//    e=abs(y1-y);
//    tmp = y(1);
//    y(1) = 1;
//    erel = e./y;
//    y(1) = tmp;
//    emax = max(e);
//    
//    printf("на [%1.2f,%1.2f] при N=%d, k=%1.3f s=%d\n",a,b,N,k,s);
//    printf("h=%1.15f\n",h);
//    printf("emax=%1.15f\n",emax);
//    //writeInFile('method1.txt',N,k,s,emax,erel,x,y,y1);
//endfunction
checkMethod1;
