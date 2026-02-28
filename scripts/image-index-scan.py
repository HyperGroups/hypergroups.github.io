# -*- coding: utf-8 -*-
"""
图床索引脚本：扫描本地图片、提取引用、生成本地相对路径映射与绝对路径索引
"""
import os
import re
from pathlib import Path
from collections import defaultdict

ROOT = Path(__file__).resolve().parent.parent
EXCLUDE = {'_site', 'dev', '.git', 'node_modules'}

def collect_local_images():
    """收集项目中所有本地图片（排除 _site, dev）"""
    images = []
    for ext in ('*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp'):
        for p in ROOT.rglob(ext):
            rel = p.relative_to(ROOT)
            if any(part in EXCLUDE for part in rel.parts):
                continue
            images.append({
                'abs': str(p.resolve()),
                'rel': str(rel).replace('\\', '/'),
            })
    return images

def extract_image_refs_from_file(fp):
    """从文件中提取图片引用（7xl9ih URL 和 HTMLFiles 相对路径）"""
    qiniu_refs = []
    local_refs = []
    try:
        content = fp.read_text(encoding='utf-8', errors='ignore')
    except Exception:
        return qiniu_refs, local_refs

    # 7xl9ih URL
    qiniu_pat = re.compile(
        r'http://7xl9ih\.com1\.z0\.glb\.clouddn\.com/(HTMLFiles/[^\s"\'<>]+\.(?:png|jpg|jpeg|gif|webp))',
        re.I
    )
    for m in qiniu_pat.finditer(content):
        qiniu_refs.append(m.group(1).replace('\\', '/'))

    # HTMLFiles 相对路径（支持 / 和 \）
    local_pat = re.compile(
        r'(?:src|href)=["\']?(HTMLFiles[\\/][^\s"\'<>]+\.(?:png|jpg|jpeg|gif|webp))["\']?',
        re.I
    )
    for m in local_pat.finditer(content):
        p = m.group(1).replace('\\', '/')
        local_refs.append(p)
    return qiniu_refs, local_refs

def extract_all_refs():
    """从 _posts 和 _post_markdown 中提取所有图片引用"""
    qiniu_to_sources = defaultdict(set)  # url -> set of source files
    local_to_sources = defaultdict(set)

    for folder in ('_posts', '_post_markdown', 'Pages'):
        d = ROOT / folder
        if not d.exists():
            continue
        for fp in d.rglob('*'):
            if not fp.is_file():
                continue
            if fp.suffix.lower() not in ('.html', '.md'):
                continue
            rel_path = str(fp.relative_to(ROOT)).replace('\\', '/')
            q, l = extract_image_refs_from_file(fp)
            for u in q:
                qiniu_to_sources[u].add(rel_path)
            for u in l:
                local_to_sources[u].add(rel_path)

    return qiniu_to_sources, local_to_sources

def normalize_local_path(p):
    """统一为 HTMLFiles/xxx/HTMLFiles/xxx_n.ext 格式"""
    p = p.replace('\\', '/')
    # HTMLFiles\xxx\xxx_1.png -> HTMLFiles/xxx/HTMLFiles/xxx_1.png (部分文章少一层 HTMLFiles)
    if '/HTMLFiles/' not in p or p.count('HTMLFiles') == 1:
        parts = p.split('/')
        if len(parts) >= 2 and parts[0] == 'HTMLFiles':
            folder = parts[1]
            fname = parts[-1]
            if folder in fname or fname.startswith(folder):
                p = f"HTMLFiles/{folder}/HTMLFiles/{fname}"
    return p

