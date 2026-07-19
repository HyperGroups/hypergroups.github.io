(* ::Package:: *)
(*
  Mathematica简单的三维随机游走及实现 — runnable companion
  Source blog: hypergroups.github.io / MathematicaLegacy
  Run:
    wolframscript -file random-walk-3d.wls
*)

SeedRandom[20130101];

scriptDir = DirectoryName[$InputFileName];
outDir = FileNameJoin[{scriptDir, "out"}];
(* blog-facing copy: hypergroups.github.io/assets/posts/random-walk-3d *)
assetsDir = FileNameJoin[{
  ParentDirectory[ParentDirectory[scriptDir]],
  "assets", "posts", "random-walk-3d"
}];
If[!DirectoryQ[outDir], CreateDirectory[outDir]];
If[DirectoryQ[ParentDirectory[assetsDir]] && !DirectoryQ[assetsDir],
  CreateDirectory[assetsDir]
];

save[name_String, g_] := Module[{path = FileNameJoin[{outDir, name}], ap},
  Export[path, g, ImageResolution -> 120];
  If[DirectoryQ[assetsDir],
    ap = FileNameJoin[{assetsDir, name}];
    CopyFile[path, ap, OverwriteTarget -> True];
    Print["OK  ", path, "  -> assets"];
    ,
    Print["OK  ", path];
  ];
  path
];

Print["=== 3D random walk examples ==="];
Print["outDir = ", outDir];

(* ---------- shared dirs ---------- *)
dirs6 = Join[IdentityMatrix[3], -IdentityMatrix[3]];
dirs8 = Tuples[{-1, 1}, 3];

