<script lang="ts">
  import HUDContainer from './lib/components/HUDContainer.svelte';
  import { hudState } from './state/hud.svelte.js';

  type Guide = {
    id: string;
    title: string;
    gameId: string;
    gameName: string;
    sectionCount?: number;
  };

  type Game = {
    id: string;
    name: string;
    guides: Guide[];
  };

  const games: Game[] = [
    {
      id: 'd2',
      name: 'Destiny 2',
      guides: [
        { id: 'd2-raid-1', title: 'King’s Fall Raid Route', gameId: 'd2', gameName: 'Destiny 2', sectionCount: 8 },
        { id: 'd2-build-1', title: 'Solar Titan PvE Build', gameId: 'd2', gameName: 'Destiny 2', sectionCount: 5 }
      ]
    },
    {
      id: 'poe',
      name: 'Path of Exile',
      guides: [
        { id: 'poe-map-1', title: 'Atlas Tree Starter', gameId: 'poe', gameName: 'Path of Exile', sectionCount: 6 },
        { id: 'poe-craft-1', title: 'Early Crafting Cheatsheet', gameId: 'poe', gameName: 'Path of Exile', sectionCount: 4 }
      ]
    }
  ];

  let activeGuide = $state<Guide | null>(null);

  function handleSelectGuide(guide: Guide) {
    if (activeGuide?.id === guide.id) {
      activeGuide = null;
      hudState.setActiveGuide(null);
      return;
    }

    activeGuide = guide;
    hudState.setActiveGame(guide.gameId);
    hudState.setActiveGuide(guide.id);
  }

  $effect(() => {
    const snap = hudState.snapshot();
    console.debug('HUD snapshot:', snap);
  });
</script>

<main class="min-h-screen bg-zinc-900 p-4 text-white">
  <div class="relative mb-4" style={`z-index: ${hudState.zLayer + 1};`}>
    <button
      type="button"
      class="rounded-md border border-white/25 bg-black/30 px-3 py-2 text-xs font-medium text-white hover:bg-black/40 focus:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300"
      onclick={() => hudState.toggleOverlay()}
      aria-label={hudState.overlayVisible ? 'Hide HUD overlay' : 'Show HUD overlay'}
      aria-pressed={hudState.overlayVisible}
    >
      {hudState.overlayVisible ? 'Hide HUD Overlay' : 'Show HUD Overlay'}
    </button>
  </div>

  <HUDContainer
    {games}
    {activeGuide}
    onSelectGuide={handleSelectGuide}
  />
</main>
