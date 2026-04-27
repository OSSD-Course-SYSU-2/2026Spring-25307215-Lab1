import { GameLogic, Direction } from '../model/GameLogic';
import { GRID_SIZE, COLOR_MAP, DARK_TEXT_COLOR, LIGHT_TEXT_COLOR, DARK_TEXT_THRESHOLD } from '../common/Constants';

@Entry
@Component
struct Index {
  @State gameLogic: GameLogic = new GameLogic();
  @State grid: number[][] = [];
  @State score: number = 0;
  @State isWin: boolean = false;
  @State isLose: boolean = false;

  // 触摸滑动相关变量
  private startX: number = 0;
  private startY: number = 0;
  private touchStartTime: number = 0;

  aboutToAppear(): void {
    this.refreshUI();
  }

  refreshUI(): void {
    this.grid = this.gameLogic.getGrid();
    this.score = this.gameLogic.score;
    this.isWin = this.gameLogic.isWin;
    this.isLose = this.gameLogic.isLose;
  }

  // 处理移动
  handleMove(direction: Direction): void {
    this.gameLogic.move(direction);
    this.refreshUI();
  }

  // 新游戏
  newGame(): void {
    this.gameLogic.init();
    this.refreshUI();
  }

  // 根据数字获取背景颜色
  getBackgroundColor(value: number): string {
    return COLOR_MAP[value] || '#EDC22E';
  }

  // 根据数字获取文字颜色
  getTextColor(value: number): string {
    return value >= DARK_TEXT_THRESHOLD ? LIGHT_TEXT_COLOR : DARK_TEXT_COLOR;
  }

  // 触摸开始
  onTouchStart(event: TouchEvent): void {
    this.startX = event.touches[0].x;
    this.startY = event.touches[0].y;
    this.touchStartTime = Date.now();
  }

  // 触摸结束，判断滑动方向
  onTouchEnd(event: TouchEvent): void {
    const endX = event.changedTouches[0].x;
    const endY = event.changedTouches[0].y;

    const deltaX = endX - this.startX;
    const deltaY = endY - this.startY;
    const absDeltaX = Math.abs(deltaX);
    const absDeltaY = Math.abs(deltaY);

    // 最小滑动距离阈值（防止误触）
    const minSwipeDistance = 30;
    // 最大滑动时间（毫秒）
    const maxSwipeTime = 300;

    const timeDiff = Date.now() - this.touchStartTime;

    if (timeDiff > maxSwipeTime) return;
    if (absDeltaX < minSwipeDistance && absDeltaY < minSwipeDistance) return;

    if (absDeltaX > absDeltaY) {
      // 水平滑动
      if (deltaX > 0) {
        this.handleMove(Direction.RIGHT);
      } else {
        this.handleMove(Direction.LEFT);
      }
    } else {
      // 垂直滑动
      if (deltaY > 0) {
        this.handleMove(Direction.DOWN);
      } else {
        this.handleMove(Direction.UP);
      }
    }
  }

  build() {
    Column() {
      // 顶部状态栏
      Row() {
        Text('2048')
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor('#776E65')
          .layoutWeight(1)

        Column() {
          Text('SCORE')
            .fontSize(14)
            .fontColor('#EEE4DA')
          Text(this.score.toString())
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width(100)
        .height(70)
        .backgroundColor('#BBADA0')
        .borderRadius(10)
        .justifyContent(FlexAlign.Center)
        .margin({ left: 10 })

        Button('新游戏')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('#8F7A66')
          .borderRadius(10)
          .height(70)
          .margin({ left: 10 })
          .onClick(() => this.newGame())
      }
      .width('100%')
      .padding(16)
      .margin({ top: 20, bottom: 20 })

      // 胜利/失败弹窗
      if (this.isWin) {
        this.GameStatusDialog('恭喜胜利！', '🎉 你达到了2048！🎉')
      }
      if (this.isLose) {
        this.GameStatusDialog('游戏结束', '😢 没有可移动的方块了...')
      }

      // 游戏棋盘
      Grid() {
        ForEach(this.grid, (row: number[], rowIndex: number) => {
          ForEach(row, (value: number, colIndex: number) => {
            GridItem() {
              Text(value !== 0 ? value.toString() : '')
                .fontSize(value >= 100 ? 24 : value >= 10 ? 30 : 36)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.getTextColor(value))
                .backgroundColor(this.getBackgroundColor(value))
                .width('100%')
                .height('100%')
                .textAlign(TextAlign.Center)
                .borderRadius(8)
            }
            .padding(4)
          }, (colIndex: number) => `${rowIndex}_${colIndex}`)
        }, (rowIndex: number) => rowIndex.toString())
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .width('90%')
      .aspectRatio(1)
      .backgroundColor('#BBADA0')
      .borderRadius(12)
      .padding(8)
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down) {
          this.onTouchStart(event);
        } else if (event.type === TouchType.Up) {
          this.onTouchEnd(event);
        }
      })
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .width('90%')
      .aspectRatio(1)
      .backgroundColor('#BBADA0')
      .borderRadius(12)
      .padding(8)
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down) {
          this.onTouchStart(event);
        } else if (event.type === TouchType.Up) {
          this.onTouchEnd(event);
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAF8EF')
  }

  // 游戏状态弹窗组件
  @Builder
  GameStatusDialog(title: string, message: string) {
    Column() {
      Text(title)
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor('#776E65')
        .margin({ bottom: 10 })

      Text(message)
        .fontSize(18)
        .fontColor('#776E65')
        .margin({ bottom: 20 })

      Button('再来一局')
        .fontSize(18)
        .fontColor('#FFFFFF')
        .backgroundColor('#8F7A66')
        .borderRadius(10)
        .onClick(() => {
          this.newGame();
        })
    }
    .width('70%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ radius: 20, color: '#00000030' })
    .position({ x: '15%', y: '40%' })
  }
}