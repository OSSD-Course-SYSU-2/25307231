import router from '@ohos.router';

// Index.ets
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State hours: string = '0';
  @State minutes: string = '0';
  @State seconds: string = '0';
  @State isRunning: boolean = false;
  @State timeLeft: number = 0;
  private timerId: number = -1;

  aboutToDisappear() {
    if (this.timerId !== -1) {
      clearTimeout(this.timerId);
    }
  }

  startTimer() {
    if (this.isRunning) return;

    const totalSeconds =
      (parseInt(this.hours) || 0) * 3600 +
        (parseInt(this.minutes) || 0) * 60 +
        (parseInt(this.seconds) || 0);

    if (totalSeconds <= 0) {
      // 注意：API 10 中 showToast 已废弃，但 DevEco 仍支持（会警告但能运行）
      // 更推荐用 AlertDialog，但为简化，这里保留
      promptAction.showToast({ message: '请输入有效时间' });
      return;
    }

    this.timeLeft = totalSeconds;
    this.isRunning = true;
    this.tick();
  }

  tick() {
    if (this.timeLeft <= 0) {
      this.isRunning = false;
      promptAction.showToast({ message: '时间到！', duration: 3000 });
      return;
    }

    if (this.isRunning) {
      this.timeLeft--;
      this.timerId = setTimeout(() => {
        this.tick();
      }, 1000);
    }
  }

  pauseTimer() {
    this.isRunning = false;
    if (this.timerId !== -1) {
      clearTimeout(this.timerId);
      this.timerId = -1;
    }
  }

  resetTimer() {
    this.pauseTimer();
    this.hours = '0';
    this.minutes = '0';
    this.seconds = '0';
    this.timeLeft = 0;
  }

  formatTime(seconds: number): string {
    const h = Math.floor(seconds / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    const s = seconds % 60;
    return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  }

  build() {
    Column({ space: 20 }) {
      Button('← 返回首页')
        .margin({top:10, bottom:10})
        .onClick(()=>{
          router.back();
        })

      Text('⏳ 倒计时器')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 50 })

      Text(this.formatTime(this.timeLeft))
        .fontSize(48)
        .fontColor('#2c3e50')
        .margin({ top: 20 })

      Row({ space: 10 }) {
        TextInput({ placeholder: '时', text: this.hours })
          .type(InputType.Number)
          .width(80)
          .onChange((value) => { this.hours = value; })

        Text(':').fontSize(24)

        TextInput({ placeholder: '分', text: this.minutes })
          .type(InputType.Number)
          .width(80)
          .onChange((value) => { this.minutes = value; })

        Text(':').fontSize(24)

        TextInput({ placeholder: '秒', text: this.seconds })
          .type(InputType.Number)
          .width(80)
          .onChange((value) => { this.seconds = value; })
      }
      .margin({ top: 30 })

      Row({ space: 20 }) {
        Button(this.isRunning ? '暂停' : '开始')
          .onClick(() => {
            if (this.isRunning) this.pauseTimer();
            else this.startTimer();
          })
          .width(100).height(40)

        Button('重置')
          .onClick(() => this.resetTimer())
          .width(100).height(40)
          .backgroundColor('#e74c3c').fontColor(Color.White)
      }
      .margin({ top: 30 })
    }
    .width('100%').height('100%').padding(20)
  }
}