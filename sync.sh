#!/usr/bin/env bash
# 技能库同步：git pull + 幂等建链 + 清理悬空断链
# 用法: bash ~/.agents/skills/sync.sh
# 说明: 实体库在 ~/.agents/skills，claude 侧 ~/.claude/skills 下是指向它的 NTFS junction
set -uo pipefail
cd "$(dirname "$0")" || exit 1

echo "== [1/2] git pull (--ff-only) =="
if ! git pull --ff-only; then
  echo "WARN: pull 失败(离线，或本地与远程有分叉提交)。分叉请手动 rebase 处理后重跑；本次仅按本地状态同步链接。"
fi

echo "== [2/2] 同步 junction =="
node -e '
const fs=require("fs"),path=require("path");
const home=process.env.USERPROFILE||process.env.HOME;
const SRC=path.join(home,".agents","skills");
const DST=path.join(home,".claude","skills");
fs.mkdirSync(DST,{recursive:true});
let created=0,kept=0,removed=0;
// 1) 实体库里的每个技能目录 → 确保 claude 侧有 junction（幂等）
for(const name of fs.readdirSync(SRC)){
  if(name.startsWith("."))continue;
  const srcPath=path.join(SRC,name);
  if(!fs.statSync(srcPath).isDirectory())continue;      // 根目录散文件(sync.sh 等)不是技能，跳过
  const linkPath=path.join(DST,name);
  if(fs.existsSync(linkPath)){kept++;continue;}         // 已存在就跳过，绝不覆盖
  fs.symlinkSync(srcPath,linkPath,"junction");
  created++;console.log("  + junction:",name);
}
// 2) claude 侧每个链接 → 目标已消失的悬空断链清掉（只删链接本身，不穿透）
for(const name of fs.readdirSync(DST)){
  const linkPath=path.join(DST,name);
  let st;try{st=fs.lstatSync(linkPath);}catch{continue;}
  if(!st.isSymbolicLink())continue;                     // 用户自放的真实目录/文件，不动
  let target;try{target=fs.readlinkSync(linkPath);}catch{continue;}
  const resolved=path.resolve(path.dirname(linkPath),target);
  if(resolved!==SRC && !resolved.startsWith(SRC+path.sep))continue;  // 非本库的链接，不动
  if(!fs.existsSync(resolved)){
    fs.rmdirSync(linkPath);
    removed++;console.log("  - dangling link removed:",name);
  }
}
console.log("done: 新建"+created+" 保留"+kept+" 清理"+removed);
'
