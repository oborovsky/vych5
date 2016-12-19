//функция
 deff('y=fi(x)','y=sin(x)+2*log(x*3)');
  //правая часть диф. уравнения
  deff('z=f(x,u,k)','z=cos(x)+2/x+k*(u-sin(x)-2*log(x*3))');
    a=1;
    b=12;
    
    function res=method1b(a,b,N,y0,k,step,bound)
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
        if i >= bound then
            break;
        end
    end
    res = y;
endfunction
function res=method3b(a,b,N,y0,k,step,bound)
    h=(b-a)/N;
    x=a:h:b;
    y=x;
    y(1) = y0;
    for i=2:length(x)
        y0 = y(i-1);
        hh = h/(2^step);
        x0 = x(i-1);
        for j=1:(2^step)
            k1 = hh*f(x0,y0,k);
            k2 = hh*f(x0 + hh/2, y0 + k1/2, k);
            k3 = hh*f(x0 + hh, y0 - k1 + 2*k2, k);
            y1 = y0 + (k1 + 4*k2 + k3)/6;
            x0 = x0 + hh;
            y0 = y1;
        end
        y(i) = y0;
        if i >= bound then
            break;
        end
    end
    res = y;
endfunction
function res=method4b(a,b,N,y0,k,step,bound)
    h=(b-a)/N;
    x=a:h:b;
    y=x;
    y(1) = y0;
    for i=2:length(x)
        y0 = y(i-1);
        hh = h/(2^step);
        x0 = x(i-1);
        for j=1:(2^step)
            k1 = hh*f(x0,y0,k);
            k2 = hh*f(x0 + hh/2, y0 + k1/2, k);
            k3 = hh*f(x0 + hh/2, y0 + k2/2, k);
            k4 = hh*f(x0 + hh, y0 + k3);
            
            y1 = y0 + (k1 + 2*k2 + 2*k3 + k4)/6;
            x0 = x0 + hh;
            y0 = y1;
        end
        y(i) = y0;
        if i >= bound then
            break;
        end
    end
    res = y;
endfunction
function res=reduce(y,step, N)
    lost = 2^step;
    n = 0;
    yy= [0 0];
//    printf("N = %d, lost=%d\n",N, lost);
    
    for i = 0:N
        yy(i+1) = y(i*lost + 1);
//        printf("yy(%d)=%1.15f\n",i+1,yy(i+1));   
    end
    res=yy;
endfunction
//метод Гира
function res=method6(a,b,N,y0,k,step)
    NN = N*2^step;
    h=(b-a)/NN;
    x=a:h:b;
    y=x;
    y(1) = y0;
//    y = method1b(a,b,NN,y0,k,0,4);
//      y = method3b(a,b,NN,y0,k,0,4);
    y = method4b(a,b,NN,y0,k,0,4);
//    y = fi(x);
//    for i = 1:4
//        printf("%1.15f\n",y(i));
//        
//    end
//    printf("\n");
    for i=5:length(x)
        y_3 = y(i-4);
        y_2 = y(i-3);
        y_1 = y(i-2);
        y0 = y(i-1);
        x_3 = x(i-4);
        x_2 = x(i-3);
        x_1 = x(i-2);
        x0 = x(i-1);
       
            x1 = x(i);
            
            yy = 4*h*f(x0,y0,k) + (y_3-10*y0)/3 - 2*y_2 + 6*y_1;
            y1 = (12*h*f(x1,yy) - 3*y_3 + 16*y_2 -36*y_1 + 48*y0)/25;
            x0 = x0 + h;
            y(i) = y1;
    end
    if step > 0 then
       y = reduce(y, step, N);
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
function writeY(file, y,y1,y2,y3)
    fd = mopen(file,'a+');
    for i = 1:length(y)
        mfprintf(fd,"%1.15f\t %1.15f\t %1.15f\t %1.15f\t\n",y(i),y1(i),y2(i),y3(i));
    end
    mfprintf(fd,"\n");
    mclose(fd);
endfunction
function logGraphics(ep,nn)
//    xgrid();
//    xtitle("Зависимость е от N в методе Эйлера","N","e");
    
    plot2d("ll",nn,ep,style=color('green'));
endfunction

file='method6.txt';
filey = 'y.txt';
    fd=mopen(file,'w');
    mclose(fd);
    fd = mopen(filey,'w');
    mclose(fd);
    km=[0.15];
    step = 1;
    ep6=[0 2];
    nn=[0 3];
    for j=1:length(km)
        k = km(j);
        N = 5;
        leg = "";
        for i=1:9
            N=N*2;
            leg=leg +"N="+string(N);
            h=(b-a)/N;
            x=a:h:b;
            y=fi(x);
            y0=fi(a);

            y1=method6(a,b,N,y0,k,0);
            y2=method6(a,b,N,y0,k,1);
            y3=method6(a,b,N,y0,k,2);
//            writeY(filey,y, y1, y2, y3);
            
            printf("\n");
            epr=y2-y1;
            yr1 = y2 + epr;
            epr2=y3-y2;
            yr2= y3 + epr2;
            i1 = Emax(y,yr1);
            i2 = Emax(y,yr2);
//            printf("p=%1.15f\n",log2(i1/i2));
            
            e=abs(y1-y);
            tmp = y(1);
            erel = e./y;
            y(1) = tmp;
            emax = max(e);
            eprmax=max(abs(epr));
             nn(i)=N;
            ep6(i)=emax;
            leg=leg+",e="+string(emax)+" ";
//            graphics(x,y1,leg);

               s = step;
            writeInFile(file,N,k,s,emax,erel,x,y,y1,y2,y3);

        end
        
    end
//    logGraphics(ep6,nn);
printf("end\n");
