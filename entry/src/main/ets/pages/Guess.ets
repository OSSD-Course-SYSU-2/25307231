import router from '@ohos.router';

@Entry
@Component
struct GuessNumberGame {
  // 目标随机数 1-100
  private targetNum: number = Math.floor(Math.random() * 100) + 1;
  // 用户输入的数字
  @State userInput: string = '';
  // 提示文案
  @State tipText: string = '请输入1~100之间的数字开始猜测';
  // 猜测次数
  @State count: number = 0;
  // 最大猜测次数
  private maxTry: number = 7;
  // 游戏是否结束
  @State gameOver: boolean = false;

  // 重置游戏
  resetGame() {
    this.targetNum = Math.floor(Math.random() * 100) + 1;
    this.userInput = '';
    this.tipText = '请输入1~100之间的数字开始猜测';
    this.count = 0;
    this.gameOver = false;
  }

  // 猜测逻辑
  checkNumber() {
    // 如果游戏已经结束，直接返回不能再猜
    if (this.gameOver) {
      return;
    }

    let num = parseInt(this.userInput);
    // 判断是否合法数字
    if (isNaN(num) || num < 1 || num > 100) {
      this.tipText = '请输入合法的 1~100 整数！';
      return;
    }

    this.count++;
    if (num > this.targetNum) {
      this.tipText = `猜大了！还剩${this.maxTry - this.count}次机会`;
    } else if (num < this.targetNum) {
      this.tipText = `猜小了！还剩${this.maxTry - this.count}次机会`;
    } else {
      this.tipText = `🎉恭喜猜对了！答案就是${this.targetNum}，一共猜了${this.count}次`;
      this.gameOver = true;
      return;
    }

    // 判断是否用完7次机会
    if (this.count >= this.maxTry) {
      this.tipText = `游戏结束！7次机会用完，答案是${this.targetNum}`;
      this.gameOver = true;
    }
  }

  build() {
    Column() {
      Button('← 返回首页')
        .margin({top:10, bottom:10})
        .onClick(()=>{
          router.back();
        })

      Text('猜数字游戏')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 30 });

      // 提示文本
      Text(this.tipText)
        .fontSize(18)
        .margin({ bottom: 20 })
        .textAlign(TextAlign.Center);

      // 输入框
      TextInput({ text: this.userInput, placeholder: '请输入数字' })
        .type(InputType.Number)
        .enabled(!this.gameOver) // 游戏结束禁用输入框
        .onChange((value: string) => {
          this.userInput = value;
        })
        .width('80%')
        .height(50)
        .margin({ bottom: 20 });

      // 按钮区域
      Row() {
        Button('提交猜测')
          .enabled(!this.gameOver) // 游戏结束禁用提交按钮
          .onClick(() => this.checkNumber())
          .margin({ right: 15 });

        Button('重新开局')
          .onClick(() => this.resetGame())
          .backgroundColor('#666');
      }

    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(20)
  }
}
