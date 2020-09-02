#!/usr/bin/env bash
# Copyright 2015 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

# Select bazel version.
#BAZEL_VERSION="3.1.0"
BAZEL_VERSION="0.12.0"

set +e
local_bazel_ver=$(bazel version 2>&1 | grep -i label | awk '{print $3}')

if [[ "$local_bazel_ver" == "$BAZEL_VERSION" ]]; then
  exit 0
fi

set -e

# Install bazel.
mkdir -p /bazel
cd /bazel
#if [[ ! -f "bazel-$BAZEL_VERSION-installer-linux-x86_64.sh" ]]; then
#  curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh
curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-dist.zip
unzip bazel-$BAZEL_VERSION-dist.zip
cp /workspace/tensorflow/tools/ci_build/install/tocopy_compile.sh /bazel/bazel/scripts/bootstrap/compile.sh
cp /workspace/tensorflow/tools/ci_build/install/tocopy_cc_configure.bzl /bazel/bazel/tools/cpp/cc_configure.bzl

cd bazel
# TODO might need to copy the modified files mentioned in be README.md
env EXTRA_BAZEL_ARGS="--host_cpu=arm --cpu=arm --host_javabase=@local_jdk//:jdk" bash ./compile.sh


### TODO see if this works at a later point:
# Enable bazel auto completion.
#echo "source /usr/local/lib/bazel/bin/bazel-complete.bash" >> ~/.bashrc
