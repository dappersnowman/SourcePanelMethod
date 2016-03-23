function [xmid, Cpi] = sourcepanel(x, y, panelNumber, alpha, shouldPlot)
	if ~exist('panelNumber', 'var')
		panelNumber = 5000;
	end

    if ~exist('alpha', 'var')
        alpha = 0;
    end

    if ~exist('shouldPlot', 'var')
        shouldPlot = '-n';
    end

    if (mod(panelNumber, 2))
        panelNumber = panelNumber + 1;
    end

    Vo = 1;
    %getting panel x values
    N = panelNumber/2;
    dx = 2/N;
    xpanels = zeros(N+1,1);
    for n = 0:N
        xpanels(n+1) = -1 + (n*dx);
    end

    %getting panel y values
    ypanelsTop = interp1(x(y>=0), y(y>=0), xpanels);
    ypanelsTop(1) = 0;
    ypanelsTop(N+1) = 0;

    ypanelsBottom = interp1(x(y<0), y(y<0), xpanels);
    ypanelsBottom(1) = 0;
    ypanelsBottom(N+1) = 0;

    ypanelsClean = [flipud(ypanelsBottom(2:end-1)) ; ypanelsTop];
    xpanelsClean = [flipud(xpanels(2:end-1)) ; xpanels];

    %getting panel midpoints
    xmid = zeros(length(xpanelsClean),1);
    ymid = zeros(length(ypanelsClean),1);
    thetaPanels = zeros(length(xpanelsClean),1);
    for i = 1:length(xpanelsClean)-1
        xmid(i) = 0.5*(xpanelsClean(i) + xpanelsClean(i+1));
        ymid(i) = 0.5*(ypanelsClean(i) + ypanelsClean(i+1));
        thetaPanels(i) = atan2((ypanelsClean(i+1) - ypanelsClean(i)), (xpanelsClean(i+1) - xpanelsClean(i)));
    end
    xmid(length(xpanelsClean)) = 0.5*(xpanelsClean(length(xpanelsClean)) + xpanelsClean(1));
    ymid(length(ypanelsClean)) = 0.5*(ypanelsClean(length(ypanelsClean)) + ypanelsClean(1));
    thetaPanels(length(xpanelsClean)) = atan2((ypanelsClean(1) - ypanelsClean(length(ypanelsClean))), (xpanelsClean(1) - xpanelsClean(length(xpanelsClean))));
    for i = 1:panelNumber
        if (thetaPanels(i) < 0)
            thetaPanels(i) = thetaPanels(i) + (2*pi);
        end
    end

    %panel properties
    r = zeros(panelNumber, panelNumber);
    phi = zeros(panelNumber, panelNumber);
    ds = zeros(panelNumber, 1);
    C = zeros(panelNumber, panelNumber);
    Cbar = zeros(panelNumber, panelNumber);

    for j = 1:(panelNumber-1)
        ds(j) = (((xpanelsClean(j+1)-xpanelsClean(j))^2)+((ypanelsClean(j+1)-ypanelsClean(j))^2))^(0.5);
    end
    ds(panelNumber) = (((xpanelsClean(1)-xpanelsClean(panelNumber))^2)+((ypanelsClean(1)-ypanelsClean(panelNumber))^2))^(0.5);

    for i = 1:panelNumber
        for j = 1:panelNumber
            r(i,j) =(((xmid(i) - xmid(j))^2)+((ymid(i) - ymid(j))^2))^(0.5);
            phi(i,j) = atan2((ymid(j)-ymid(i)), (xmid(j)-xmid(i)));
            if (phi(i,j) < 0)
                phi(i,j) = phi(i,j) + 2*pi;
            end
            C(i,j) = (1/(2*pi*r(i,j)))*(sin(thetaPanels(i)-phi(i,j)))*ds(j);
            Cbar(i,j) = (1/(2*pi*r(i,j)))*(cos(thetaPanels(i)-phi(i,j)))*ds(j);
        end
        C(i,i) = 0;
        Cbar(i,i) = 0;
    end

    Aij = zeros(panelNumber, panelNumber);
    Bi = zeros(panelNumber, 1);

    for i = 1:panelNumber
        for j = 1:panelNumber
            if (i == j)
                Aij(i,j) = 0.5;
            else
                Aij(i,j) = C(i,j);
            end
        end
        Bi(i) = -Vo*sin(thetaPanels(i) - alpha);
    end

    q = (Bi'/Aij)';

    Vti = zeros(panelNumber, 1);
    Cpi = zeros(panelNumber, 1);
    for i = 1:panelNumber
        Vti(i) = (Vo*cos(thetaPanels(i) - alpha)) + sum(q.*Cbar(i,:)');
        Cpi(i) = 1-((Vti(i)/Vo)^2);
    end

    if (strcmp(shouldPlot, '-y'))
        figure
        plot(x, y, xmid, Cpi, '-s')
        axis equal
        title('Cp Distribution from Source Panel Method Solution')
        ylabel('Cp')
        xlabel('chord position')
        grid on
    end
end