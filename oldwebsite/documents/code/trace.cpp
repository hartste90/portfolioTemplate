/*
Steve Hart
file: trace.cpp
date:Dec 2012
Description: Raytracer --description: Driver code for an original raytracer
which includes diffuse (color), shadows, reflection, 
and specular (glossiness) shading.
This raytracer outputs a .ppm image file of the scene.
 
*/
// ray tracer main program
// includes input file parsing and spawning screen pixel rays

// classes used directly by this file
#include "ObjectList.hpp"
#include "Polygon.hpp"
#include "Sphere.hpp"
#include "Ray.hpp"
#include "World.hpp"
#include "Vec3.hpp"
#include "Appearance.hpp"

// standard includes
#include <stdio.h>
#include <string.h>
#include <list>

#ifdef _WIN32
#pragma warning( disable: 4996 )
#endif
/*
refColors: returns the color added to a pixel by the reflections in the scene
*/
Vec3 refColors(Vec3 &color, const Vec3 &dir, const bRay &backRay, const World &world, int bounces)
{
  //limit # bounces
	if(bounces > 5) { return color;}
	float c1 = -1 * (backRay.n*dir);
	Vec3 checkNorm = color;
	Vec3 R1 = dir + (2 * backRay.n * c1);
	//shoot the ray
	Ray refRay(backRay.p, R1, world.hither);
	bRay backRay2;
	//calculate the next bounce
	backRay2 = world.objects.trace(refRay).appearance(world, refRay);
	
	//add those colors to the current color
	color[0] += backRay2.color[0]*backRay.Ks;
	color[1] += backRay2.color[1]*backRay.Ks;
	color[2] += backRay2.color[2]*backRay.Ks;
	return refColors(color, R1, backRay2, world, bounces + 1);
	
}

int main(int argc, char **argv)
{
    // support stdin or command line
    if (argc == 2)
        freopen(argv[1],"r",stdin);

    // everything we know about the world
    // image parameters, camera parameters
    World world;
    world.read(stdin);

    // array of image data in ppm-file order
    unsigned char (*pixels)[3] = new unsigned char[world.height*world.width][3];

    // vectors to step one pixel to the right and one pixel down
    // i= -1 to 1 maps to x= -.5 to width-.5
    // x = (i+.5)*2/width - 1;  y = (j+.5)*2/height - 1;
    Vec3 dx = world.right*(2.f/world.width), dy = world.up*(-2.f/world.height);

    // ray direction to first pixel of scan line
    Vec3 dir0 = world.view +
	(-1+1.f/world.width)*world.right + 
	(1-1.f/world.height)*world.up;

    // spawn a ray for each pixel and place the result in the pixel
    Vec3 dir;				// current ray direction
    int i,j;				// pixel index on screen
    unsigned char (*pixel)[3] = pixels;	// current pixel
    for(j=0; j<world.height; ++j, dir0 = dir0+dy) {
	if (j % 32 == 0) printf("line %d\n",j); // show current line
	for(i=0, dir=dir0; i<world.width; ++i, ++pixel, dir = dir+dx) {
	    Ray ray(world.eye, dir, world.hither);	
	    int bcs = 1;
			  //shoot the ray
	    bRay backRay = world.objects.trace(ray).appearance(world, ray);
	    //if reflections are turned on, add the color increase b/c of reflections
		if(backRay.Ks > 0)
		{
			Vec3 emptyCol;
			Vec3 refCol = refColors(emptyCol, dir, backRay, world, bcs+(bcs*2));
			backRay.color[0] = backRay.color[0] + refCol[0];
			backRay.color[1] = backRay.color[1] + refCol[1];
			backRay.color[2] = backRay.color[2] + refCol[2];

		}

	    (*pixel)[0] = backRay.color.r();
	    (*pixel)[1] = backRay.color.g();
	    (*pixel)[2] = backRay.color.b();
	}
    }
    printf("done\n");

    // write ppm file of pixels
    FILE *output = fopen("trace.ppm","wb");
    fprintf(output, "P6\n%d %d\n%d\n", world.width, world.height, 255);
    fwrite(pixels, world.height*world.width*3, 1, output);
    fclose(output);
  
    delete[] pixels;
    return 0;
}
  