def main():
    os.chdir(ROOT)
    out_dir = ROOT / 'image-index-output'
    out_dir.mkdir(exist_ok=True)

    # 1. 收集本地图片（排除 _site, dev）
    local_images = collect_local_images()
    local_rel_set = {img['rel'] for img in local_images}
    local_by_rel = {img['rel']: img for img in local_images}

    # 2. 提取引用
    qiniu_to_sources, local_to_sources = extract_all_refs()

    # 3. 七牛 URL -> 本地相对路径（七牛 path 与本地一致）
    qiniu_base = 'http://7xl9ih.com1.z0.glb.clouddn.com/'
    mapping = []
    qiniu_exists = 0
    qiniu_missing = 0

    for qiniu_path in sorted(set(k for k in qiniu_to_sources)):
        local_rel = qiniu_path  # 路径结构一致
        exists = local_rel in local_rel_set
        if exists:
            qiniu_exists += 1
        else:
            qiniu_missing += 1
        sources = ', '.join(sorted(qiniu_to_sources[qiniu_path])[:5])
        if len(qiniu_to_sources[qiniu_path]) > 5:
            sources += ', ...'
        mapping.append({
            'qiniu': qiniu_base + qiniu_path,
            'local_rel': '/' + local_rel,
            'exists': exists,
            'sources': sources,
        })

    # 4. 生成本地缺失的七牛引用清单
    missing_file = out_dir / 'qiniu-missing-local.txt'
    with open(missing_file, 'w', encoding='utf-8') as f:
        f.write("# 七牛 URL 引用，但本地无对应文件\n")
        f.write("# 需从七牛下载或从其他备份恢复\n\n")
        for m in mapping:
            if not m['exists']:
                f.write(f"# {m['sources']}\n")
                f.write(m['qiniu'] + '\n\n')

    # 5. 生成本地相对路径版本（七牛→本地映射，仅包含存在项）
    mapping_file = out_dir / 'qiniu-to-local-relative-mapping.txt'
    with open(mapping_file, 'w', encoding='utf-8') as f:
        f.write("# 七牛云 URL → 本地相对路径（站根相对）\n")
        f.write("# 仅包含本地存在的图片。替换时用 local_rel 替代 qiniu URL。\n")
        f.write("# 生成时间: 由 image-index-scan.py 生成\n\n")
        for m in mapping:
            if m['exists']:
                f.write(f"# {m['sources']}\n")
                f.write(f"{m['qiniu']}\n")
                f.write(f"  -> {m['local_rel']}\n\n")

    # 6. 生成绝对路径索引
    index_file = out_dir / 'image-index-absolute.txt'
    with open(index_file, 'w', encoding='utf-8') as f:
        f.write("# 本地图片绝对路径索引\n")
        f.write("# 排除 _site、dev。按相对路径排序。\n\n")
        for img in sorted(local_images, key=lambda x: x['rel']):
            f.write(img['abs'] + '\n')

    # 7. 汇总报告
    report_file = out_dir / 'image-scan-report.txt'
    with open(report_file, 'w', encoding='utf-8') as f:
        f.write("=== 图床扫描报告 ===\n\n")
        f.write(f"本地图片总数（不含 _site, dev）: {len(local_images)}\n")
        f.write(f"七牛 URL 引用（去重）: {len(mapping)}\n")
        f.write(f"  - 本地存在: {qiniu_exists}\n")
        f.write(f"  - 本地缺失: {qiniu_missing}\n")
        f.write(f"\n本地 HTMLFiles 引用（去重）: {len(local_to_sources)}\n")
        missing_local = []
        for lp in sorted(local_to_sources):
            norm = normalize_local_path(lp)
            if norm not in local_rel_set:
                cand = lp
                for r in local_rel_set:
                    if lp.replace('\\', '/').split('/')[-1] in r:
                        cand = r
                        break
                missing_local.append((lp, cand in local_rel_set))
        f.write(f"  - 引用但本地可能缺失: {len([x for x in missing_local if not x[1]])}\n")
        f.write(f"\n输出文件:\n")
        f.write(f"  - {mapping_file.name}\n")
        f.write(f"  - {index_file.name}\n")
        f.write(f"  - {missing_file.name}\n")

    print(f"Done. Output in {out_dir}")
    print(f"  - {mapping_file.name}")
    print(f"  - {index_file.name}")
    print(f"  - {missing_file.name}")
    print(f"  - {report_file.name}")

if __name__ == '__main__':
    main()
