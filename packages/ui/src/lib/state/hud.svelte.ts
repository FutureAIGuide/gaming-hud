type HudStateSnapshot = {
  overlayVisible: boolean;
  activeGameId: string | null;
  activeGuideId: string | null;
  zLayer: number;
};

const state = $state<HudStateSnapshot>({
  overlayVisible: true,
  activeGameId: null,
  activeGuideId: null,
  zLayer: 2147483000,
});

export const hudState = {
  get overlayVisible(): boolean {
    return state.overlayVisible;
  },
  get activeGameId(): string | null {
    return state.activeGameId;
  },
  get activeGuideId(): string | null {
    return state.activeGuideId;
  },
  get zLayer(): number {
    return state.zLayer;
  },
  setActiveGame(gameId: string | null): void {
    state.activeGameId = gameId;
  },
  setActiveGuide(guideId: string | null): void {
    state.activeGuideId = guideId;
  },
  toggleOverlay(): void {
    state.overlayVisible = !state.overlayVisible;
  },
  snapshot(): HudStateSnapshot {
    return $state.snapshot(state);
  },
};
