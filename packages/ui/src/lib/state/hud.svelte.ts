type HudStateSnapshot = {
  overlayVisible: boolean;
  activeGameId: string | null;
  activeGuideId: string | null;
  zLayer: number;
};

type HudState = HudStateSnapshot & {
  setActiveGame: (gameId: string | null) => void;
  setActiveGuide: (guideId: string | null) => void;
  toggleOverlay: () => void;
  snapshot: () => HudStateSnapshot;
};

export const hudState = $state({
  overlayVisible: true,
  activeGameId: null,
  activeGuideId: null,
  zLayer: 2147483000,
}) as HudState;

hudState.setActiveGame = (gameId: string | null): void => {
  hudState.activeGameId = gameId;
};

hudState.setActiveGuide = (guideId: string | null): void => {
  hudState.activeGuideId = guideId;
};

hudState.toggleOverlay = (): void => {
  hudState.overlayVisible = !hudState.overlayVisible;
};

hudState.snapshot = (): HudStateSnapshot => {
  const state = $state.snapshot(hudState);
  return {
    overlayVisible: state.overlayVisible,
    activeGameId: state.activeGameId,
    activeGuideId: state.activeGuideId,
    zLayer: state.zLayer,
  };
};
