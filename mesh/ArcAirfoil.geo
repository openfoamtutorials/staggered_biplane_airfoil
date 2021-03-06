Include "Vector.geo";

Macro RotatePoint
    pointId = Arguments[0];
    angle = Arguments[1];
    center[] = Arguments[{2:4}];
    Rotate {{0, 0, 1}, {center[0], center[1], center[2]}, angle}
    {
        Point{pointId};
    }
Return

Macro RotatePoints
    angle = Arguments[0];
    center[] = Arguments[{1:3}];
    pointIds[] = Arguments[{4 : #Arguments[] - 1}];
    Rotate {{0, 0, 1}, {center[0], center[1], center[2]}, angle}
    {
        Point{pointIds[]};
    }
Return

Macro RotateAirfoilPoint
    // rotates pointId about origin.
    Arguments[1] *= -1.0;
    Arguments[{2:4}] = {0, 0, 0}; // rotation center.
    Call RotatePoint;
Return

Macro RotateAirfoilPoints
    // rotates pointId about origin.
    Arguments[0] *= -1.0;
    Arguments[{1:3}] = {0, 0, 0}; // rotation center.
    Arguments[{4 : #Arguments[] - 1}] = Arguments[{4 : #Arguments[] - 1}];
    Call RotatePoints;
Return

Macro TranslatePoint
    pointId = Arguments[0];
    dx = Arguments[1];
    dy = Arguments[2];
    Translate {dx, dy, 0}
    {
        Point{pointId};
    }
Return

Macro ArcAirfoil
    aoa = Arguments[0] * Pi / 180;
    bendHeight = Arguments[1];
    thickness = Arguments[2];
    lc = Arguments[3];
    dx = Arguments[4];
    dy = Arguments[5];
    bottomSurfaceLcFactor = Arguments[6];

    allPoints[] = {};

    Point(ce++) = {0, 0, 0, lc};
    leCenter = ce - 1;
    Point(ce++) = {1, 0, 0, lc};
    teCenter = ce - 1;
    allPoints[] += {leCenter, teCenter};

    airfoilRadius = 0.5 * bendHeight + 0.125 / bendHeight;
    topSurfaceRadius = airfoilRadius + thickness / 2;
    bottomSurfaceRadius = airfoilRadius - thickness / 2;
    airfoilSpan = 2 * Asin(0.5 / airfoilRadius);

    drop = airfoilRadius - bendHeight;
    Point(ce++) = {0.5, -drop, 0};
    arcCenter = ce - 1;
    allPoints[] += {arcCenter};

    lePoints[] = {};
    h = 0.5 * thickness;
    Point(ce++) = {-h, 0, 0, lc};
    lePoints[] += ce - 1;
    Point(ce++) = {0, h, 0, lc};
    lePoints[] += ce - 1;
    Point(ce++) = {0, -h, 0, bottomSurfaceLcFactor * lc};
    lePoints[] += ce - 1;
    Arguments[] = {airfoilSpan / 2, Point{leCenter}, lePoints[]}; Call RotatePoints;
    allPoints[] += lePoints[];

    tePoints[] = {};
    Point(ce++) = {1 + 0.5 * thickness, 0, 0, lc};
    tePoints[] += ce - 1;
    Point(ce++) = {1, 0.5 * thickness, 0, lc};
    tePoints[] += ce - 1;
    Point(ce++) = {1, -0.5 * thickness, 0, bottomSurfaceLcFactor * lc};
    tePoints[] += ce - 1;
    Arguments[] = {-airfoilSpan / 2, Point{teCenter}, tePoints[]}; Call RotatePoints;
    allPoints[] += tePoints[];

    For p In {0:#allPoints[] - 1}
        Arguments[] = {allPoints[p], aoa};
        Call RotateAirfoilPoint;
    EndFor

    For p In {0:#allPoints[] - 1}
        Arguments[] = {allPoints[p], dx, dy};
        Call TranslatePoint;
    EndFor

    Arguments[] = {globalAoa * Pi / 180, 0, 0, 0, allPoints[]};
    Call RotateAirfoilPoints;

    loopLines[] = {};
    Circle(ce++) = {tePoints[0], teCenter, tePoints[1]};
    loopLines[] += ce - 1;
    Circle(ce++) = {tePoints[1], arcCenter, lePoints[1]};
    loopLines[] += ce - 1;
    Circle(ce++) = {lePoints[1], leCenter, lePoints[0]};
    loopLines[] += ce - 1;
    Circle(ce++) = {lePoints[0], leCenter, lePoints[2]};
    loopLines[] += ce - 1;
    Circle(ce++) = {lePoints[2], arcCenter, tePoints[2]};
    loopLines[] += ce - 1;
    Circle(ce++) = {tePoints[2], teCenter, tePoints[0]};
    loopLines[] += ce - 1;

    Line Loop(ce++) = loopLines[];
    Results[0] = ce - 1;
Return
