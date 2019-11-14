# Goliath-Engine_standalone
My first experimental engine (C++, OpenGL, Qt) for rendering, modelisation and animation

Gui (clone Blender)

Release date :  February 2020

Code is in a private repo (Precompiled library)

Source is coming soon

---

## Dependencies
* Assimp (no submodule, system library, compiled with latest version on Arch Linux)
* glm (no submodule, system library, compiled with latest version on Arch Linux)

---

##  Building on Linux (command line instruction)
```bash
$ mkdir build
$ cd build
$ cmake ..
$ make
```
---

## Rendering
### Shadow and light
<!-- [![](https://img.youtube.com/vi/gDdghUDYpok/0.jpg)](https://youtu.be/gDdghUDYpok "view on youtube") -->
[![](shadow.png)](https://youtu.be/gDdghUDYpok "view on youtube")
<!-- https://youtu.be/gDdghUDYpok -->

### Frustum culling
[![](https://img.youtube.com/vi/xsooSpulDy8/0.jpg)](https://youtu.be/xsooSpulDy8 "view on youtube")
<!-- https://youtu.be/xsooSpulDy8 -->

---

## Modelisation
### BSpline
<!-- [![bspline](bSpline.png)](https://youtu.be/0qHZ_LvAo_0 "wiew on youtube") -->
[![bspline](bSpline.png)](https://youtu.be/Ms513wlBTy4 "wiew on youtube")

additional video : https://youtu.be/0qHZ_LvAo_0

### Nurbs (BSpline with weights)
example of perfect circle :

![nurbs](nurbs.png)

### PN Triangles Tessellation
[![](https://img.youtube.com/vi/Ck42FhEDYWU/0.jpg)](https://youtu.be/Ck42FhEDYWU "view on youtube")


---

## Bonus
### Multiple view camera (Sponza)
![sponza](sponza.png)
