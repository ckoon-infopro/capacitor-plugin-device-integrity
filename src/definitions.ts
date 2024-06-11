export interface IRootPlugin {
  isRooted(): Promise<{ value: boolean }>;
}
