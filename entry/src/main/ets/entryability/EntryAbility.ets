import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'EntryAbility', 'onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'EntryAbility', 'onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(0x0000, 'EntryAbility', 'onWindowStageCreate');

    // 这一行是关键！加载 pages/Index 页面
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err) {
        hilog.error(0x0000, 'EntryAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'EntryAbility', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(0x0000, 'EntryAbility', 'onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(0x0000, 'EntryAbility', 'onForeground');
  }

  onBackground(): void {
    hilog.info(0x0000, 'EntryAbility', 'onBackground');
  }
}