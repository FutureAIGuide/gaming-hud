<script lang="ts">
  import { hudState } from '../state/hud.svelte.ts';

  type Guide = {
    id: string;
    title: string;
    gameId: string;
    gameName: string;
    sectionCount?: number;
    updatedAt?: string;
  };

  type Game = {
    id: string;
    name: string;
    guides?: Guide[];
  };

  type LayoutItem = Guide & {
    gameName: string;
  };

  const {
    games = [],
    activeGuide = null,
    onSelectGuide
  }: {
    games: Game[];
    activeGuide: Guide | null;
    onSelectGuide: (guide: Guide) => void;
  } = $props();

  let isVisible = $state(true);

  const layoutItems = $derived<LayoutItem[]>(
    games.flatMap((game) =>
      (game.guides ?? []).map((guide) => ({
        ...guide,
        gameName: game.name
      }))
    )
  );

  const hasItems = $derived(layoutItems.length > 0);

  function handleToggleVisibility() {
    isVisible = !isVisible;
  }

  function handleSelect(guide: Guide) {
    onSelectGuide?.(guide);
  }
</script>

<section
  class="hud-shell fixed inset-4 pointer-events-none"
  style={`z-index: ${hudState.zLayer};`}
  aria-label="Gaming HUD overlay container"
>
  <div class="pointer-events-auto h-full w-full">
    <header class="mb-3 flex items-center justify-between rounded-2xl border border-white/20 bg-white/10 px-4 py-2 text-white backdrop-blur-md">
      <h2 class="text-sm font-semibold tracking-wide" aria-label="HUD title">
        Gaming Guide HUD
      </h2>

      <button
        type="button"
        class="rounded-lg border border-white/25 bg-black/30 px-3 py-1.5 text-xs font-medium text-white hover:bg-black/40 focus:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300"
        onclick={handleToggleVisibility}
        aria-label="Toggle HUD guides visibility"
        aria-pressed={!isVisible}
      >
        {isVisible ? "Hide" : "Show"}
      </button>
    </header>

    {#if isVisible}
      <ul
        class="hud-grid rounded-2xl border border-white/20 bg-white/10 p-3 text-white backdrop-blur-[10px]"
        aria-label="Available game guides"
      >
        {#if hasItems}
          {#each layoutItems as guide (guide.id)}
            <li
              class="rounded-xl border border-white/15 bg-black/25 p-3 transition-transform duration-150 hover:scale-[1.01] focus-within:scale-[1.01]"
              aria-current={activeGuide?.id === guide.id ? 'true' : undefined}
            >
              <button
                type="button"
                class="w-full rounded-md text-left focus:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 focus-visible:ring-offset-2 focus-visible:ring-offset-zinc-900"
                onclick={() => handleSelect(guide)}
                aria-label={`Select guide ${guide.title}`}
              >
                <p class="text-xs uppercase tracking-wide text-cyan-200/90">{guide.gameName}</p>
                <h3 class="mt-1 text-sm font-semibold">{guide.title}</h3>
                <p class="mt-2 text-xs text-white/80">
                  {guide.sectionCount ?? 0} sections
                </p>
              </button>

              {#if activeGuide?.id === guide.id}
                <p class="mt-2 text-[11px] font-medium text-emerald-300" aria-label="Active guide">
                  Active
                </p>
              {/if}
            </li>
          {/each}
        {:else}
          <li class="col-span-full list-none rounded-xl border border-dashed border-white/25 bg-black/20 p-4 text-sm text-white/80">
            <p>No guides yet. Add guides to a game to populate this HUD.</p>
          </li>
        {/if}
      </ul>
    {/if}
  </div>
</section>

<style>
  .hud-grid {
    display: grid;
    gap: 0.75rem;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    list-style: none;
    margin: 0;
    padding-left: 0;
  }

  @media (min-width: 1280px) {
    .hud-grid {
      grid-template-columns: repeat(4, minmax(0, 1fr));
    }
  }
</style>
