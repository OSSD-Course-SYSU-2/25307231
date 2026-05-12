import router from '@ohos.router';

@Entry
@Component
struct Game2048 {
  // 拆分四行单独状态，解决UI不刷新
  @State r0: number[] = [0,0,0,0];
  @State r1: number[] = [0,0,0,0];
  @State r2: number[] = [0,0,0,0];
  @State r3: number[] = [0,0,0,0];

  @State isWin: boolean = false;
  @State isGameOver: boolean = false;
  private cellSize: number = 70;

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

  // 单行左移合并工具
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
    for (let i = 0; i < 4; i++) {
      b[i] = this.slideRow(b[i]);
    }
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
      for (let row = 0; row < 4; row++) {
        colArr.push(b[row][col]);
      }
      colArr = this.slideRow(colArr);
      for (let row = 0; row < 4; row++) {
        b[row][col] = colArr[row];
      }
    }
    this.setBoard(b);
  }

  moveDownAll() {
    let b = this.getBoard();
    for (let col = 0; col < 4; col++) {
      let colArr: number[] = [];
      for (let row = 0; row < 4; row++) {
        colArr.push(b[row][col]);
      }
      colArr = colArr.reverse();
      colArr = this.slideRow(colArr);
      colArr = colArr.reverse();
      for (let row = 0; row < 4; row++) {
        b[row][col] = colArr[row];
      }
    }
    this.setBoard(b);
  }

  // 检测胜利
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

  // 检测游戏失败：无空格 + 上下左右都不能合并
  checkLose(): boolean {
    let b = this.getBoard();
    // 还有空格，没失败
    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 4; j++) {
        if (b[i][j] === 0) return false;
      }
    }
    // 横向能否合并
    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 3; j++) {
        if (b[i][j] === b[i][j+1]) return false;
      }
    }
    // 纵向能否合并
    for (let j = 0; j < 4; j++) {
      for (let i = 0; i < 3; i++) {
        if (b[i][j] === b[i+1][j]) return false;
      }
    }
    return true;
  }

  doMove(dir: string) {
    // 胜利或失败后禁止再操作
    if (this.isWin || this.isGameOver) return;

    let oldStr = JSON.stringify(this.getBoard());

    if (dir === 'up') this.moveUpAll();
    if (dir === 'down') this.moveDownAll();
    if (dir === 'left') this.moveLeftAll();
    if (dir === 'right') this.moveRightAll();

    let newStr = JSON.stringify(this.getBoard());
    if (oldStr !== newStr) {
      this.randomNewNum();
    }

    // 判断胜利
    this.checkWinAll();
    // 判断失败
    if (this.checkLose()) {
      this.isGameOver = true;
    }
  }

  getBgColor(num: number): string {
    let map: Record<number,string> = {
      2:'#eee4da',4:'#ede0c8',8:'#f2b179',
      16:'#f59563',32:'#f67c5f',64:'#f65e3b',
      128:'#edcf72',256:'#edcc61',512:'#edc850',
      1024:'#edc53f',2048:'#edc22e'
    };
    return map[num] || '#cdc1b4';
  }

  build() {
    Column() {
      Button('← 返回首页')
        .margin({top:10, bottom:10})
        .onClick(()=>{
          router.back();
        })

      Text('2048 游戏')
        .fontSize(32).fontWeight(FontWeight.Bold).margin({bottom:10})

      // 胜利提示
      if (this.isWin) {
        Text('🎉 恭喜！合成2048，游戏胜利')
          .fontSize(20).fontColor('#00aa00').margin(5)
      }
      // 失败提示
      if (this.isGameOver && !this.isWin) {
        Text('😥 格子填满无法合并，游戏失败')
          .fontSize(20).fontColor('#ff3333').margin(5)
      }

      Column() {
        Row(){
          ForEach(this.r0,(n:number)=>{
            Text(n===0?'':n.toString())
              .width(this.cellSize).height(this.cellSize)
              .backgroundColor(this.getBgColor(n))
              .borderRadius(8).fontSize(22)
              .textAlign(TextAlign.Center).margin(2)
          })
        }
        Row(){
          ForEach(this.r1,(n:number)=>{
            Text(n===0?'':n.toString())
              .width(this.cellSize).height(this.cellSize)
              .backgroundColor(this.getBgColor(n))
              .borderRadius(8).fontSize(22)
              .textAlign(TextAlign.Center).margin(2)
          })
        }
        Row(){
          ForEach(this.r2,(n:number)=>{
            Text(n===0?'':n.toString())
              .width(this.cellSize).height(this.cellSize)
              .backgroundColor(this.getBgColor(n))
              .borderRadius(8).fontSize(22)
              .textAlign(TextAlign.Center).margin(2)
          })
        }
        Row(){
          ForEach(this.r3,(n:number)=>{
            Text(n===0?'':n.toString())
              .width(this.cellSize).height(this.cellSize)
              .backgroundColor(this.getBgColor(n))
              .borderRadius(8).fontSize(22)
              .textAlign(TextAlign.Center).margin(2)
          })
        }
      }
      .backgroundColor('#bbada0')
      .borderRadius(12).padding(8).margin({top:10})

      Column({space:10}){
        Button('↑ 上').width(100).onClick(()=>this.doMove('up'))
        Row({space:20}){
          Button('← 左').width(100).onClick(()=>this.doMove('left'))
          Button('→ 右').width(100).onClick(()=>this.doMove('right'))
        }
        Button('↓ 下').width(100).onClick(()=>this.doMove('down'))
      }.margin({top:20})

      Button('重新开始').margin({top:15}).onClick(()=>this.initGame())

    }
    .width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
