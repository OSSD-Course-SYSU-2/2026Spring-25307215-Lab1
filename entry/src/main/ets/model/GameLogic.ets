import { GRID_SIZE, WIN_SCORE } from '../common/Constants';

export enum Direction {
  UP,
  DOWN,
  LEFT,
  RIGHT,
}

// 定义一个类来表示空格子的坐标
class EmptyCell {
  row: number = 0;
  col: number = 0;
}

export class GameLogic {
  private grid: number[][] = [];
  public score: number = 0;
  public isWin: boolean = false;
  public isLose: boolean = false;

  constructor() {
    this.init();
  }

  // 获取当前棋盘
  getGrid(): number[][] {
    return this.grid;
  }

  // 初始化游戏
  init(): void {
    // 创建空棋盘
    this.grid = Array(GRID_SIZE).fill(0).map(() => Array(GRID_SIZE).fill(0));
    this.score = 0;
    this.isWin = false;
    this.isLose = false;

    // 添加两个初始数字
    this.addRandomTile();
    this.addRandomTile();
  }

  // 随机添加一个数字（2或4）
  private addRandomTile(): void {
    // 收集所有空格子
    let emptyCells: EmptyCell[] = [];
    for (let i = 0; i < GRID_SIZE; i++) {
      for (let j = 0; j < GRID_SIZE; j++) {
        if (this.grid[i][j] === 0) {
          let cell: EmptyCell = new EmptyCell();
          cell.row = i;
          cell.col = j;
          emptyCells.push(cell);
        }
      }
    }

    if (emptyCells.length === 0) {
      return;
    }

    // 随机选一个空格子
    let randomIndex: number = Math.floor(Math.random() * emptyCells.length);
    let selectedCell: EmptyCell = emptyCells[randomIndex];
    // 90%概率生成2，10%概率生成4
    this.grid[selectedCell.row][selectedCell.col] = Math.random() < 0.9 ? 2 : 4;
  }

  // 移动主入口
  move(direction: Direction): boolean {
    if (this.isWin || this.isLose) {
      return false;
    }

    let moved: boolean = false;
    if (direction === Direction.LEFT) {
      moved = this.moveLeft();
    } else if (direction === Direction.RIGHT) {
      moved = this.moveRight();
    } else if (direction === Direction.UP) {
      moved = this.moveUp();
    } else if (direction === Direction.DOWN) {
      moved = this.moveDown();
    }

    if (moved) {
      this.addRandomTile();
      this.checkWin();
      if (!this.isWin) {
        this.checkLose();
      }
    }

    return moved;
  }

  // ========== 移动逻辑 ==========

  private moveLeft(): boolean {
    let moved: boolean = false;
    for (let i = 0; i < GRID_SIZE; i++) {
      // 1. 去掉空格
      let row: number[] = [];
      for (let k = 0; k < GRID_SIZE; k++) {
        if (this.grid[i][k] !== 0) {
          row.push(this.grid[i][k]);
        }
      }

      // 2. 相邻合并
      for (let j = 0; j < row.length - 1; j++) {
        if (row[j] === row[j + 1]) {
          row[j] = row[j] * 2;
          this.score = this.score + row[j];
          row.splice(j + 1, 1);
        }
      }

      // 3. 补零
      let newRow: number[] = [];
      for (let k = 0; k < row.length; k++) {
        newRow.push(row[k]);
      }
      while (newRow.length < GRID_SIZE) {
        newRow.push(0);
      }

      // 检查是否有变化
      let hasChanged: boolean = false;
      for (let k = 0; k < GRID_SIZE; k++) {
        if (this.grid[i][k] !== newRow[k]) {
          hasChanged = true;
          break;
        }
      }
      if (hasChanged) {
        moved = true;
        for (let k = 0; k < GRID_SIZE; k++) {
          this.grid[i][k] = newRow[k];
        }
      }
    }
    return moved;
  }

  private moveRight(): boolean {
    let moved: boolean = false;
    for (let i = 0; i < GRID_SIZE; i++) {
      // 1. 去掉空格
      let row: number[] = [];
      for (let k = GRID_SIZE - 1; k >= 0; k--) {
        if (this.grid[i][k] !== 0) {
          row.push(this.grid[i][k]);
        }
      }

      // 2. 相邻合并
      for (let j = 0; j < row.length - 1; j++) {
        if (row[j] === row[j + 1]) {
          row[j] = row[j] * 2;
          this.score = this.score + row[j];
          row.splice(j + 1, 1);
        }
      }

      // 3. 补零
      let newRow: number[] = [];
      for (let k = 0; k < row.length; k++) {
        newRow.push(row[k]);
      }
      while (newRow.length < GRID_SIZE) {
        newRow.push(0);
      }
      // 反转回来
      let finalRow: number[] = [];
      for (let k = newRow.length - 1; k >= 0; k--) {
        finalRow.push(newRow[k]);
      }

      // 检查是否有变化
      let hasChanged: boolean = false;
      for (let k = 0; k < GRID_SIZE; k++) {
        if (this.grid[i][k] !== finalRow[k]) {
          hasChanged = true;
          break;
        }
      }
      if (hasChanged) {
        moved = true;
        for (let k = 0; k < GRID_SIZE; k++) {
          this.grid[i][k] = finalRow[k];
        }
      }
    }
    return moved;
  }

  private moveUp(): boolean {
    // 先转置
    this.transpose();
    let moved: boolean = this.moveLeft();
    // 再转置回来
    this.transpose();
    return moved;
  }

  private moveDown(): boolean {
    // 先转置
    this.transpose();
    let moved: boolean = this.moveRight();
    // 再转置回来
    this.transpose();
    return moved;
  }

  // 矩阵转置（用于上下滑动）
  private transpose(): void {
    let newGrid: number[][] = [];
    for (let i = 0; i < GRID_SIZE; i++) {
      let newRow: number[] = [];
      for (let j = 0; j < GRID_SIZE; j++) {
        newRow.push(0);
      }
      newGrid.push(newRow);
    }

    for (let i = 0; i < GRID_SIZE; i++) {
      for (let j = 0; j < GRID_SIZE; j++) {
        newGrid[j][i] = this.grid[i][j];
      }
    }
    this.grid = newGrid;
  }

  // ========== 胜负判定 ==========

  private checkWin(): void {
    for (let i = 0; i < GRID_SIZE; i++) {
      for (let j = 0; j < GRID_SIZE; j++) {
        if (this.grid[i][j] >= WIN_SCORE) {
          this.isWin = true;
          return;
        }
      }
    }
  }

  private checkLose(): void {
    // 检查是否有空格
    for (let i = 0; i < GRID_SIZE; i++) {
      for (let j = 0; j < GRID_SIZE; j++) {
        if (this.grid[i][j] === 0) {
          return;
        }
      }
    }
    // 检查是否有相邻相同数字
    for (let i = 0; i < GRID_SIZE; i++) {
      for (let j = 0; j < GRID_SIZE; j++) {
        let currentVal: number = this.grid[i][j];
        if (j + 1 < GRID_SIZE && this.grid[i][j + 1] === currentVal) {
          return;
        }
        if (i + 1 < GRID_SIZE && this.grid[i + 1][j] === currentVal) {
          return;
        }
      }
    }
    this.isLose = true;
  }
}