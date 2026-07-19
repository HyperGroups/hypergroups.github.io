---
layout: default
title: 三维随机游走 · wls
---

## 三维随机游走（配套脚本）

对应图文博文：[Mathematica简单的三维随机游走及实现]({{ site.baseurl }}/Mathematica简单的三维随机游走及实现)

### 运行

```text
wolframscript -file random-walk-3d.wls
```

脚本会写入 `out/`，并在主站仓库内同步复制到 [`/assets/posts/random-walk-3d/`]({{ site.baseurl }}/assets/posts/random-walk-3d/01-cuboid-foldlist.png)（供博文插图）。

- 脚本：[random-walk-3d.wls]({{ site.baseurl }}/wolfram/random-walk-3d/random-walk-3d.wls)
- 说明：[README.md]({{ site.baseurl }}/wolfram/random-walk-3d/README.md)

### 部分输出

<p>
<img src="{{ site.baseurl }}/assets/posts/random-walk-3d/01-cuboid-foldlist.png" alt="cuboid foldlist" style="max-width:48%;height:auto;">
<img src="{{ site.baseurl }}/assets/posts/random-walk-3d/02-tube-dirs8.png" alt="tube dirs8" style="max-width:48%;height:auto;">
</p>
<p>
<img src="{{ site.baseurl }}/assets/posts/random-walk-3d/03-spherical-steps.png" alt="spherical" style="max-width:48%;height:auto;">
<img src="{{ site.baseurl }}/assets/posts/random-walk-3d/06-msd.png" alt="msd" style="max-width:48%;height:auto;">
</p>
<p>
<img src="{{ site.baseurl }}/assets/posts/random-walk-3d/05-walk-frames.gif" alt="walk gif" style="max-width:60%;height:auto;">
</p>
