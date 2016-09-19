//метод Эйлера
//на отрезке [a,b]
//c узлами i=0,N;
//и начальным значением y0;
//где f(x,y) правая часть задачи Коши
// dy/dx = f(x,y)
// y(x0) = y0

function res=method1(a,b,N,y0)
    h = (b-a)/N;
    x=a:h:b;
    y=x;
    y(1) = y0;
    for i=2:length(x)
        y(i) = y(i-1) + h*f(x(i-1),y(i-1));
    end
    res = y;
endfunction
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
function checkMethod1

    k=0.12752;
    N=1000;
    a=1;
    b=12;
    h=(b-a)/N;
    x=a:h:b;
    deff('y=fi(x)','y=sin(x)+2*log(x*3)');
    //deff('y=fi(x)','y=sin(x)');//y=sin(x);
    y=fi(x);
    y0=fi(a);
    deff('z=f(x,u)','z=cos(x)+k*(u-sin(x))');
    y1=method1(a,b,N,y0);
    
    //xgrid();
    //plot(x,y);
    //plot(x,y1,'r--');
    e=abs(y1-y);
    emax = max(e);
    printf("на [%1.2f,%1.2f] при N=%d, k=%1.3f\n",a,b,N,k);
    printf("h=%1.15f\n",h);
    printf("emax=%1.15f\n",emax);
endfunction
function checkMethod2

    k=0.1275;
    s=10;
    N=100;
    a=1;
    b=12;
    h=(b-a)/N;
    x=a:h:b;
    deff('y=fi(x)','y=sin(x)+2*log(x*3)');
    //deff('y=fi(x)','y=sin(x)');//y=sin(x);
    y=fi(x);
    y0=fi(a);
    deff('z=f(x,u)','z=cos(x)+k*(u-sin(x))');
    y1=method2(a,b,N,y0,s);
    
    xgrid();
    plot(x,y);
    plot(x,y1,'r--');
    e=abs(y1-y);
    emax = max(e);
    printf("на [%1.2f,%1.2f] при N=%d, k=%1.3f\n",a,b,N,k);
    printf("h=%1.15f\n",h);
    printf("emax=%1.15f\n",emax);
endfunction
checkMethod1;
