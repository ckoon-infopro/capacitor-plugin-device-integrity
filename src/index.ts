import { registerPlugin } from '@capacitor/core';

import type { IRootPlugin } from './definitions';

const IRoot = registerPlugin<IRootPlugin>('IRoot', {
  web: () => import('./web').then(m => new m.IRootWeb()),
});

export * from './definitions';
export { IRoot };
