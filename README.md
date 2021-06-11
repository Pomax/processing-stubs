# Processing-stubs

Code that I constantly end up writing when using Processing.

- `double.pde`: almost all math and drawing functions uplifted to accept `double` values instead of `float`.
- `vec.pde`: `Vec2` and `Vec3` classes, based on doubles (depends on `double.pde`)
- `vecutil.pde`: some math and drawing functions uplifted to allow `Vec2`/`Vec3` arguments (depends on `vec.pde`), including `lli` for finding line/line intersections.
- `transform.pde`: universal "right-click-drag to pan" and "mouse scroll to zoom" behaviour (depends on `vec.pde`)
- `bezier.pde`: `Bezier2` and `Bezier3` classes (depends on `vec.pde`)
