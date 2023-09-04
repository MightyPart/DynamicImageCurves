# Getting Started

```lua
local DynamicImageCurves = require(--[[ Path To Module Here ]])

local sizeX, sizeY = 200, 200
local image = DynamicImageCurves(sizeX, sizeY)

local imageLabel: ImageLabel = image:InstantiateAsLabel()
```


- - -

# Bezier Curves For DynamicImage's

## :QuadraticBezier(p0: {number, number}, p1: {number, number}, p2: {number, number}, spacingInterval: number, indicatorSize: number)
`p0` = The 0th point of the curve.

`p1` = The 1st point of the curve.

`p2` = The 2nd point of the curve.

`spacingInterval` = The spacing between pixels.

`indicatorSize` = The size of the indicators for all of the points.



## :CubicBezier(p0: {number, number}, p1: {number, number}, p2: {number, number}, p3: {number, number}, spacingInterval: number, indicatorSize: number)
`p0` = The 0th point of the curve.

`p1` = The 1st point of the curve.

`p2` = The 2nd point of the curve.

`p3` = The 3rd point of the curve.

`spacingInterval` = The spacing between pixels.

`indicatorSize` = The size of the indicators for all of the points.



## :Line(p0: {number, number}, p1: {number, number}, spacingInterval: number, indicatorSize: number)
`p0` = The 0th point of the curve.

`p1` = The 1st point of the curve.

`spacingInterval` = The spacing between pixels.

`indicatorSize` = The size of the indicators for all of the points.