(* ---------- 方法一：立方体叠加 ---------- *)
n = 60;
cuboids = FoldList[
  GeometricTransformation[#1, TranslationTransform[#2]] &,
  Cuboid[],
  RandomChoice[dirs6, n]
];
save["01-cuboid-foldlist.png",
  Graphics3D[
    {Opacity[0.85], EdgeForm[GrayLevel[0.3]], cuboids},
    Boxed -> True, BoxRatios -> Automatic
  ]
];

positions = FoldList[Plus, {0, 0, 0}, RandomChoice[dirs6, n]];
save["01b-cuboid-from-positions.png",
  Graphics3D[
    GeometricTransformation[Cuboid[], TranslationTransform /@ positions]
  ]
];

(* 着色 *)
positionsC = FoldList[Plus, {0, 0, 0}, RandomChoice[dirs6, 80]];
cols = Blend[{Blue, Cyan, Yellow, Orange}, #] & /@ Rescale[Range[0, Length[positionsC] - 1]];
save["01c-cuboid-colored.png",
  Graphics3D[
    MapThread[
      {#1, EdgeForm[GrayLevel[0.35]],
        GeometricTransformation[Cuboid[], TranslationTransform[#2]]} &,
      {cols, positionsC}
    ],
    Boxed -> False, Lighting -> "Neutral"
  ]
];

(* ---------- 方法二：格点 + Tube ---------- *)
data8 = Accumulate[RandomChoice[dirs8, 200]];
save["02-tube-dirs8.png",
  Graphics3D[
    {Orange, Tube[data8, 0.35]},
    Boxed -> False, ViewPoint -> {1.3, -2.4, 2}
  ]
];

dataFrom0 = Accumulate[Prepend[RandomChoice[dirs8, 200], {0, 0, 0}]];
save["02b-tube-from-origin.png", Graphics3D[Tube[dataFrom0, 0.3]]];

data6 = Accumulate[Prepend[RandomChoice[dirs6, 300], {0, 0, 0}]];
save["02c-tube-dirs6.png",
  Graphics3D[{CapForm["Butt"], Tube[data6, 0.25]}]
];

pathEnds = Accumulate[Prepend[RandomChoice[dirs6, 400], {0, 0, 0}]];
save["02d-tube-endpoints.png",
  Graphics3D[{
    {GrayLevel[0.55], Tube[pathEnds, 0.2]},
    {Green, Sphere[First[pathEnds], 0.55]},
    {Red, Sphere[Last[pathEnds], 0.55]}
  }, Boxed -> False]
];

(* ---------- 方法三：球面连续步 ---------- *)
step[] := Normalize @ RandomReal[NormalDistribution[0, 1], 3];
pathCont = Accumulate[Table[step[], 500]];
save["03-spherical-steps.png",
  Graphics3D[
    {ColorData["Rainbow"][0.15], Tube[pathCont, 0.08]},
    Boxed -> False, ViewPoint -> {2, -2, 1.2}
  ]
];

(* ---------- 方法四：有偏 + 盒子 ---------- *)
weights = {1, 1, 1.4, 1, 1, 0.7};
box = Cuboid[{-8, -8, -8}, {8, 8, 8}];
insideQ[p_] := And @@ Thread[-8 <= p <= 8];
biasedStep[p_] := Module[{cand},
  cand = p + RandomChoice[weights -> dirs6];
  If[insideQ[cand], cand, p]
];
pathBiased = NestList[biasedStep, {0, 0, 0}, 600];
save["04-biased-boxed.png",
  Graphics3D[{
    {Opacity[0.08], EdgeForm[None], box},
    {Orange, Tube[pathBiased, 0.22]},
    {Red, Sphere[Last[pathBiased], 0.4]}
  }, Boxed -> False]
];

(* ---------- 动画：导出若干帧（无前端 Animate） ---------- *)
pathAnim = Accumulate[Prepend[RandomChoice[dirs6, 120], {0, 0, 0}]];
pr = MinMax /@ Transpose[pathAnim];
frames = Table[
  Graphics3D[
    {CapForm["Round"], Tube[Take[pathAnim, k], 0.28],
      Red, Sphere[pathAnim[[k]], 0.45]},
    PlotRange -> pr, Boxed -> False, SphericalRegion -> True
  ],
  {k, 2, Length[pathAnim], 8}
];
save["05-walk-frames.gif", frames];

(* ---------- 统计：均方位移 ---------- *)
nStat = 200; trials = 400;
msd = Mean @ Table[
  With[{path = Accumulate[RandomChoice[dirs6, nStat]]},
    Total /@ (path^2)
  ],
  {trials}
];
save["06-msd.png",
  ListLinePlot[msd,
    AxesLabel -> {"n", "<r^2>"},
    PlotLabel -> "3D lattice walk MSD",
    PlotTheme -> "Detailed"
  ]
];

ends = Table[Norm @ Total @ RandomChoice[dirs6, 200], {2000}];
save["06b-end-distance-hist.png",
  Histogram[ends, 40, "PDF", AxesLabel -> {"|S_n|", "density"}]
];

(* ---------- 小封装 ---------- *)
RandomWalk3D[n_, opts : OptionsPattern[Graphics3D]] := Module[
  {dirs = dirs6, path},
  path = Accumulate[Prepend[RandomChoice[dirs, n], {0., 0., 0.}]];
  Graphics3D[
    {ColorData["SolarColors"][0.55], CapForm["Round"], Tube[path, 0.25]},
    Boxed -> False, SphericalRegion -> True, opts
  ]
];
save["07-randomwalk3d.png",
  RandomWalk3D[300, ViewPoint -> {1.4, -2.2, 1.5}]
];

(* ---------- Fold / FoldList smoke check ---------- *)
foldDemo = FoldList[Plus, 0, {1, 2, 3}];
If[foldDemo === {0, 1, 3, 6},
  Print["OK  FoldList[Plus, 0, {1,2,3}] == ", foldDemo],
  Print["FAIL FoldList demo: ", foldDemo]
];

Print["=== done ==="];
Print["files: ", Length @ FileNames["*", outDir]];
