<script lang="ts">
  async function getInfoAboutDate(date: string): Promise<any> {
    let response = await fetch(`https://sholiday.faboul.se/dagar/v2.1/${date}`);
    let data = await response.json();
    return data;
  }

  function isHoliday(date: object): Boolean {
    return date["dagar"][0]["röd dag"] == "Ja";
  }

  function isNonWorkday(date: object): Boolean {
    return date["dagar"][0]["arbetsfri dag"] == "Ja";
  }

  const today = new Date();
  let dd = String(today.getDate()).padStart(2, "0");
  let mm = String(today.getMonth() + 1).padStart(2, "0");
  let yyyy = today.getFullYear();
  const today_string = `${yyyy}/${mm}/${dd}`;

  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);
  dd = String(tomorrow.getDate()).padStart(2, "0");
  mm = String(tomorrow.getMonth() + 1).padStart(2, "0");
  yyyy = tomorrow.getFullYear();
  const tomorrow_string = `${yyyy}/${mm}/${dd}`;
</script>

<main>
  {#await getInfoAboutDate(today_string)}
    <p />
  {:then today_info}
    {#await getInfoAboutDate(tomorrow_string)}
      <p />
    {:then tomorrow_info}
      {#if isHoliday(today_info)}
        <h1>Ja!</h1>
        {#if isNonWorkday(tomorrow_info)}
          <h3>och imorgon är OCKSÅ en ledig dag!!</h3>
        {:else}
          <h3>men imorgon är en arbetsdag...</h3>
        {/if}
      {:else}
        <h1>Nej</h1>
        {#if isNonWorkday(today_info)}
          <h2>men det är en ledig dag!</h2>
          {#if isNonWorkday(tomorrow_info)}
            <h3>och imorgon är OCKSÅ en ledig dag!!</h3>
          {/if}
        {:else}
          <h2>och inte är det en ledig dag heller...</h2>
          {#if isNonWorkday(tomorrow_info)}
            <h3>men imorgon är i alla fall en ledig dag!</h3>
          {/if}
        {/if}
      {/if}
    {/await}
  {/await}
</main>

<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  h1 {
    color: #ff3e00;
    text-transform: uppercase;
    font-size: 4em;
    font-weight: normal;
  }

  h2 {
    color: gray;
    font-size: 2em;
    font-weight: 100;
  }

  h3 {
    color: gray;
    font-style: italic;
    font-size: 2em;
    font-weight: 100;
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>
