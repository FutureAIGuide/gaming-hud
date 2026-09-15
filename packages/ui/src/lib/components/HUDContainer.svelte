<script lang="ts">
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

  const layoutItems = $derived(
    games.flatMap((game) =>
      (game.guides ?? []).map((guide: Guide) => ({
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
  class="hud-shell fixed inset-4 z-[2147483000] pointer-events-none"
  aria-label="Gaming HUD overlay container"
>
  <div class="pointer-events-auto h-full w-full">
    <header class="mb-3 flex items-center justify-between rounded-2xl border border-white/20 bg-white/10 px-4 py-2 text-white backdrop-blur-md">
      <h2 class="text-sm font-semibold tracking-wide" aria-label="HUD title">
        Gaming Guide HUD
      </h2>

      <button
        class="rounded-lg border border-white/25 bg-black/30 px-3 py-1.5 text-xs font-medium text-white hover:bg-black/40 focus:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300"
        onclick={handleToggleVisibility}
        aria-label={isVisible ? "Hide HUD guides" : "Show HUD guides"}
        aria-pressed={!isVisible}
      >
        {isVisible ? "Hide" : "Show"}
      </button>
    </header>

    {#if isVisible}
      <div
        class="hud-grid rounded-2xl border border-white/20 bg-white/10 p-3 text-white backdrop-blur-[10px]"
        role="list"
        aria-label="Available game guides"
      >
        {#if hasItems}
          {#each layoutItems as guide (guide.id)}
            <article
              role="listitem"
              class="will-change-auto rounded-xl border border-white/15 bg-black/25 p-3 transition-transform duration-150 hover:scale-[1.01] focus-within:scale-[1.01]"
              aria-label={`Guide card: ${guide.title} for ${guide.gameName}`}
            >
              <button
                class="w-full rounded-md text-left focus:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300"
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
            </article>
          {/each}
        {:else}
          <p class="col-span-full rounded-xl border border-dashed border-white/25 bg-black/20 p-4 text-sm text-white/80">
            No guides yet. Add guides to a game to populate this HUD.
          </p>
        {/if}
      </div>
    {/if}
  </div>
</section>

<style>
  .hud-shell {
    z-index: 2147483000;
  }

  .hud-grid {
    display: grid;
    gap: 0.75rem;
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  @media (min-width: 1280px) {
    .hud-grid {
      grid-template-columns: repeat(4, minmax(0, 1fr));
    }
  }
</style>
