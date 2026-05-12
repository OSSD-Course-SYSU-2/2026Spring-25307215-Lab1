// 棋盘大小
export const GRID_SIZE: number = 4;

// 目标分数
export const WIN_SCORE: number = 2048;

// 数字对应的背景颜色
export const COLOR_MAP: Record<number, string> = {
  0: '#CDC1B4',
  2: '#EEE4DA',
  4: '#EDE0C8',
  8: '#F2B179',
  16: '#F59563',
  32: '#F67C5F',
  64: '#F65E3B',
  128: '#EDCF72',
  256: '#EDCC61',
  512: '#EDC850',
  1024: '#EDC53F',
  2048: '#EDC22E',
};

// 大数字时的文字颜色
export const DARK_TEXT_THRESHOLD: number = 8;
export const LIGHT_TEXT_COLOR: string = '#F9F6F2';
export const DARK_TEXT_COLOR: string = '#776E65';