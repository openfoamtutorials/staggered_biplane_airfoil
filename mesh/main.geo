Include "ArcAirfoil.geo";
Include "WindTunnel.geo";
Include "parameters.geo";

// Units are multiples of chord.

ce = 0;


Arguments[] = {0, bendHeight, thickness, AirfoilLc, biplaneStagger, biplaneGap, 2};
Call ArcAirfoil;
AirfoilLoop2 = Results[0];

Arguments[] = {0, bendHeight, thickness, AirfoilLc, 0, 0, 2};
Call ArcAirfoil;
AirfoilLoop = Results[0];

WindTunnelHeight = 20;
WindTunnelLength = 40;
WindTunnelLc = 1;
Call WindTunnel;

Surface(ce++) = {WindTunnelLoop, AirfoilLoop, AirfoilLoop2};
TwoDimSurf = ce - 1;

cellDepth = 0.1;

ids[] = Extrude {0, 0, cellDepth}
{
	Surface{TwoDimSurf};
	Layers{1};
	Recombine;
};

Physical Surface("outlet") = {ids[2]};
Physical Surface("walls") = {ids[{3, 5}]};
Physical Surface("inlet") = {ids[4]};
Physical Surface("airfoil") = {ids[{6:17}]};
Physical Surface("frontAndBack") = {ids[0], TwoDimSurf};
Physical Volume("volume") = {ids[1]};
