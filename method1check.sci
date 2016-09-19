//метод Эйлера
//на отрезке [a,b]
//c узлами i=0,N;
//и начальным значением y0;
//где f(x,y) правая часть задачи Коши
// dy/dx = f(x,y)
// y(x0) = y0

//function res=method1(a,b,N,y0)
//    h = (b-a)/N;
//    x=a:h:b;
//    y=x;
//    y(1) = y0;
//    for i=2:length(x)
//        y(i) = y(i-1) + h*f(x(i-1),y(i-1));
//    end
//    res = y;
//endfunction
function res=method2(a,b,N,y0,s)
    h=(b-a)/N;
    x=a:h:b;
    y=x;
    y(1)=y0;
    for i=2:length(x)
        ys0 = y(i-1) + h*f(x(i-1),y(i-1));
        for j=1:s
            ysi = y(i-1) + h*(f(x(i-1),y(i-1)) + f(x(i),ys0))/2;
            ys0 = ysi;
        end
        y(i) = ys0;
    end
    res = y;
endfunction
//function checkMethod1
//
//    k=0.12752;
//    N=10;
//    a=0;
//    b=1;
//    h=(b-a)/N;
//    x=a:h:b;
//    //deff('y=fi(x)','y=sin(x)+2*log(x*3)');
//    //deff('y=fi(x)','y=sin(x)');//y=sin(x);
//    deff('y=fi(x)','y=exp(-x)+x-1');
//    y=fi(x);
//    y0=0;//fi(a);
////    deff('z=f(x,u)','z=cos(x)+k*(u-sin(x))');
//deff('z=f(x,u)','z=x-u');
//    y1=method1(a,b,N,y0);
//    
//    //xgrid();
//    //plot(x,y);
//    //plot(x,y1,'r--');
//    e=abs(y1-y);
//    tmp = y(1);
//    y(1) = 1;
//    eabs = e./y;
//    y(1) = tmp;
//    emax = max(e);
//    printf("на [%1.2f,%1.2f] при N=%d, k=%1.3f\n",a,b,N,k);
//    printf("h=%1.15f\n",h);
//    printf("emax=%1.15f\n",emax);
//    for i=1:length(eabs)
//        printf("x(%d)=%1.15f \t y(%d)=%1.15f \t y1(%d)=%1.15f \t eabs(%d)=%1.2f\n",i,x(i),i,y(i),i,y1(i),i,eabs(i)*100);
//    end
//endfunction
function checkMethod2

    k=0.12752;
    s=3;
    N=80;
    a=1;
    b=12;
    h=(b-a)/N;
    x=a:h:b;
//    deff('y=fi(x)','y=exp(-x)+x-1');
    deff('y=fi(x)','y=sin(x)+2*log(x*3)');
    //deff('y=fi(x)','y=sin(x)');//y=sin(x);
    y=fi(x);
    y0=fi(a);
    deff('z=f(x,u)','z=cos(x)+k*(u-sin(x))');
//    deff('z=f(x,u)','z=x-u');
    y1=method2(a,b,N,y0,s);
    
    xgrid();
    xtitle("f(x) = sin(x)+2ln(3x)","X","Y");
    plot(x,y);
    plot(x,y1,'r--');
    e=abs(y1-y);
    tmp = y(1);
    y(1) = 1;
    eabs = e./y;
    y(1) = tmp;
    emax = max(e);
    fd= mopen('method1.txt','w');
    
        mfprintf(fd,"на [%1.2f,%1.2f] при N=%d, k=%1.3f s=%d\n",a,b,N,k,s);
        mfprintf(fd,"h=%1.15f\n",h);
        mfprintf(fd,"emax=%1.15f\n",emax);
        for i=1:length(eabs)
            mfprintf(fd,"x(%2d)=%1.15f \t y(%2d)=%1.15f \t y1(%2d)=%1.15f \t eabs(%2d)=%1.15f\n",i,x(i),i,y(i),i,y1(i),i,eabs(i)*100);
        end
     mclose(fd);
//    end
endfunction
checkMethod2;
