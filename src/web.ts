import { WebPlugin } from '@capacitor/core';

import type { IRootPlugin } from './definitions';

export class IRootWeb
  extends WebPlugin
  implements IRootPlugin
{
  async isRooted(): Promise<{ value: boolean }> {
    return await { value: false };
  }
}
