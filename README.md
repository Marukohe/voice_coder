# 实时变声系统

## 实现目标

利用FPGA超强的并行计算能力实现一个实时变声系统

## 硬件准备

两个接口的耳麦

## 变声原理

### 语言信号的基本特征

- 电压以补码整数形式来表示
- 快速傅里叶变换：33将语音从时间域上变换到频率域
- FFT算法给出复数值：饱含了幅度和相位的信息
- 点的顺序给出了信号频率由低到高的频谱信息

## 频谱调整

- 对语音时间数据进行分段
- 对每一段加窗平滑
- 对加窗后的数据进行FFT，得到频域数据
- 进行频域调整
- 对调整后的频域数据进行逆变换IFFT，得到时域数据
- 对时域数据进行拼接，输出调整后的语音

## 录音和放音模块

## 输入输出缓冲队列

## FFT/IFFT模块

## 频谱处理模块

## 设备相关

1. DA：音频数字模拟转换
2. AD：模拟数字转换
3. FPGA输出的数字样本被转换成模拟信号(DA转换)，通过绿色接口输出
4. Mic In接口接入麦克风，将其转换为数字信号(AD转换)然后发送给FPGA
5. DAC：输出音频方向
6. ADC：输入音频方向
7. (TODO)

## 实现

1. I2S_Audioin：音频输入模块
2. I2S_Audio：音频输出模块
3. I2C_Audio_Config：WM8731芯片配置

## 初始化

1. 读使能初始化为0，写计数256开始读，写计数初始化为-256，读计数为512，读使能失效，读地址减。
2. 输出队列，读指针1在写指针前256的位置，初始化为-256，50MHz，读指针2初始化为0，48kHz读出。