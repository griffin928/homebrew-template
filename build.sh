#!/bin/bash

version="v1.0.0"
tar_name="template-${version}.tar.gz"

# 打包源码
git archive --format=tar.gz --prefix=template-${version}/ HEAD > $tar_name

# 输出 sha256（复制到 formula 用）
shasum -a 256 $tar_name
