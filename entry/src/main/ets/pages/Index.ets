import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Text('鸿蒙趣味工具合集')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 60, bottom: 50 })

      // 进入倒计时
      Button('⏱️ 倒计时计时器')
        .width('75%')
        .height(55)
        .margin({ bottom: 25 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Timer' });
        })

      // 进入猜数字
      Button('🎲 猜数字小游戏')
        .width('75%')
        .height(55)
        .margin({ bottom: 25 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Guess' });
        })

      // 进入2048
      Button('🧩 2048数字游戏')
        .width('75%')
        .height(55)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Game2048' });
        })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7FA')
    .justifyContent(FlexAlign.Center)
  }
}
