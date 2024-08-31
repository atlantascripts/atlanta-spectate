let allPlayers = [];
let currentlySpectating = false; 

$(document).ready(function() {
    $("body").hide(); 
});

function format(amount) {
    return parseFloat(amount).toLocaleString('en-US') + '$';
}

function renderPlayers(players) {
    $('#player-list').empty(); 

    players.forEach(player => {
        $('#player-list').append(`
            <tr class="border-b border-white/25 hover:bg-neutral-800 transition-all">
                <td class="px-2 py-2"><div class="bg-neutral-700 px-2 py-1 rounded">${player.id}</div></td>
                <td class="px-2 py-2"><div class="bg-neutral-700 px-2 py-1 rounded">${player.name}</div></td>
                <td class="px-2 py-2"><div class="bg-neutral-700 px-2 py-1 rounded">${player.icName}</div></td>
                <td class="px-2 py-2"><div class="bg-neutral-700 px-2 py-1 rounded">${player.group}</div></td>
                <td class="px-2 py-2"><div class="bg-neutral-700 px-2 py-1 rounded">${player.job}</div></td>
                <td class="px-2 py-2"><div class="bg-neutral-700 px-2 py-1 rounded">${format(player.cash)}</div></td>
                <td class="px-2 py-2"><div class="bg-neutral-700 px-2 py-1 rounded">${format(player.bank)}</div></td>
                <td class="px-2 py-2">
                    <button class="bg-neutral-600 hover:bg-neutral-700 text-gray-300 font-semibold py-2 px-4 rounded transition-all select-none" onclick="spectatePlayer(${player.id})">SPECTATE</button>
                </td>
            </tr>
        `);
    });

    $("#player-list").slideDown("slow"); 
}

window.addEventListener('message', function(event) {
    if (event.data.type === "openMenu") {
        allPlayers = event.data.players;
        renderPlayers(allPlayers);
        $("#playerCount").text(event.data.playerCount + " player's");
        $("body").fadeIn(500);
    }

    if (event.data.type === "closeMenu") {
        $("body").fadeOut(500);
    }

    if (event.data.type === "spectateStart") {
        currentlySpectating = true;
        $('#spectateOffContainer').fadeIn();
    }

    if (event.data.type === "spectateStop") {
        currentlySpectating = false;
        $('#spectateOffContainer').fadeOut(); 
    }
});

function spectatePlayer(id) {
    $.post('https://atlanta-spectate/spectatePlayer', JSON.stringify({
        player: {
            id: id
        }
    }));
}

$(document).on('click', '#spectateOffButton', function() {
    $.post('https://atlanta-spectate/stopSpectating', JSON.stringify({}));
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeMenu();
    }
});

function closeMenu() {
    $.post('https://atlanta-spectate/closeMenu', JSON.stringify({}));
}

function searchPlayers(query) {
    const filteredPlayers = allPlayers.filter(player => {
        return player.name.toLowerCase().includes(query.toLowerCase()) || 
               player.icName.toLowerCase().includes(query.toLowerCase()) ||
               player.job.toLowerCase().includes(query.toLowerCase());
    });
    renderPlayers(filteredPlayers);
}

$(document).on('input', '#searchBar', function() {
    const query = $(this).val();
    searchPlayers(query);
});
