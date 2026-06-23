import { Tile } from '../widget/components/Tile'
import router from '@ohos.router';

@Entry
@Component
struct Game2048 {
  @StorageProp('systemDark') isDark: boolean = false;

  @State r0: number[] = [0,0,0,0];
  @State r1: number[] = [0,0,0,0];
  @State r2: number[] = [0,0,0,0];
  @State r3: number[] = [0,0,0,0];

  @State isWin: boolean = false;
  @State isGameOver: boolean = false;
  private cellSize: number = 72;

  aboutToAppear() {
    this.initGame();
  }

  getBoard(): number[][] {
    return [this.r0.slice(), this.r1.slice(), this.r2.slice(), this.r3.slice()];
  }

  setBoard(b: number[][]) {
    this.r0 = b[0].slice();
    this.r1 = b[1].slice();
    this.r2 = b[2].slice();
    this.r3 = b[3].slice();
  }

  initGame() {
    let b = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]];
    this.setBoard(b);
    this.isWin = false;
    this.isGameOver = false;
    this.randomNewNum();
    this.randomNewNum();
  }

  randomNewNum() {
    let b = this.getBoard();
    let emptyPos: number[][] = [];
    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 4; j++) {
        if (b[i][j] === 0) emptyPos.push([i,j]);
      }
    }
    if (emptyPos.length === 0) return;
    let idx = Math.floor(Math.random() * emptyPos.length);
    let x = emptyPos[idx][0];
    let y = emptyPos[idx][1];
    b[x][y] = Math.random() > 0.5 ? 2 : 4;
    this.setBoard(b);
  }

  slideRow(arr: number[]): number[] {
    let res: number[] = [];
    for (let n of arr) if (n !== 0) res.push(n);
    for (let i = 0; i < res.length - 1; i++) {
      if (res[i] === res[i+1]) {
        res[i] *= 2;
        res.splice(i+1, 1);
      }
    }
    while (res.length < 4) res.push(0);
    return res;
  }

  moveLeftAll() {
    let b = this.getBoard();
    for (let i = 0; i < 4; i++) b[i] = this.slideRow(b[i]);
    this.setBoard(b);
  }

  moveRightAll() {
    let b = this.getBoard();
    for (let i = 0; i < 4; i++) {
      let rev = b[i].reverse();
      rev = this.slideRow(rev);
      b[i] = rev.reverse();
    }
    this.setBoard(b);
  }

  moveUpAll() {
    let b = this.getBoard();
    for (let col = 0; col < 4; col++) {
      let colArr: number[] = [];
      for (let row = 0; row < 4; row++) colArr.push(b[row][col]);
      colArr = this.slideRow(colArr);
      for (let row = 0; row < 4; row++) b[row][col] = colArr[row];
    }
    this.setBoard(b);
  }

  moveDownAll() {
    let b = this.getBoard();
    for (let col = 0; col < 4; col++) {
      let colArr: number[] = [];
      for (let row = 0; row < 4; row++) colArr.push(b[row][col]);
      colArr = colArr.reverse();
      colArr = this.slideRow(colArr);
      colArr = colArr.reverse();
      for (let row = 0; row < 4; row++) b[row][col] = colArr[row];
    }
    this.setBoard(b);
  }

  checkWinAll() {
    let b = this.getBoard();
    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 4; j++) {
        if (b[i][j] === 2048) {
          this.isWin = true;
          return;
        }
      }
    }
  }

  checkLose(): boolean {
    let b = this.getBoard();
    for (let i = 0; i < 4; i++) for (let j = 0; j < 4; j++) if (b[i][j] === 0) return false;
    for (let i = 0; i < 4; i++) for (let j = 0; j < 3; j++) if (b[i][j] === b[i][j+1]) return false;
    for (let j = 0; j < 4; j++) for (let i = 0; i < 3; i++) if (b[i][j] === b[i+1][j]) return false;
    return true;
  }

  doMove(dir: string) {
    if (this.isWin || this.isGameOver) return;
    let oldStr = JSON.stringify(this.getBoard());
    if (dir === 'up') this.moveUpAll();
    if (dir === 'down') this.moveDownAll();
    if (dir === 'left') this.moveLeftAll();
    if (dir === 'right') this.moveRightAll();
    let newStr = JSON.stringify(this.getBoard());
    if (oldStr !== newStr) this.randomNewNum();
    this.checkWinAll();
    if (this.checkLose()) this.isGameOver = true;
  }

  build() {
    Scroll() {
      Column() {
        // 返回按钮 深青渐变
        Button('← 返回首页')
          .width(100)
          .height(44)
          .borderRadius(14)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor("#ffffff")
          .linearGradient(new LinearGradient([
            {color: "#18a888", offset:0},
            {color: "#047d63", offset:1}
          ]))
          .shadow({radius: 6, color: 'rgba(0,0,0,0.22)', offsetX: 2, offsetY: 3})
          .margin({top:10, bottom:16})
          .onClick(()=>{
            router.back();
          })

        Text('2048')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .margin({bottom:6})
          .fontColor(this.isDark ? "#ffffff" : "#2d2d2d")
        Text('经典数字合成游戏')
          .fontSize(16)
          .fontColor(this.isDark ? "#bbbbbb" : "#777777")
          .margin({bottom:20})

        if (this.isWin) {
          Text('🎉 恭喜合成2048，游戏通关！')
            .fontSize(20)
            .fontColor('#28c740')
            .margin({bottom:10})
        }
        if (this.isGameOver && !this.isWin) {
          Text('😥 棋盘已满，无法继续合并')
            .fontSize(20)
            .fontColor('#f24747')
            .margin({bottom:10})
        }

        Column({space:6}) {
          Row({space:6}){
            ForEach(this.r0,(n:number)=>{
              Tile({ num: n })
                .width(this.cellSize).height(this.cellSize)
            })
          }
          Row({space:6}){
            ForEach(this.r1,(n:number)=>{
              Tile({ num: n })
                .width(this.cellSize).height(this.cellSize)
            })
          }
          Row({space:6}){
            ForEach(this.r2,(n:number)=>{
              Tile({ num: n })
                .width(this.cellSize).height(this.cellSize)
            })
          }
          Row({space:6}){
            ForEach(this.r3,(n:number)=>{
              Tile({ num: n })
                .width(this.cellSize).height(this.cellSize)
            })
          }
        }
        .backgroundColor("#8C7B6B")
        .borderRadius(16)
        .padding(10)
        .margin({bottom:24})

        Column({space:12}){
          // 上 深紫蓝
          Button('↑ 上')
            .width(100)
            .height(44)
            .borderRadius(14)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor("#ffffff")
            .linearGradient(new LinearGradient([
              {color: "#6045d8", offset:0},
              {color: "#2c1891", offset:1}
            ]))
            .shadow({radius: 6, color: 'rgba(0,0,0,0.22)', offsetX: 2, offsetY: 3})
            .onClick(()=>{
              this.doMove('up');
            })
          Row({space:16}){
            // 左
            Button('← 左')
              .width(100)
              .height(44)
              .borderRadius(14)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor("#ffffff")
              .linearGradient(new LinearGradient([
                {color: "#6045d8", offset:0},
                {color: "#2c1891", offset:1}
              ]))
              .shadow({radius: 6, color: 'rgba(0,0,0,0.22)', offsetX: 2, offsetY: 3})
              .onClick(()=>{
                this.doMove('left');
              })
            // 右
            Button('→ 右')
              .width(100)
              .height(44)
              .borderRadius(14)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor("#ffffff")
              .linearGradient(new LinearGradient([
                {color: "#6045d8", offset:0},
                {color: "#2c1891", offset:1}
              ]))
              .shadow({radius: 6, color: 'rgba(0,0,0,0.22)', offsetX: 2, offsetY: 3})
              .onClick(()=>{
                this.doMove('right');
              })
          }
          // 下
          Button('↓ 下')
            .width(100)
            .height(44)
            .borderRadius(14)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor("#ffffff")
            .linearGradient(new LinearGradient([
              {color: "#6045d8", offset:0},
              {color: "#2c1891", offset:1}
            ]))
            .shadow({radius: 6, color: 'rgba(0,0,0,0.22)', offsetX: 2, offsetY: 3})
            .onClick(()=>{
              this.doMove('down');
            })
        }

        // 重新开局 橙红深色渐变
        Button('🔄 重新开局')
          .width(100)
          .height(44)
          .borderRadius(14)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor("#ffffff")
          .linearGradient(new LinearGradient([
            {color: "#ff5e33", offset:0},
            {color: "#c42400", offset:1}
          ]))
          .shadow({radius: 6, color: 'rgba(0,0,0,0.22)', offsetX: 2, offsetY: 3})
          .margin({top:24, bottom:40})
          .onClick(()=>{
            this.initGame();
          })

      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding(24)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isDark ? 'rgba(24,24,30,0.9)' : 'rgba(255,255,255,0.92)')
    .borderRadius(28)
    .shadow({
      radius: 22,
      color: 'rgba(0,0,0,0.15)',
      offsetX: 0,
      offsetY: 8
    })
    .border({
      width: 1,
      color: this.isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.06)',
      radius: 28
    })
  }
}