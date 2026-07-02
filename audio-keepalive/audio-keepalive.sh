#!/bin/bash
# Audio Keepalive — 持续向默认 sink 灌入静音数据，保持音频链路永不断开
# 解决空闲后首次播放丢失开头声音的问题
# 对应 issue: conglinyizhi/conglinyizhi#6
#
# 资源占用：CPU < 0.1%，内存 ~2.6 MB
# 依赖：pulseaudio（pacat）
#
# 安装：
#   chmod +x audio-keepalive.sh
#   cp audio-keepalive.sh ~/.local/bin/
#   cp audio-keepalive.service ~/.config/systemd/user/
#   systemctl --user daemon-reload
#   systemctl --user enable --now audio-keepalive

exec pacat --rate=44100 --channels=2 --format=s16le --latency=200000 < /dev/zero
