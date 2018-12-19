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

- 每隔1/48000s进行一次采样，放入输入缓冲队列
- 每次从输入缓冲队列取512个点的信号数据进行处理，从上一次取的第256个信号开始，第一次取信号从0开始
- 对这512个点的数据构成的波形乘以汉明窗(使用MATLAB计算汉明窗`hanning(512)`的值)
- 对加窗以后的函数进行FFT变换(使用quartus内置IP核)得到512个频域信息
- 对512个频域信息进行任意变换
- 对变换后的频域数据做IFFT
- 将IFFT后的信号前后拼接
- 拼接后送给播放模块

## 录音和放音模块

## 输入缓冲队列

### 输入 

- 16位音频信号 from 录音模块
- 时钟信号
- 输出允许信号，与FFT模块的输入准备信号相关联

### 输出

- 16位音频信号 to 信号处理模块

- 维护两个大小为256的FIFO队列inq1和inq2
  - inq1:之前的后256位信号
  - inq2:最新的256位信号

每一个时钟周期：

— 录音模块输入一个16位的音频信号，压入inq2队尾
- inq1弹出队首元素，送到信号处理模块进行加窗和FFT
- inq2弹出队首元素，下一时钟周期压入inq1队尾

**特判**：刚开始处理时，q1为空，默认输出0到处理模块，只有数毫秒的误差所以理论上不会影响变声效果

## 加窗模块

- 调用MATLAB存储乘以65536后的512个数的hanning窗的值到"hanning.mif"文件中
- 下标计数，对每个输入的16位定点表示音频信息乘上相应hanning窗的值
- 将得到的值除以65536(左移16位)后再输出到FFT模块

## FFT/IFFT模块

### 输入

- 时钟信号
- 输入数据有效信号：恒为1
- 输入的16位音频信号

### 输出

- 处理过后的音频信号 to 输出队列模块

- 维护一个FFT模块和一个IFFT模块
- 两个模块间调用频谱处理模块处理FFT所得的频谱数据
- 对输入数据进行计数加窗
- hanning窗的函数值用matlab计算后存入ROM中


## 频谱处理模块

### 输入

- FFT变换后的实部数据
- FFT变换后的虚部数据

### 输出

- 频谱操作后的实部数据
- 频谱操作后的虚部数据

- 希望能设计出多种变声模式设计故单独成为一个模块
- 目前先实现搬移操作

## 输出缓冲队列

### 输入

- 时钟信号
- 处理后的加窗过的音频数据

### 输出

- 16位音频数据

原理与输入缓冲队列类似

- 维护两个优先队列outq1和outq2
  - outq1:之前的后256位输出信号
  - outq2:这次接收到的256位输出信号

每一个时钟周期：

- 压入一个加窗过的音频数据到outq2队尾
- outq1弹出队首数据
- outq2弹出队首元素，下一时钟周期压入outq1队尾
- 将outq1和outq2弹出的队首元素相加，送到音频输出模块


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