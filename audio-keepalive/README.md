# Audio Keepalive

持续向默认音频输出灌入静音数据，保持音频链路永不断开。

解决 Linux 上空闲一段时间后首次播放声音丢失开头几秒的问题。

## 背景

Linux 音频栈有五层独立的挂起/省电机制，层层叠加：

1. PulseAudio `module-suspend-on-idle`
2. PipeWire `suspend-node`
3. ALSA 驱动 `snd_hda_intel power_save`
4. PCI 总线 runtime PM
5. 应用层音频流释放后链路重建延迟

前四层可以通过系统配置禁用（详见 [issue #6](https://github.com/conglinyizhi/conglinyizhi/issues/6)），但第五层是应用与系统之间的契约缺陷——浏览器等异步播放的应用在调用 `play()` 后立即灌数据，不等底层链路接通，导致重建窗口内的数据被静默丢弃。

本方案用 `pacat` 持续灌入 `/dev/zero`（静音），让链路始终保持接通，浏览器一开口管道已经是热的。

## 安装

```bash
chmod +x audio-keepalive.sh
cp audio-keepalive.sh ~/.local/bin/
cp audio-keepalive.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now audio-keepalive
```

## 资源占用

- CPU：< 0.1%
- 内存：~2.6 MB

不会损坏物理设备——静音数据是全零 PCM，等同于设备静音状态。

## 原理

与 Windows 启动时音箱发出 "beng" 声是同一物理原理——都是音频设备状态切换的过渡现象。保活方案让链路永不断开，DAC 始终保持工作偏置，消除一切状态切换过渡。
